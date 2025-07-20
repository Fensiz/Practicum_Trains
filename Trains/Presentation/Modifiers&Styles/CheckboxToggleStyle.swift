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
				Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
					.resizable()
					.frame(width: 20, height: 20)
					.foregroundColor(.primary)
			}
		}
		.buttonStyle(PlainButtonStyle())
	}
}
