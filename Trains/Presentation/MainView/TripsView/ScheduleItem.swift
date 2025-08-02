//
//  ScheduleItem.swift
//  Trains
//
//  Created by Симонов Иван Дмитриевич on 22.07.2025.
//

import SwiftUI

struct ScheduleItem: View {
	let item: SimpleTrip

	var body: some View {
		VStack {
			HStack {
				if let urlString = item.logoUrl,
				   let url = URL(string: urlString) {
					AsyncImage(url: url) { image in
						image
							.resizable()
							.frame(width: 38, height: 38)
							.clipShape(
								RoundedRectangle(cornerRadius: 12)
							)
					} placeholder: {
						ProgressView()
					}
					.frame(width: 38, height: 38)
				} else {
					Image(systemName: "photo")
						.resizable()
						.frame(width: 38, height: 38)
						.clipShape(
							RoundedRectangle(cornerRadius: 12)
						)
						.foregroundColor(.gray)
				}
				VStack(alignment: .leading) {
					Text(item.carrierName)
						.font(.ypMedium)
						.foregroundStyle(.black)
					if let additionalInfo = item.additionalInfo {
						Text(additionalInfo)
							.font(.ypSmall)
							.foregroundColor(.ypRed)
					}
				}
				.frame(maxWidth: .infinity, alignment: .leading)
				Text(item.date ?? "-")
					.font(.ypSmall)
					.foregroundStyle(.black)
			}
			.padding(.horizontal, 14)
			.padding(.top, 14)
			.padding(.bottom, 4)
			HStack {
				Text(item.departureTime ?? "-")
				Rectangle()
					.fill(.ypGray)
					.frame(height: 1)
				Text(item.duration ?? "-")
					.font(.ypSmall)
				Rectangle()
					.fill(.ypGray)
					.frame(height: 1)
				Text(item.arrivalTime ?? "-")
			}
			.font(.ypMedium)
			.foregroundStyle(.black)
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
