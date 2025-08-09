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
//	@StateObject private var viewModel: MainViewModel

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
							self.viewModel.errorMessage = error
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
						case let .selectCity(viewModel, direction):
							CitySelectionView(viewModel: viewModel, path: $path, direction: direction)
						case let .selectStation(viewModel, direction):
							StationSelectionView(vm: viewModel, path: $path, direction: direction)
						case let .trips(stream, from, to):
							let viewModel = TripsViewModel(stream: stream) { error in
								self.viewModel.errorMessage = error
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
						viewModel.errorMessage = nil
					}
				}
			}
		}
		.tint(.ypBlack)
		.preferredColorScheme(isDarkThemeEnabled ? .dark : .light)
	}
}

final class RootViewModel: ObservableObject {
	@Published var errorMessage: (any Error)? = nil
}

