//
//  OptionsView.swift
//  Trains
//
//  Created by Симонов Иван Дмитриевич on 16.07.2025.
//

import SwiftUI

struct OptionsView: View {
	@State private var selections: [Bool] = Array(repeating: false, count: 4)
	@State private var isTransferEnabled: Bool? = nil
	var body: some View {
		VStack(spacing: 0) {
			TimeOptionView(selections: $selections)
			TransferView(isTransferEnabled: $isTransferEnabled)
			Spacer()
			if let _ = isTransferEnabled, selections.reduce(false, { $0 || $1 }) {
				Button("Применить") {

				}
				.buttonStyle(PrimaryButtonStyle())
				.padding(.bottom, 24)
				.padding(.horizontal, 16)
			}
				
		}
	}
}

struct TimeOptionView: View {
	@Binding var selections: [Bool]

	private let intervals: [String] = [
		"Утро 06:00 - 12:00",
		"День 12:00 - 18:00",
		"Вечер 18:00 - 00:00",
		"Ночь 00:00 - 06:00"
	]

	var body: some View {
		VStack(alignment: .leading, spacing: 0) {
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
		.padding(.horizontal, 16)
	}
}

struct TransferView: View {
	@Binding var isTransferEnabled: Bool?
	var body: some View {
		VStack(alignment: .leading, spacing: 0) {
			Text("Время отправления")
				.font(.ypMediumBold)
				.padding(.vertical, Constants.padding)

			Toggle("Да", isOn: Binding(
				get: { isTransferEnabled ?? false },
				set: { isTransferEnabled = $0 }
			))
			.toggleStyle(RadioToggleStyle())

			Toggle("Нет", isOn: Binding(
				get: {
					guard let isTransferEnabled else { return false }
					return !isTransferEnabled
				},
				set: { isTransferEnabled = !$0 }
			))
			.toggleStyle(RadioToggleStyle())
		}
		.frame(maxWidth: .infinity, alignment: .leading)
		.padding(.horizontal, Constants.padding)
	}
}

#Preview {
	OptionsView()
}

#Preview {
	TransferView(isTransferEnabled: .constant(false))
}
