//
//  PrimaryButtonStyle.swift
//  Trains
//
//  Created by Симонов Иван Дмитриевич on 19.07.2025.
//

import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
	func makeBody(configuration: Configuration) -> some View {
		configuration.label
			.foregroundStyle(.white)
			.font(.ypSmallBold)
			.frame(height: Constants.buttonHeight)
			.frame(maxWidth: .infinity)
			.background(
				RoundedRectangle(cornerRadius: Constants.cornerRadius)
					.fill(Color.ypBlue)
					.opacity(configuration.isPressed ? 0.8 : 1.0)
			)
	}
}
