//
//  CitySelectionView.swift
//  Trains
//
//  Created by Симонов Иван Дмитриевич on 14.07.2025.
//

import SwiftUI

struct CitySelectionView: View {
	@ObservedObject var viewModel: MainViewModel
	@Binding var path: [Route]
	let direction: Direction

	public var body: some View {
		VStack(spacing: 0) {
			SearchBar(searchText: $viewModel.citySearchText, placeholder: "Введите запрос")
				.padding(.bottom, Constants.padding)
			if viewModel.cities.isEmpty && !viewModel.citySearchText.isEmpty {
				Text("Город не найден")
					.font(.ypMediumBold)
					.frame(maxHeight: .infinity)
			} else {
				List {
					ForEach(viewModel.cities, id: \.code) { city in
						SelectableRow(title: city.title) {
							viewModel.updateStations(with: city)
							path.append(.selectStation(direction))
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
			viewModel.startFetching()
		}
	}
}

enum Direction {
	case from, to
}


