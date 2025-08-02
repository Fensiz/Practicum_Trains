//
//  CityButton.swift
//  Trains
//
//  Created by Симонов Иван Дмитриевич on 19.07.2025.
//

import SwiftUI

struct CityButton: View {
	let title: String
	let value: String
	let action: () -> Void

	var body: some View {
		Button(action: action) {
			HStack {
				Text(value.isEmpty ? title : value)
					.foregroundColor(value.isEmpty ? .ypGray : .black)
					.lineLimit(1)
				Spacer()
			}
		}
		.frame(height: 48)
	}
}
