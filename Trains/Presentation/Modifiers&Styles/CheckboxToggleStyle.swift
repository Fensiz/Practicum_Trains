//
//  CheckboxToggleStyle.swift
//  Trains
//
//  Created by Симонов Иван Дмитриевич on 19.07.2025.
//

import SwiftUI

struct CheckboxToggleStyle: ToggleStyle {
	func makeBody(configuration: Configuration) -> some View {
		Button(action: {
			configuration.isOn.toggle()
		}) {
			HStack {
				configuration.label
				Spacer()
				Image(configuration.isOn ? "checkbox.on" : "checkbox.off")
					.resizable()
					.frame(
						width: Constants.logoSmallSize,
						height: Constants.logoSmallSize
					)
					.foregroundColor(.primary)
			}
		}
		.buttonStyle(PlainButtonStyle())
	}
}
