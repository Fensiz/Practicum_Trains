//
//  CitySelectionViewModel.swift
//  Trains
//
//  Created by Симонов Иван Дмитриевич on 09.08.2025.
//

import SwiftUI
import Combine

final class CitySelectionViewModel: ObservableObject {
	@Published var searchText: String = ""
	var cities: [SettlementShort] {
		guard !searchText.isEmpty else { return allCities }
		return allCities.filter {
			$0.title.localizedCaseInsensitiveContains(searchText)
		}
	}
	let onAppear: () -> Void
	@Published private var allCities: [SettlementShort] = []

	init(
		publisher: AnyPublisher<[SettlementShort], Never>,
		cities: [SettlementShort],
		onAppear: @escaping () -> Void
	) {
		self.onAppear = onAppear
		self.allCities = cities
		publisher
			.receive(on: RunLoop.main)
			.assign(to: &$allCities)
	}

	func fetchStations(in city: SettlementShort) -> [SimpleStation] {
		city.stations
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
	}
}
