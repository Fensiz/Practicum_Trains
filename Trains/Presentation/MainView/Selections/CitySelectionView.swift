//
//  CitySelectionView.swift
//  Trains
//
//  Created by Симонов Иван Дмитриевич on 14.07.2025.
//

import SwiftUI

struct CitySelectionView: View {
	@StateObject var viewModel: CitySelectionViewModel
	@Binding var path: [Route]
	let direction: Direction

	public var body: some View {
		VStack(spacing: .zero) {
			SearchBar(searchText: $viewModel.searchText, placeholder: "Введите запрос")
				.padding(.bottom, Constants.padding)
			if viewModel.cities.isEmpty && !viewModel.searchText.isEmpty {
				Text("Город не найден")
					.font(.ypMediumBold)
					.frame(maxHeight: .infinity)
			} else {
				List {
					ForEach(viewModel.cities, id: \.code) { city in
						SelectableRow(title: city.title) {
							let stations = viewModel.fetchStations(in: city)
							path.append(.selectStation(stations: stations, direction: direction))
						}
					}
				}
				.listStyle(.plain)
			}
		}
		.navigationTitle("Выбор города")
		.navigationBarBackButtonHidden(true)
		.withBackToolbar(path: $path)
		.task {
			viewModel.onAppear()
		}
	}
}

// MARK: - Previews

import Combine

#Preview("Список городов") {
	let subject = PassthroughSubject<[SettlementShort], Never>()
	let vm = CitySelectionViewModel(
		publisher: subject.eraseToAnyPublisher(),
		cities: mockCities(),
		onAppear: { subject.send(mockCities()) }
	)

	NavigationStack {
		CitySelectionView(
			viewModel: vm,
			path: .constant([]),
			direction: .from(.constant(SimpleStation(title: "", code: "")))
		)
	}
}


// MARK: - Mock data helpers

private func mockCities() -> [SettlementShort] {
	[
		mockCity(code: "MSK", title: "Москва", stationTitles: ["Курский вокзал", "Ленинградский вокзал"]),
		mockCity(code: "SPB", title: "Санкт-Петербург", stationTitles: ["Московский вокзал", "Ладожский вокзал"]),
		mockCity(code: "EKB", title: "Екатеринбург", stationTitles: ["Екатеринбург-Пасс.", "Шарташ"])
	]
}

private func mockCity(code: String, title: String, stationTitles: [String]) -> SettlementShort {
	let stations = stationTitles.enumerated().map { idx, t in
		mockStation(code: "\(code)-\(idx+1)", title: t)
	}
	return SettlementShort(
		code: code,
		title: title,
		stations: stations
	)
}

private func mockStation(code: String, title: String) -> Station {
	Station(
		title: title, transport_type: "train", codes: .init(yandex_code: code)
	)
}
