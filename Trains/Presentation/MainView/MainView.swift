//
//  MainView.swift
//  Trains
//
//  Created by Симонов Иван Дмитриевич on 13.07.2025.
//

import SwiftUI

struct MainView: View {
	@StateObject var viewModel: MainViewModel
	@StateObject var storiesViewModel: StoriesViewModel
	@Binding var path: [Route]

	init(viewModel: MainViewModel, storiesViewModel: StoriesViewModel, path: Binding<[Route]>) {
		self._viewModel = .init(wrappedValue: viewModel)
		self._storiesViewModel = .init(wrappedValue: storiesViewModel)
		self._path = path
	}

	var body: some View {
		ZStack {
			VStack {
				StoriesGridView(viewModel: storiesViewModel)
				CityPickerView(
					from: $viewModel.selectedFromStation,
					to: $viewModel.selectedToStation,
					path: $path,
					viewModel: viewModel
				)
				if
					let from = viewModel.selectedFromStation,
					let to = viewModel.selectedToStation,
					viewModel.isFindButtonShowing {

					FindButton {
						path.append(
							.trips(
								tripsStream: viewModel.fetchTripsStream(),
								from: from,
								to: to
							)
						)
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
	@Binding var from: SimpleStation?
	@Binding var to: SimpleStation?
	@Binding var path: [Route]
	@ObservedObject var viewModel: MainViewModel

	var body: some View {
		HStack(spacing: 16) {
			VStack(spacing: .zero) {
				CityButton(title: "Откуда", value: from?.title ?? "") {
					path.append(.selectCity(viewModel: viewModel, direction: .from))
				}
				CityButton(title: "Куда", value: to?.title ?? "") {
					path.append(.selectCity(viewModel: viewModel, direction: .to))
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
