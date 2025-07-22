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
			TabView {
				MainView(viewModel: dependencies.mainViewModel, path: $path)
					.tabItem {
						Image("Schedule")
					}
				SettingsView()
					.tabItem {
						Image("Settings")
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
