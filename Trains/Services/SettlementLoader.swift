//
//  SettlementLoaderProtocol.swift
//  Trains
//
//  Created by Симонов Иван Дмитриевич on 19.07.2025.
//

import Combine

@MainActor protocol SettlementLoaderProtocol {
	var settlementsPublisher: AnyPublisher<[SettlementShort], any Error> { get }
	func fetchAllStations()
}

@MainActor final class SettlementLoader: SettlementLoaderProtocol {
	private let stationService: StationListService
	private let cacheService: any StationCacheServiceProtocol

	private let subject = CurrentValueSubject<[SettlementShort], any Error>([])
	var settlementsPublisher: AnyPublisher<[SettlementShort], any Error> {
		subject.eraseToAnyPublisher()
	}

	init(
		stationService: StationListService,
		cacheService: any StationCacheServiceProtocol,
	) {
		self.stationService = stationService
		self.cacheService = cacheService
	}

	func fetchAllStations() {
		if let response = cacheService.loadCache() {
			let settlements = self.process(response)
			subject.send(settlements)
		}

		Task.detached {
			do {
				let response = try await self.stationService.getAllStations()
				let settlements = self.process(response)

				await MainActor.run {
					try? self.cacheService.saveCache(response)
					self.subject.send(settlements)
				}
			} catch {
				await MainActor.run {
					self.subject.send(completion: .failure(error))
				}
			}
		}
	}

	nonisolated func process(_ response: AllStationsResponse) -> [SettlementShort] {
		var result: [String: SettlementShort] = [:]

		guard let countries = response.countries,
			  let russia = countries.first(where: { $0.title == "Россия" }),
			  let regions = russia.regions else {
			return []
		}

		for region in regions {
			guard let settlements = region.settlements else { continue }

			for settlement in settlements {
				guard
					let code = settlement.codes?.yandex_code,
					let title = settlement.title,
					let stations = settlement.stations,
					!code.isEmpty,
					!title.isEmpty,
					!stations.isEmpty
				else { continue }

				guard stations.contains(where: { $0.transport_type == "train" }) else { continue }

				result[code] = (code, title, stations)
			}
		}

		return result.values.sorted { $0.title < $1.title }
	}
}
