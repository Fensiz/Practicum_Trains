//
//  MainView.swift
//  Trains
//
//  Created by Симонов Иван Дмитриевич on 13.07.2025.
//

import SwiftUI

struct CityPickerView: View {
	@Binding var from: SimpleStation?
	@Binding var to: SimpleStation?
	@Binding var path: [Route]

	var body: some View {
		HStack(spacing: 16) {
			VStack(spacing: .zero) {
				CityButton(title: "Откуда", value: from?.title ?? "") {
					path.append(.selectCity(.from))
				}
				CityButton(title: "Куда", value: to?.title ?? "") {
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
				swap(&to, &from)
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
	}
}
struct FindButton: View {
	let action: () -> Void

	var body: some View {
		Button {
			action()
		} label: {
			Text("Найти")
				.font(.ypSmallBold)
				.foregroundStyle(.white)
				.frame(width: 150, height: Constants.buttonHeight)
				.background(Color.ypBlue)
				.clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
		}
	}
}
struct MainView: View {
	@ObservedObject var viewModel: MainViewModel
	@Binding var path: [Route]

	var body: some View {
		ZStack {
			NavigationStack(path: $path) {
				VStack {
					StoriesGridView(
						stories: $viewModel.stories,
						isStoriesShowning: $viewModel.isStoriesShowing,
						selectedStoryId: $viewModel.selectedStoryId
					)
					CityPickerView(
						from: $viewModel.selectedFromStation,
						to: $viewModel.selectedToStation,
						path: $path
					)
					if viewModel.isFindButtonShowing {
						FindButton {
							viewModel.fetchTripsTask()
							path.append(.trips)
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

			if viewModel.isStoriesShowing {
				let vm = StoriesViewModel(
					stories: $viewModel.stories,
					selectedId: viewModel.selectedStoryId ?? 0,
					closeAction: viewModel.hideStories
				)
				StoriesView(viewModel: vm)
					.id(UUID())
					.transition(.move(edge: .top))
			}

		}
		.ignoresSafeArea()
	}
}
