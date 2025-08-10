//
//  CityButton.swift
//  Trains
//
//  Created by Симонов Иван Дмитриевич on 19.07.2025.
//

import SwiftUI

struct CityButton: View {
	let title: String
	let value: SimpleStation?
	let action: () -> Void

	var body: some View {
		Button(action: action) {
			HStack {
				if let value, !value.title.isEmpty {
					Text(value.title)
						.foregroundColor(.black)
						.lineLimit(1)
				} else {
					Text(title)
						.foregroundColor(.ypGray)
						.lineLimit(1)
				}
				Spacer()
			}
		}
		.frame(height: 48)
	}
}
