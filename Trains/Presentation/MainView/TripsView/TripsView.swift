//
//  TransportationsView.swift
//  Trains
//
//  Created by Симонов Иван Дмитриевич on 14.07.2025.
//

import SwiftUI

struct TripsView: View {
	@StateObject var viewModel: TripsViewModel
	@Binding var path: [Route]
	let from: SimpleStation
	let to: SimpleStation

	var body: some View {
		ZStack {
			VStack {
				Text("\(from.title) → \(to.title)")
					.font(.ypMediumBold)
					.padding(16)
				if viewModel.filteredTrips.isEmpty {
					Text("Вариантов нет")
						.font(.ypMediumBold)
						.frame(maxHeight: .infinity)
				} else {
					List {
						ForEach(viewModel.filteredTrips) { item in
							ScheduleItem(item: item) { data in
								path.append(.carrierDetails(data))
							}
							.listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
						}
						if viewModel.filteredTrips.count > 4 {
							Color.clear
								.frame(height: 100)
								.listRowInsets(EdgeInsets())
						}
					}
					.listStyle(.plain)
				}
			}
			VStack {
				Spacer()
				Button {
					path.append(.filters(viewModel))
				} label: {
					HStack(spacing: 4) {
						Text("Уточнить время")
						if viewModel.transferFilter != nil {
							Circle()
								.fill(.ypRed)
								.frame(width: 8, height: 8)
						}
					}
				}
				.buttonStyle(PrimaryButtonStyle())
				.padding(.bottom, 24)
				.padding(.horizontal, 16)
			}
		}
		.withBackToolbar(path: $path)
		.task {
			await self.viewModel.fetchTrips()
		}
	}
}
