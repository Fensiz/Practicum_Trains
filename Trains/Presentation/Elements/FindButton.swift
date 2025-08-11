//
//  FindButton.swift
//  Trains
//
//  Created by Симонов Иван Дмитриевич on 09.08.2025.
//

import SwiftUI

struct FindButton: View {
	let action: () async -> Void

	var body: some View {
		Button {
			Task {
				await action()
			}
		} label: {
			Text("Найти")
				.font(.ypSmallBold)
				.foregroundStyle(.white)
				.frame(width: 150, height: Constants.buttonHeight)
				.background(Color.ypBlue)
				.clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
		}
	}
}
