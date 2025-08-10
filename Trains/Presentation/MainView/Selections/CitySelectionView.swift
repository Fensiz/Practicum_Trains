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
