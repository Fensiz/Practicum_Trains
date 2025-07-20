//
//  MainViewModel.swift
//  Trains
//
//  Created by Симонов Иван Дмитриевич on 15.07.2025.
//

import SwiftUI
import Combine


typealias Station = Components.Schemas.Station
typealias SettlementShort = (code: String, title: String, stations: [Station])

struct SimpleStation: Identifiable {
	let title: String
	let code: String
	var id: String { code }
}

struct SimpleTrip: Identifiable {
	let id: UUID = .init()
	var logoUrl: String?
	var carrierName: String
	var additionalInfo: String?
	var departureTime: String?
	var arrivalTime: String?
	var duration: String?
	var date: String?
}

@MainActor final class MainViewModel: ObservableObject {
	@Published var stations: [SimpleStation] = []
	@Published var cities: [SettlementShort] = []
	@Published var citySearchText = ""
	@Published var stationSearchText: String = ""
	@Published var isLoading: Bool = false

	@Published var selectedFromStation: SimpleStation? = nil
	@Published var selectedToStation: SimpleStation? = nil

	@Published var trips: [SimpleTrip] = []

	@Published var selectedTimeIntervals: [Bool] = [false, false, false, false]
	@Published var transferFilter: Bool? = nil
	@Published var filteredTrips: [SimpleTrip] = []

	private var cancellables = Set<AnyCancellable>()
	private var loader: any SettlementLoaderProtocol
	private var searchService: any SearchServiceProtocol
	private var carrierService: any CarrierServiceProtocol
	private var allStations: [SimpleStation] = []
	private var allCities: [SettlementShort] = []

	init(
		loader: any SettlementLoaderProtocol,
		searchService: any SearchServiceProtocol,
		carrierService: any CarrierServiceProtocol
	) {
		self.loader = loader
		self.searchService = searchService
		self.carrierService = carrierService
		loader.settlementsPublisher
			.receive(on: RunLoop.main)
			.sink { [weak self] in
				self?.allCities = $0
				self?.filterCities(with: self?.citySearchText ?? "")
			}
			.store(in: &cancellables)
		$citySearchText
			.debounce(for: .milliseconds(600), scheduler: RunLoop.main)
			.removeDuplicates()
			.sink { [weak self] text in
				self?.filterCities(with: text)
			}
			.store(in: &cancellables)
		$stationSearchText
			.debounce(for: .milliseconds(600), scheduler: RunLoop.main)
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

	func fetchTrips() async throws {
		trips = []
		guard
			let from = selectedFromStation?.code,
			let to = selectedToStation?.code
		else { return }
		let response = try await searchService.getScheduleBetweenStations(from: from, to: to)
		guard let segments = response.segments else { return }
		print(segments)

		trips = try await withThrowingTaskGroup(of: SimpleTrip?.self) { group in
			var result: [SimpleTrip] = []

			for segment in segments {
				group.addTask {
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
							transfer = title
						}

						let carrierInfo = try? await self.carrierService.getCarrierInfo(code: "\(carrierCode)")

						return SimpleTrip(
							logoUrl: carrierInfo?.carrier?.logo,
							carrierName: carrierTitle,
							additionalInfo: transfer,
							departureTime: self.formatTime(from: departure),
							arrivalTime: self.formatTime(from: arrival),
							duration: self.secondsToRoundedHoursString(detail.duration),
							date: self.formatDateString(detail.start_date)
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
							transfer = title
						}

						return SimpleTrip(
							logoUrl: carrier.logo,
							carrierName: carrierTitle,
							additionalInfo: transfer,
							departureTime: self.formatTime(from: departure),
							arrivalTime: self.formatTime(from: arrival),
							duration: self.secondsToRoundedHoursString(segment.duration),
							date: self.formatDateString(segment.start_date)
						)
					}
				}
			}

			for try await trip in group {
				guard let trip else { continue }
				let index = result.firstIndex { existing in
					(trip.departureTime ?? "") < (existing.departureTime ?? "")
				} ?? result.endIndex

				result.insert(trip, at: index)
				filteredTrips = trips
			}

			return result
		}
		applyFilters()
	}

	private nonisolated func formatTime(from isoString: String) -> String? {
		let formatter = ISO8601DateFormatter()
	 formatter.formatOptions = [.withInternetDateTime]

	 guard let date = formatter.date(from: isoString) else { return nil }

	 let outputFormatter = DateFormatter()
	 outputFormatter.dateFormat = "HH:mm"

	 return outputFormatter.string(from: date)
 }

	private nonisolated func formatDateString(_ date: String?) -> String {
		guard let date else { return "-" }
		let inputFormatter = DateFormatter()
		inputFormatter.dateFormat = "yyyy-MM-dd"
		inputFormatter.locale = Locale(identifier: "ru_RU")

		if let date = inputFormatter.date(from: date) {
			let outputFormatter = DateFormatter()
			outputFormatter.dateFormat = "d MMMM"
			outputFormatter.locale = Locale(identifier: "ru_RU")

			let formatted = outputFormatter.string(from: date)
			return formatted
		}
		return "-"
	}

	private nonisolated func secondsToRoundedHoursString(_ seconds: Int?) -> String {
		guard let seconds else { return "-" }
		let hours = seconds / 3600
		let remainingSeconds = seconds % 3600
		let roundedHours = hours + (remainingSeconds > 0 ? 1 : 0)

		switch roundedHours {
		case 1:
			return "1 час"
		case 2...4:
			return "\(roundedHours) часа"
		default:
			return "\(roundedHours) часов"
		}
	}

	private func filterStations(with text: String) {
		stations = allStations.filter { text.isEmpty || $0.title.localizedCaseInsensitiveContains(text) }
	}

	private func filterCities(with text: String) {
		cities = allCities.filter { text.isEmpty || $0.title.localizedCaseInsensitiveContains(text) }
	}


	func applyFilters() {
		let timeIntervals: [(start: Int, end: Int)] = [
			(6, 12),   // Утро
			(12, 18),  // День
			(18, 24),  // Вечер
			(0, 6)     // Ночь
		]

		let selectedIntervals = selectedTimeIntervals.enumerated()
			.filter { $0.element }
			.map { timeIntervals[$0.offset] }

		filteredTrips = trips.filter { trip in
			if let filter = transferFilter {
				if filter == false, trip.additionalInfo != nil {
					return false
				}
			}

			guard let timeString = trip.departureTime,
				  let hour = Int(timeString.prefix(2)) else { return false }

			if selectedIntervals.isEmpty {
				return true
			}

			return selectedIntervals.contains(where: { range in
				if range.start < range.end {
					return hour >= range.start && hour < range.end
				} else {
					return hour >= range.start || hour < range.end
				}
			})
		}
	}
}
