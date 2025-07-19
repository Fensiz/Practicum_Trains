//
//  CitySelectionView.swift
//  Trains
//
//  Created by Симонов Иван Дмитриевич on 14.07.2025.
//

import SwiftUI

struct SelectableRow: View {
	let title: String
	let action: () -> Void

	var body: some View {
		Button(action: action) {
			HStack {
				Text(title)
					.font(.system(size: 17))
					.foregroundColor(.primary)
				Spacer()
				Image("chevron")
					.resizable()
					.frame(width: 24, height: 24)
					.tint(.primary)
			}
			.frame(height: 60)
		}
		.listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
		.listRowSeparator(.hidden)
	}
}

struct CitySelectionView: View {
	@ObservedObject var viewModel: MainViewModel
	@Binding var path: [Route]
	let direction: Direction

	public var body: some View {
		VStack(spacing: 0) {
			SearchBar(searchText: $viewModel.citySearchText, placeholder: "Введите запрос")
			if viewModel.cities.isEmpty && !viewModel.citySearchText.isEmpty {
				Text("Город не найден")
					.font(.system(size: 24, weight: .bold))
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
//		.task {
//			await viewModel.getCities()
//		}
	}
}

enum Direction {
	case from, to
}

struct StationSelectionView: View {
	@ObservedObject var vm: MainViewModel
	@Binding var path: [Route]
	let direction: Direction

	public var body: some View {
		VStack(spacing: 0) {
			SearchBar(searchText: $vm.stationSearchText, placeholder: "Введите запрос")
			if vm.stations.isEmpty {
				Text("Станция не найдена")
					.font(.system(size: 24, weight: .bold))
					.frame(maxHeight: .infinity)
			} else {
				List(vm.stations) { station in
					SelectableRow(title: station.title) {
						//TODO:
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
		.navigationBarBackButtonHidden(true)
		.withBackToolbar(path: $path)
	}
}
