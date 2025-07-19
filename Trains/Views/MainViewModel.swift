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

@MainActor final class MainViewModel: ObservableObject {
	@Published var stations: [SimpleStation] = []
	@Published var cities: [SettlementShort] = []
	@Published var citySearchText = ""
	@Published var stationSearchText: String = ""
	@Published var isLoading: Bool = false

	@Published var selectedFromStation: SimpleStation? = nil
	@Published var selectedToStation: SimpleStation? = nil

	private var cancellables = Set<AnyCancellable>()
	private var loader: SettlementLoaderProtocol
	private var allStations: [SimpleStation] = []
	private var allCities: [SettlementShort] = []

	init(loader: SettlementLoaderProtocol, searchService: SearchServiceProtocol) {
		self.loader = loader
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
					!code.isEmpty,
					!title.isEmpty
				else { return nil }
				return SimpleStation(title: title, code: code)
			}
		stations = allStations
	}

	private func filterStations(with text: String) {
		stations = allStations.filter { text.isEmpty || $0.title.localizedCaseInsensitiveContains(text) }
	}

	private func filterCities(with text: String) {
		cities = allCities.filter { text.isEmpty || $0.title.localizedCaseInsensitiveContains(text) }
	}
}
