//
//  TestMethods.swift
//  Trains
//
//  Created by Симонов Иван Дмитриевич on 27.06.2025.
//

import OpenAPIRuntime
import OpenAPIURLSession
import Foundation

enum TestMethods {
	static let apiKey = "3a2b4d4f-964a-4f03-b983-efa9e5dfc15b"
	static var client: Client {
		get throws {
			Client(
				serverURL: try Servers.Server1.url(),
				transport: URLSessionTransport()
			)
		}
	}

	static func testFetchNearestStations() {
		Task {
			do {
				let service = NearestStationsService(
					client: try client,
					apikey: apiKey
				)

				print("Fetching stations...")
				let stations = try await service.getNearestStations(
					lat: 59.864177, // Пример координат
					lng: 30.319163, // Пример координат
					distance: 50    // Пример дистанции
				)

				print("Successfully fetched stations: \(stations)")
			} catch {
				print("Error fetching stations: \(error)")
			}
		}
	}

	static func testFetchNearestSettlement() {
		Task {
			do {
				let service = NearestSettlementService(
					client: try client,
					apikey: apiKey
				)

				print("Fetching settlement...")
				let settlement = try await service.getNearestCity(
					lat: 59.864177,
					lng: 30.319163
				)

				print("Successfully fetched settlement: \(settlement)")
			} catch {
				print("Error fetching settlement: \(error)")
			}
		}
	}

	static func testFetchCopyright() {
		Task {
			do {
				let service = CopyrightService(
					client: try client,
					apikey: apiKey
				)

				print("Fetching copyright...")
				let copyright = try await service.getCopyright()

				print("Successfully fetched: \(copyright)")
			} catch {
				print("Error fetching: \(error)")
			}
		}
	}

	static func testFetchCarrier() {
		Task {
			do {
				let service = CarrierService(
					client: try client,
					apikey: apiKey
				)

				print("Fetching carrier...")
				let carrier = try await service.getCarrierInfo(code: "680")

				print("Successfully fetched: \(carrier)")
			} catch {
				print("Error fetching: \(error)")
			}
		}
	}

	static func testFetchStationSchedule() {
		Task {
			do {
				let service = ScheduleService(
					client: try client,
					apikey: apiKey
				)

				print("Fetching settlement...")
				let settlement = try await service.getStationSchedule(station: "s9600213")

				print("Successfully fetched settlement: \(settlement)")
			} catch {
				print("Error fetching settlement: \(error)")
			}
		}
	}

	static func testFetchScheduleBetweenStations() {
		Task {
			do {
				let service = SearchService(
					client: try client,
					apikey: apiKey
				)

				print("Fetching schedule...")
				let schedule = try await service.getScheduleBetweenStations(from: "c146", to: "c213")

				print("Successfully fetched schedule: \(schedule)")
			} catch {
				print("Error fetching settlement: \(error)")
			}
		}
	}

	static func testFetchStationList() {
		Task {
			do {
				let service = StationListService(
					client: try client,
					apikey: apiKey
				)

				print("Fetching stations...")
				let stations = try await service.getAllStations()

				guard let contries = stations.countries else { throw NSError(domain: "Trains", code: 999, userInfo: [NSLocalizedDescriptionKey: "Что-то пошло не так"]) }

				for c in contries {
					guard let regions = c.regions else { continue }
					if let title = c.title, !title.isEmpty {
						print(title)
					}
					for r in regions {
						guard let title = r.title, !title.isEmpty else { continue }
						print("    \(title)")
					}
				}
			} catch {
				print("Error fetching stations: \(error)")
			}
		}
	}

	static func testFetchRouteStations() {
		Task {
			do {
				let service = ThreadService(
					client: try client,
					apikey: apiKey
				)

				print("Fetching stations...")
				let stations = try await service.getRouteStations(uid: "098S_7_2")

				print("Successfully fetched stations: \(stations)")
			} catch {
				print("Error fetching settlement: \(error)")
			}
		}
	}
}
