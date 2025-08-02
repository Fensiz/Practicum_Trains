//
//  MainView.swift
//  Trains
//
//  Created by Симонов Иван Дмитриевич on 13.07.2025.
//

import SwiftUI

struct MainView: View {
	@ObservedObject var viewModel: MainViewModel
	@Binding var path: [Route]

	var body: some View {
		ZStack {
			NavigationStack(path: $path) {
				VStack {
					StoriesView()

					// Панель выбора городов
					HStack(spacing: 16) {
						VStack(spacing: .zero) {
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
								.toolbar(.hidden, for: .tabBar)
						case .selectStation(let direction):
							StationSelectionView(vm: viewModel, path: $path, direction: direction)
						case .trips:
							TripsView(viewModel: viewModel, path: $path)
								.toolbar(.hidden, for: .tabBar)
						case .filters:
							OptionsView(viewModel: viewModel, path: $path)
					}
				}
			}
		}
	}
}
