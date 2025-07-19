//
//  TransportationsView.swift
//  Trains
//
//  Created by Симонов Иван Дмитриевич on 14.07.2025.
//

import SwiftUI

struct TransportationsView: View {
	@State var x: [String] = ["1", "2"]
	var body: some View {
		VStack {
			Text("SomeText")
			List(x, id: \.self) { item in
				ScheduleItem(
					image: Image("stub"),
					carrierName: "РЖД",
					additionalInfo: "С пересадкой в Костроме",
					departureTime: "12:30",
					arrivalTime: "20:00",
					travelTime: "20 часов",
					date: "14 января"
				)
				.listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
//				.border(.black)
			}
			.listStyle(.plain)
		}

	}
}

struct ScheduleItem: View {
	let image: Image
	let carrierName: String
	let additionalInfo: String?
	let departureTime: String
	let arrivalTime: String
	let travelTime: String
	let date: String

	var body: some View {
		VStack {
			HStack {
				image
					.resizable()
					.frame(width: 38, height: 38)
					.clipShape(
						RoundedRectangle(cornerRadius: 12)
					)
				VStack(alignment: .leading) {
					Text(carrierName)
						.font(.system(size: 17, weight: .regular))
					if let additionalInfo {
						Text(additionalInfo)
							.font(.system(size: 12, weight: .regular))
							.foregroundColor(.ypRed)
					}
				}
				.frame(maxWidth: .infinity, alignment: .leading)
				Text(date)
					.font(.system(size: 12, weight: .regular))
			}
			.padding(.horizontal, 14)
			.padding(.top, 14)
			.padding(.bottom, 4)
			HStack {
				Text(departureTime)
					.font(.system(size: 17, weight: .regular))
				Rectangle()
					.fill(.ypGray)
					.frame(height: 1)
				Text(travelTime)
					.font(.system(size: 12, weight: .regular))
				Rectangle()
					.fill(.ypGray)
					.frame(height: 1)
				Text(arrivalTime)
					.font(.system(size: 17, weight: .regular))
			}
			.frame(height: 20)
			.padding(14)
		}
		.listRowSeparator(.hidden)
		.background(
			RoundedRectangle(cornerRadius: 24)
				.fill(Color(.ypLightGray))
		)
	}
}

#Preview {
	TransportationsView()
}
