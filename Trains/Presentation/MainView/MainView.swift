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
	private let stories: [Image] = [
		Image("stories_1"),
		Image("stories_2"),
		Image("stories_3"),
		Image("stories_4"),
		Image("stories_5"),
		Image("stories_6"),
	]

	init(viewModel: MainViewModel) {
		_viewModel = .init(wrappedValue: viewModel)
	}

	var body: some View {
		ZStack {
			NavigationStack(path: $path) {
				VStack {
					// Горизонтальная лента
					ScrollView(.horizontal) {
						LazyHGrid(rows: [.init(.fixed(92), spacing: 12)]) {
							ForEach(0..<10) { i in
								stories[i % stories.count]
									.resizable()
									.aspectRatio(contentMode: .fill)
									.frame(width: 92, height: 140)
									.clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
							}
						}
						.padding(.horizontal, Constants.padding)
					}
					.frame(height: 140)
					.padding(.vertical, 24)
					.scrollIndicators(.hidden)

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
						.padding(.horizontal, Constants.padding)
						.background(
							RoundedRectangle(
								cornerRadius: Constants.cornerRadiusMedium
							).fill(.white)
						)

						Button {
							swap(&viewModel.selectedToStation, &viewModel.selectedFromStation)
						} label: {
							Image("swap")
								.frame(width: 36, height: 36)
								.background(
									Circle()
										.fill(Color.white)
										.frame(width: 36, height: 36)
								)
						}
					}
					.padding(Constants.padding)
					.background(
						RoundedRectangle(
							cornerRadius: Constants.cornerRadiusMedium
						).fill(.ypBlue)
					)
					.padding(.horizontal, Constants.padding)
					.padding(.top, 20)
					.padding(.bottom, Constants.padding)

					// Кнопка Найти
					if viewModel.selectedToStation != nil && viewModel.selectedFromStation != nil {
						Button {
							Task {
								try? await viewModel.fetchTrips()
							}
							path.append(.trips)
						} label: {
							Text("Найти")
								.font(.ypSmallBold)
								.foregroundStyle(.white)
								.frame(width: 150, height: Constants.buttonHeight)
								.background(Color.ypBlue)
								.clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
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
						case .trips:
							TripsView(viewModel: viewModel, path: $path)
						case .filters:
							OptionsView(viewModel: viewModel, path: $path)
					}
				}
			}
			if viewModel.fetchError != nil {
				if let error = viewModel.fetchError as? ClientError,
				   let underlyingError = error.underlyingError as? URLError {
					VStack {
						switch underlyingError.code {
							case .notConnectedToInternet:
								NoInternetErrorView()
							case .badServerResponse, .timedOut:
								ServerErrorView()
							default:
								UnknownErrorView()
						}
					}
					.onTapGesture {
						viewModel.fetchError = nil
					}
				}
			}
		}
	}
}

enum Route: Hashable {
	case selectCity(Direction)
	case selectStation(Direction)
	case trips
	case filters

	static func == (lhs: Route, rhs: Route) -> Bool {
		switch (lhs, rhs) {
			case (.selectCity, .selectCity): true
			case (.selectStation, .selectStation): true
			case (.trips, .trips): true
			case (.filters, .filters): true
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
			case .trips:
				hasher.combine("trips")
			case .filters:
				hasher.combine("filters")
		}
	}
}

#Preview {
	ContentView()
}

#Preview {
	SettingsView()
}
