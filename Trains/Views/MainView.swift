//
//  MainView.swift
//  Trains
//
//  Created by Симонов Иван Дмитриевич on 13.07.2025.
//

import SwiftUI

struct MainView: View {
	@State private var path: [Route] = []

	@StateObject private var viewModel: MainViewModel

	init(viewModel: MainViewModel) {
		_viewModel = .init(wrappedValue: viewModel)
	}

	var body: some View {
		NavigationStack(path: $path) {
			VStack {
				// Горизонтальная лента
				ScrollView(.horizontal) {
					LazyHGrid(rows: [.init(.fixed(92), spacing: 12)]) {
						ForEach(0..<10) { _ in
							Color.red
								.frame(width: 92, height: 140)
								.clipShape(RoundedRectangle(cornerRadius: 16))
						}
					}
					.padding(.horizontal, 16)
				}
				.frame(height: 140)
				.padding(.vertical, 24)

				// Панель выбора городов
				HStack(spacing: 16) {
					VStack(spacing: 0) {
						CityButton(title: "Откуда", value: viewModel.selectedFromStation?.title ?? "") {
							path.append(.selectCity(.from))
						}
						CityButton(title: "Куда", value: viewModel.selectedToStation?.title ?? "") {
							path.append(.selectCity(.to))
						}
					}
					.padding(.horizontal, 16)
					.background(RoundedRectangle(cornerRadius: 20).fill(.white))

					Button {
						swap(&viewModel.selectedToStation, &viewModel.selectedFromStation)
					} label: {
						Image("Swap")
							.frame(width: 36, height: 36)
							.background(
								Circle()
									.fill(Color.white)
									.frame(width: 36, height: 36)
							)
					}
				}
				.padding(16)
				.background(RoundedRectangle(cornerRadius: 20).fill(.ypBlue))
				.padding(.horizontal, 16)
				.padding(.top, 20)
				.padding(.bottom, 16)

				// Кнопка Найти
				if viewModel.selectedToStation != nil && viewModel.selectedFromStation != nil {
					Button {
						// Выполнить поиск
					} label: {
						Text("Найти")
							.font(.system(size: 17, weight: .bold))
							.foregroundStyle(.white)
							.frame(width: 150, height: 60)
							.background(Color.ypBlue)
							.clipShape(RoundedRectangle(cornerRadius: 16))
					}
				}

				Spacer()
			}
			.navigationDestination(for: Route.self) { route in
				switch route {
					case .selectCity(let direction):
						CitySelectionView(viewModel: viewModel, path: $path, direction: direction)
					case .selectStation(let direction):
						StationSelectionView(vm: viewModel, path: $path, direction: direction)
				}
			}
		}
	}
}

struct CityButton: View {
	let title: String
	let value: String
	let action: () -> Void

	var body: some View {
		Button(action: action) {
			HStack {
				Text(value.isEmpty ? title : value)
					.foregroundColor(value.isEmpty ? .ypGray : .black)
					.lineLimit(1)
				Spacer()
			}
		}
		.frame(height: 48)
	}
}

enum Route: Hashable {
	case selectCity(Direction)
	case selectStation(Direction)

	static func == (lhs: Route, rhs: Route) -> Bool {
		switch (lhs, rhs) {
			case (.selectCity, .selectCity): true
			case (.selectStation, .selectStation): true
			default: false
		}
	}

	func hash(into hasher: inout Hasher) {
		// Уникальные константы, чтобы отличать маршруты
		switch self {
		case .selectCity:
			hasher.combine("selectCity")
		case .selectStation:
			hasher.combine("selectStation")
		}
	}
}

#Preview {
	ContentView()
}

#Preview {
	SettingsView()
}
//#Preview {
//	FromToView()
//}


