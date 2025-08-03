//
//  CarrierInfoView.swift
//  Trains
//
//  Created by Симонов Иван Дмитриевич on 29.07.2025.
//

import SwiftUI

struct CarrierInfoView: View {
	@Binding var path: [Route]
	let carrier: SimpleCarrier
	var body: some View {
		VStack(spacing: Constants.padding) {
			if let urlString = carrier.imageURL,
				let logoUrl = URL(string: urlString) {
				AsyncImage(url: logoUrl) { image in
					image
						.resizable()
						.aspectRatio(contentMode: .fit)
				} placeholder: {
					Color.gray.opacity(0.2)
				}
				.frame(height: 104)
				.frame(maxWidth: .infinity)
				.background(.white)
				.clipShape(
					RoundedRectangle(cornerRadius: 24)
				)
			}
			Group {
				Text(carrier.name)
					.font(.ypMediumBold)
				if let email = carrier.email, !email.isEmpty {
					VStack(alignment: .leading) {
						Text("E-mail")
							.font(.ypMedium)
						Link(email, destination: URL(string: "mailto:\(email)")!)
							.font(.ypSmall)
							.foregroundStyle(.ypBlue)
					}
				}
				if let phone = carrier.phone, !phone.isEmpty {
					VStack(alignment: .leading) {
						Text("Телефон")
							.font(.ypMedium)
						Link(phone, destination: URL(string: "tel:\(phone)")!)
							.font(.ypSmall)
							.foregroundStyle(.ypBlue)
					}
				}
			}
			.frame(maxWidth: .infinity, alignment: .leading)
			Spacer()
		}
		.padding(Constants.padding)
		.frame(maxWidth: UIScreen.main.bounds.width)
		.navigationTitle("Информация о перевозчике")
		.withBackToolbar(path: $path)
	}
}

#Preview {
	let rzd = "https://yastat.net/s3/rasp/media/data/company/logo/logo.gif"
	let ta = "https://yastat.net/s3/rasp/media/data/company/logo/thy_kopya.jpg"
	NavigationStack {
		CarrierInfoView(
			path: .constant([.filters]),
			carrier: SimpleCarrier(
				name: "ОАО \"РЖД\"",
				email: "simonov.ivan@inbox.ru",
				phone: "+79150739344",
				imageURL: ta
			)
		)
	}
	.preferredColorScheme(.dark)
}

