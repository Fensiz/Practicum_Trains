//
//  ContentView.swift
//  Trains
//
//  Created by Симонов Иван Дмитриевич on 26.06.2025.
//

import SwiftUI

struct ContentView: View {
	private let methods = [
		(name: "testCarrierService", action: TestMethods.testFetchCarrier),
		(name: "testCopyrightService", action: TestMethods.testFetchCopyright),
		(name: "testNearestSettlementService", action: TestMethods.testFetchNearestSettlement),
		(name: "testNearestStationsService", action: TestMethods.testFetchNearestStations),
		(name: "testScheduleService", action: TestMethods.testFetchStationSchedule),
		(name: "testSearchService", action: TestMethods.testFetchScheduleBetweenStations),
		(name: "testStationListService", action: TestMethods.testFetchStationList),
		(name: "testThreadService", action: TestMethods.testFetchRouteStations),
	]

	var body: some View {
		List(methods, id: \.0) { item in
			Button {
				item.action()
			} label: {
				Text(item.name)
			}
		}
	}
}

#Preview {
	ContentView()
}
