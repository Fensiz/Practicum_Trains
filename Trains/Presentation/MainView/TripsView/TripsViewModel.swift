//
//  TripsViewModel.swift
//  Trains
//
//  Created by Симонов Иван Дмитриевич on 09.08.2025.
//

import Combine
import Foundation

@MainActor final class TripsViewModel: ObservableObject {
	@Published var filteredTrips: [SimpleTrip] = []
	@Published var transferFilter: Bool? = nil
	@Published var selectedTimeIntervals: [Bool] = [false, false, false, false]
	@Published private var trips: [SimpleTrip] = []
	private let tripsStream: AsyncThrowingStream<SimpleTrip, any Error>
	private let onError: (any Error) -> Void
	private var cancellables = Set<AnyCancellable>()
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
		stream: AsyncThrowingStream<SimpleTrip, any Error>,
		onError: @escaping (any Error) -> Void
	) {
		self.tripsStream = stream
		self.onError = onError
		self.filteredTripsPublisher
			.receive(on: DispatchQueue.main)
			.assign(to: \.filteredTrips, on: self)
			.store(in: &cancellables)
	}

	func fetchTrips() async {
		do {
			for try await trip in tripsStream {
				trips.append(trip)
			}

		} catch {
			onError(error)
		}
	}
}
