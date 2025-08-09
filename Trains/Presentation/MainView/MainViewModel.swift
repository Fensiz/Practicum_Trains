//
//  MainViewModel.swift
//  Trains
//
//  Created by Симонов Иван Дмитриевич on 15.07.2025.
//

import SwiftUI
import Combine

struct SimpleCarrier {
	let name: String
	let email: String?
	let phone: String?
	let imageURL: String?
}

@MainActor final class MainViewModel: ObservableObject {
	enum InternalError: Error {
		case noStations, apiError, responseError
	}
	@Published var stations: [SimpleStation] = []
	@Published var cities: [SettlementShort] = []
	@Published var citySearchText = ""
	@Published var stationSearchText: String = ""
	@Published var isLoading: Bool = false

	@Published var selectedFromStation: SimpleStation? = nil
	@Published var selectedToStation: SimpleStation? = nil

	@Published var fetchError: (any Error)? = nil
	private let onError: (any Error) -> Void

	var isFindButtonShowing: Bool {
		guard let selectedFromStation, let selectedToStation else {
			return false
		}
		return selectedFromStation != selectedToStation
	}

	private var allStations: [SimpleStation] = []
	private var allCities: [SettlementShort] = []

	private var loader: any SettlementLoaderProtocol
	private var searchService: any SearchServiceProtocol
	private var carrierService: any CarrierServiceProtocol
	private var cancellables = Set<AnyCancellable>()

	init(
		loader: any SettlementLoaderProtocol,
		searchService: any SearchServiceProtocol,
		carrierService: any CarrierServiceProtocol,
		onError: @escaping (any Error) -> Void
	) {
		self.loader = loader
		self.searchService = searchService
		self.carrierService = carrierService
		self.onError = onError
		loader.settlementsPublisher
			.receive(on: RunLoop.main)
			.sink(receiveCompletion: { [weak self] completion in
				if case let .failure(error) = completion {
					if self?.fetchError == nil {
						self?.fetchError = error
					}
				}
			}, receiveValue: { [weak self] settlements in
				self?.allCities = settlements
				self?.filterCities(with: self?.citySearchText ?? "")
			})
			.store(in: &cancellables)
		$citySearchText
			.debounce(for: .milliseconds(Constants.debounceDelay), scheduler: RunLoop.main)
			.removeDuplicates()
			.sink { [weak self] text in
				self?.filterCities(with: text)
			}
			.store(in: &cancellables)
		$stationSearchText
			.debounce(for: .milliseconds(Constants.debounceDelay), scheduler: RunLoop.main)
			.removeDuplicates()
			.sink { [weak self] text in
				self?.filterStations(with: text)
			}
			.store(in: &cancellables)
	}

	func startFetching() {
		loader.fetchAllStations()
	}

	func updateStations(with city: SettlementShort) {
		allStations = city.stations
			.compactMap { (station: Station) -> SimpleStation? in
				guard
					let code = station.codes?.yandex_code,
					let title = station.title,
					station.transport_type == "train",
					!code.isEmpty,
					!title.isEmpty
				else { return nil }
				return SimpleStation(title: title, code: code)
			}
		stations = allStations
	}

	func fetchTripsStream() -> AsyncThrowingStream<SimpleTrip, any Error> {
		AsyncThrowingStream { continuation in
			Task {
				guard
					let from = selectedFromStation?.code,
					let to = selectedToStation?.code
				else {
					continuation.finish(throwing: InternalError.noStations)
					return
				}

				let response = try await searchService.getScheduleBetweenStations(from: from, to: to)

				guard let segments = response.segments else {
					continuation.finish(throwing: InternalError.responseError)
					return
				}

				await withThrowingTaskGroup(of: SimpleTrip?.self) { group in
					for segment in segments {
						group.addTask {
							try await self.buildTrip(from: segment)
						}
					}

					do {
						for try await trip in group {
							if let trip {
								continuation.yield(trip)
							}
						}
						continuation.finish()
					} catch {
						continuation.finish(throwing: error)
					}
				}
			}
		}
	}

	private func buildTrip(from segment: Components.Schemas.Segment) async throws -> SimpleTrip? {
		guard let hasTransfers = segment.has_transfers else { return nil }

		if hasTransfers {
			guard
				let detail = segment.details?.first,
				let thread = detail.thread,
				let carrier = thread.carrier,
				let carrierCode = carrier.code,
				let carrierTitle = carrier.title,
				let departure = detail.departure,
				let arrival = detail.arrival
			else { return nil }

			var transfer: String? = nil
			if let title = segment.transfers?.first?.title {
				transfer = "С пересадкой в \(title)"
			}

			let carrierInfo = try await self.carrierService.getCarrierInfo(code: "\(carrierCode)")

			let carrierData = SimpleCarrier(
				name: carrierTitle,
				email: carrierInfo.carrier?.email,
				phone: carrierInfo.carrier?.phone,
				imageURL: carrierInfo.carrier?.logo
			)

			return SimpleTrip(
				logoUrl: carrierInfo.carrier?.logo,
				carrierName: carrierTitle,
				additionalInfo: transfer,
				departureTime: Utils.formatTime(from: departure),
				arrivalTime: Utils.formatTime(from: arrival),
				duration: Utils.secondsToRoundedHoursString(detail.duration),
				date: Utils.formatDateString(detail.start_date),
				carrierDetails: carrierData
			)
		} else {
			guard
				let carrier = segment.thread?.carrier,
				let carrierTitle = carrier.title,
				let departure = segment.departure,
				let arrival = segment.arrival
			else { return nil }

			var transfer: String? = nil
			if let title = segment.transfers?.first?.title {
				transfer = "С пересадкой в \(title)"
			}

			let carrierData = SimpleCarrier(
				name: carrierTitle,
				email: carrier.email,
				phone: carrier.phone,
				imageURL: carrier.logo
			)

			return SimpleTrip(
				logoUrl: carrier.logo,
				carrierName: carrierTitle,
				additionalInfo: transfer,
				departureTime: Utils.formatTime(from: departure),
				arrivalTime: Utils.formatTime(from: arrival),
				duration: Utils.secondsToRoundedHoursString(segment.duration),
				date: Utils.formatDateString(segment.start_date),
				carrierDetails: carrierData
			)
		}
	}

	private func filterStations(with text: String) {
		stations = allStations.filter { text.isEmpty || $0.title.localizedCaseInsensitiveContains(text) }
	}

	private func filterCities(with text: String) {
		cities = allCities.filter { text.isEmpty || $0.title.localizedCaseInsensitiveContains(text) }
	}
}
