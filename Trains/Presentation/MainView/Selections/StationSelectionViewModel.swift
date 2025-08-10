//
//  StationSelectionViewModel.swift
//  Trains
//
//  Created by Симонов Иван Дмитриевич on 10.08.2025.
//

import SwiftUI

final class StationSelectionViewModel: ObservableObject {
	@Published var searchText: String = ""
	var stations: [SimpleStation] {
		guard !searchText.isEmpty else { return allStations }
		return allStations.filter {
			$0.title.localizedCaseInsensitiveContains(searchText)
		}
	}
	private let allStations: [SimpleStation]

	init(stations: [SimpleStation]) {
		self.allStations = stations
	}
}
