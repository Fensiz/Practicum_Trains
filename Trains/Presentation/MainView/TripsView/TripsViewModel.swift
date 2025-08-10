//
//  TripsViewModel.swift
//  Trains
//
//  Created by Симонов Иван Дмитриевич on 09.08.2025.
//

import Combine
import Foundation

@MainActor final class TripsViewModel: ObservableObject {
	enum InternalError: Error {
		case noStations, apiError, responseError
	}
	@Published var filteredTrips: [SimpleTrip] = []
	@Published var transferFilter: Bool? = nil
	@Published var selectedTimeIntervals: [Bool] = [false, false, false, false]
	@Published private var trips: [SimpleTrip] = []
	private let onError: (any Error) -> Void
	private var cancellables = Set<AnyCancellable>()
	private let searchService: any SearchServiceProtocol
	private let carrierService: any CarrierServiceProtocol
	private let fromStation: SimpleStation
	private let toStation: SimpleStation
	private lazy var filteredTripsPublisher: AnyPublisher<[SimpleTrip], Never> = Publishers
		.CombineLatest3($trips, $transferFilter, $selectedTimeIntervals)
		.map { trips, transferFilter, selectedIntervals in

			let timeIntervals: [(start: Int, end: Int)] = [
				(6, 12), (12, 18), (18, 24), (0, 6)
			]

			let activeIntervals = selectedIntervals.enumerated()
				.filter { $0.element }
				.map { timeIntervals[$0.offset] }

			return self.trips.filter { trip in
				if let filter = transferFilter, filter == false, trip.additionalInfo != nil {
					return false
				}
				guard let timeString = trip.departureTime,
					  let hour = Int(timeString.prefix(2)) else {
					return false
				}
				if activeIntervals.isEmpty {
					return true
				}
				return activeIntervals.contains(where: { range in
					if range.start < range.end {
						return hour >= range.start && hour < range.end
					} else {
						return hour >= range.start || hour < range.end
					}
				})
			}
			.sorted { $0.departureTime ?? "" < $1.departureTime ?? "" }
		}
		.eraseToAnyPublisher()

	init(
		searchService: any SearchServiceProtocol,
		carrierService: any CarrierServiceProtocol,
		from: SimpleStation,
		to: SimpleStation,
		onError: @escaping (any Error) -> Void
	) {
		self.searchService = searchService
		self.carrierService = carrierService
		self.fromStation = from
		self.toStation = to
		self.onError = onError
		self.filteredTripsPublisher
			.receive(on: DispatchQueue.main)
			.assign(to: \.filteredTrips, on: self)
			.store(in: &cancellables)
	}

	func fetchTrips() async {
		do {
			let response = try await searchService.getScheduleBetweenStations(
				from: fromStation.code,
				to: toStation.code
			)

			guard let segments = response.segments else {
				throw InternalError.responseError
			}

			try await withThrowingTaskGroup(of: SimpleTrip?.self) { group in
				for segment in segments {
					group.addTask {
						try await self.buildTrip(from: segment)
					}
				}

				for try await trip in group 	{
					guard let trip else { continue }
					trips.append(trip)
				}
			}
		} catch {
			onError(error)
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
}
