//
//  ContentView.swift
//  Trains
//
//  Created by Симонов Иван Дмитриевич on 26.06.2025.
//

import SwiftUI

struct ContentView: View {
	@AppStorage("isDarkMode") private var isDarkThemeEnabled = false
	@EnvironmentObject private var dependencies: AppDependencies
	@State private var path: [Route] = []
	@StateObject private var viewModel: RootViewModel

	init(viewModel: RootViewModel) {
		Utils.setupTabBarAppearance()
		_viewModel = .init(wrappedValue: viewModel)
	}

	var body: some View {
		ZStack {
			NavigationStack(path: $path) {
				TabView {
					let storySerivce = StoryService()
					let storiesViewModel = StoriesViewModel(storyService: storySerivce)
					MainView(
						viewModel: dependencies.getMainViewModel { error in
							self.viewModel.processError(error)
						},
						storiesViewModel: storiesViewModel,
						path: $path
					)
					.tabItem {
						Image("Schedule")
					}
					SettingsView(path: $path)
						.tabItem {
							Image("Settings")
						}
				}
				.navigationDestination(for: Route.self) { route in
					switch route {
						case let .selectCity(publisher, cities, direction, action):
							let viewModel = CitySelectionViewModel(publisher: publisher, cities: cities, onAppear: action)
							CitySelectionView(viewModel: viewModel, path: $path, direction: direction)
						case let .selectStation(stations, direction):
							let viewModel = StationSelectionViewModel(stations: stations)
							StationSelectionView(viewModel: viewModel, path: $path, direction: direction)
						case let .trips(from, to):
							let viewModel = TripsViewModel(
								searchService: dependencies.searchService,
								carrierService: dependencies.carrierService,
								from: from,
								to: to
							) { error in
								self.viewModel.processError(error)
							}
							TripsView(viewModel: viewModel, path: $path, from: from, to: to)
						case .filters(let viewModel):
							OptionsView(viewModel: viewModel, path: $path)
						case .agreement:
							AgreementView(path: $path)
						case .carrierDetails(let data):
							CarrierInfoView(path: $path, carrier: data)
					}
				}

			}
			if viewModel.errorMessage != nil {
				if let error = viewModel.errorMessage as? ClientError,
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
						viewModel.clearError()
					}
				}
			}
		}
		.tint(.ypBlack)
		.preferredColorScheme(isDarkThemeEnabled ? .dark : .light)
	}
}

final class RootViewModel: ObservableObject {
	@Published private(set) var errorMessage: (any Error)? = nil

	func processError(_ error: any Error) {
		if errorMessage != nil {
			errorMessage = error
		}
	}

	func clearError() {
		errorMessage = nil
	}
}

