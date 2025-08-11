//
//  StationSelectionView.swift
//  Trains
//
//  Created by Симонов Иван Дмитриевич on 19.07.2025.
//

import SwiftUI

struct StationSelectionView: View {
	@StateObject var viewModel: StationSelectionViewModel
	@Binding var path: [Route]
	let direction: Direction

	public var body: some View {
		VStack(spacing: .zero) {
			SearchBar(searchText: $viewModel.searchText, placeholder: "Введите запрос")
				.padding(.bottom, Constants.padding)
			if viewModel.stations.isEmpty {
				Text("Станция не найдена")
					.font(.ypMediumBold)
					.frame(maxHeight: .infinity)
			} else {
				List(viewModel.stations) { station in
					SelectableRow(title: station.title) {
						switch direction {
							case .from(let stationBinding):
								stationBinding.wrappedValue = station
							case .to(let stationBinding):
								stationBinding.wrappedValue = station
						}
						path.removeAll()
					}
				}
				.listStyle(.plain)
			}
		}
		.navigationTitle("Выбор станции")
		.withBackToolbar(path: $path)
	}
}
