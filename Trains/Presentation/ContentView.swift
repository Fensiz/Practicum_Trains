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
	@StateObject private var viewModel: MainViewModel

	init(viewModel: MainViewModel) {
		Utils.setupTabBarAppearance()
		_viewModel = .init(wrappedValue: viewModel)
	}

	var body: some View {
		ZStack {
			NavigationStack(path: $path) {
				TabView {
					let storiesViewModel = StoriesViewModel(storyBlocks: [
						StoryBlock(stories: [.story1, .story2]),
						StoryBlock(stories: [.story3, .story4]),
						StoryBlock(stories: [.story3, .story4]),
					])
					MainView(
						viewModel: dependencies.mainViewModel,
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
						case .selectCity(let direction):
							CitySelectionView(viewModel: viewModel, path: $path, direction: direction)
						case .selectStation(let direction):
							StationSelectionView(vm: viewModel, path: $path, direction: direction)
						case .trips:
							TripsView(viewModel: viewModel, path: $path)
						case .filters:
							OptionsView(viewModel: viewModel, path: $path)
						case .agreement:
							AgreementView(path: $path)
						case .carrierDetails(let data):
							CarrierInfoView(path: $path, carrier: data)
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
		.tint(.ypBlack)
		.preferredColorScheme(isDarkThemeEnabled ? .dark : .light)
	}
}
