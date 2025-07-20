//
//  ContentView.swift
//  Trains
//
//  Created by Симонов Иван Дмитриевич on 26.06.2025.
//

import SwiftUI

struct ContentView: View {
//	private let methods = [
//		(name: "testCarrierService", action: TestMethods.testFetchCarrier),
//		(name: "testCopyrightService", action: TestMethods.testFetchCopyright),
//		(name: "testNearestSettlementService", action: TestMethods.testFetchNearestSettlement),
//		(name: "testNearestStationsService", action: TestMethods.testFetchNearestStations),
//		(name: "testScheduleService", action: TestMethods.testFetchStationSchedule),
//		(name: "testSearchService", action: TestMethods.testFetchScheduleBetweenStations),
//		(name: "testStationListService", action: TestMethods.testFetchStationList),
//		(name: "testThreadService", action: TestMethods.testFetchRouteStations),
//	]
	@AppStorage("isDarkMode") private var isDarkThemeEnabled = false
	@EnvironmentObject private var dependencies: AppDependencies

	init() {
		Utils.setupTabBarAppearance()
	}

	var body: some View {
		TabView {
			MainView(viewModel: dependencies.mainViewModel)
				.tabItem {
					Image("Schedule")
				}
			SettingsView()
				.tabItem {
					Image("Settings")
				}
		}
		.tint(.ypBlack)
		.preferredColorScheme(isDarkThemeEnabled ? .dark : .light)
	}
}

#Preview {
	ContentView()
}
