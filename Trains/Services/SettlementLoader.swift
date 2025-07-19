//
//  SettlementLoaderProtocol.swift
//  Trains
//
//  Created by Симонов Иван Дмитриевич on 19.07.2025.
//

import Combine

@MainActor protocol SettlementLoaderProtocol {
	var settlementsPublisher: AnyPublisher<[SettlementShort], Never> { get }
	func fetchAllStations()
}

@MainActor final class SettlementLoader: SettlementLoaderProtocol {
	private let stationService: StationListService
	private let cacheService: StationCacheServiceProtocol

	private let subject = CurrentValueSubject<[SettlementShort], Never>([])
	var settlementsPublisher: AnyPublisher<[SettlementShort], Never> {
		subject.eraseToAnyPublisher()
	}

	init(
		stationService: StationListService,
		cacheService: StationCacheServiceProtocol,
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
				print(#function, error)
			}
		}
	}

	nonisolated func process(_ response: AllStationsResponse) -> [SettlementShort] {
		let settlements = response.countries?
			.first(where: { $0.title == "Россия" })?
			.regions?
			.compactMap(\.settlements)
			.flatMap { $0 }
			.compactMap { item -> SettlementShort? in
				guard
					let code = item.codes?.yandex_code,
					let title = item.title,
					let stations = item.stations,
					!code.isEmpty,
					!title.isEmpty,
					!stations.isEmpty
				else {
					return nil
				}
				return (code, title, stations)
			} ?? []

		let unique = Dictionary(uniqueKeysWithValues: settlements.map { ($0.code, $0) })
			.values
			.sorted { $0.title < $1.title }

		return Array(unique)
	}
}
