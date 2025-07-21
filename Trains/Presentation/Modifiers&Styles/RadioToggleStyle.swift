//
//  RadioToggleStyle.swift
//  Trains
//
//  Created by Симонов Иван Дмитриевич on 19.07.2025.
//

import SwiftUI

struct RadioToggleStyle: ToggleStyle {
	func makeBody(configuration: Configuration) -> some View {
		Button(action: {
			if !configuration.isOn {
				configuration.isOn = true
			}
		}) {
			HStack {
				configuration.label
				Spacer()
				Image(configuration.isOn ? "radio.on" : "radio.off")
					.resizable()
					.frame(
						width: Constants.logoSmallSize,
						height: Constants.logoSmallSize
					)
					.foregroundColor(.primary)
			}
		}
		.buttonStyle(.plain)
		.frame(height: Constants.buttonHeight)
		.font(.ypMedium)
	}
}
