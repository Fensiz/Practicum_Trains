//
//  TimeOptionView.swift
//  Trains
//
//  Created by Симонов Иван Дмитриевич on 21.07.2025.
//

import SwiftUI

struct TimeOptionView: View {
	@Binding var selections: [Bool]

	private let intervals: [String] = [
		"Утро 06:00 - 12:00",
		"День 12:00 - 18:00",
		"Вечер 18:00 - 00:00",
		"Ночь 00:00 - 06:00"
	]

	var body: some View {
		VStack(alignment: .leading, spacing: .zero) {
			Text("Время отправления")
				.font(.ypMediumBold)
				.padding(.vertical, 16)

			ForEach(intervals.indices, id: \.self) { index in
				Toggle(intervals[index], isOn: $selections[index])
					.font(.ypMedium)
					.toggleStyle(CheckboxToggleStyle())
					.frame(height: 60)
			}
		}
		.frame(maxWidth: .infinity, alignment: .leading)
		.padding(.horizontal, Constants.padding)
	}
}
