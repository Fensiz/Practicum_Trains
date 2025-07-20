//
//  StationSelectionView.swift
//  Trains
//
//  Created by Симонов Иван Дмитриевич on 19.07.2025.
//

import SwiftUI

struct StationSelectionView: View {
	@ObservedObject var vm: MainViewModel
	@Binding var path: [Route]
	let direction: Direction

	public var body: some View {
		VStack(spacing: 0) {
			SearchBar(searchText: $vm.stationSearchText, placeholder: "Введите запрос")
				.padding(.bottom, Constants.padding)
			if vm.stations.isEmpty {
				Text("Станция не найдена")
					.font(.ypMediumBold)
					.frame(maxHeight: .infinity)
			} else {
				List(vm.stations) { station in
					SelectableRow(title: station.title) {
						switch direction {
							case .from:
								vm.selectedFromStation = station
							case .to:
								vm.selectedToStation = station
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
