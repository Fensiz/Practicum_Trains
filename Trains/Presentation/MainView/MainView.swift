//
//  MainView.swift
//  Trains
//
//  Created by Симонов Иван Дмитриевич on 13.07.2025.
//

import SwiftUI

struct MainView: View {
	@StateObject var mainViewModel: MainViewModel
	@StateObject var storiesViewModel: StoriesViewModel
	@Binding var path: [Route]

	init(viewModel: MainViewModel, storiesViewModel: StoriesViewModel, path: Binding<[Route]>) {
		self._mainViewModel = .init(wrappedValue: viewModel)
		self._storiesViewModel = .init(wrappedValue: storiesViewModel)
		self._path = path
	}

	var body: some View {
		ZStack {
			VStack {
				StoriesGridView(viewModel: storiesViewModel)
				CityPickerView(viewModel: mainViewModel, path: $path)
				if mainViewModel.isFindButtonShowing,
				   let from = mainViewModel.selectedFromStation,
				   let to = mainViewModel.selectedToStation {
					FindButton {
						path.append(.trips(from: from, to: to))
					}
				}
				Spacer()
			}
			if storiesViewModel.isStoriesShowing {
				StoriesView(viewModel: storiesViewModel)
					.transition(.move(edge: .top))
			}
		}
	}
}

private struct CityPickerView: View {
	@ObservedObject var viewModel: MainViewModel
	@Binding var path: [Route]

	var body: some View {
		HStack(spacing: 16) {
			VStack(spacing: .zero) {
				CityButton(title: "Откуда", value: viewModel.selectedFromStation) {
					path.append(
						.selectCity(
							publisher: viewModel.$allCities.eraseToAnyPublisher(),
							cities: viewModel.allCities,
							direction: .from($viewModel.selectedFromStation),
							action: viewModel.startFetching
						)
					)
				}
				CityButton(title: "Куда", value: viewModel.selectedToStation) {
					path.append(
						.selectCity(
							publisher: viewModel.$allCities.eraseToAnyPublisher(),
							cities: viewModel.allCities,
							direction: .to($viewModel.selectedToStation),
							action: viewModel.startFetching
						)
					)
				}
			}
			.padding(.horizontal, Constants.padding)
			.background(
				RoundedRectangle(
					cornerRadius: Constants.cornerRadiusMedium
				).fill(.white)
			)

			Button {
				viewModel.swapCities()
			} label: {
				Image("swap")
					.frame(width: 36, height: 36)
					.background(
						Circle()
							.fill(Color.white)
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
