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
		VStack {
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

struct PrimaryButtonStyle: ButtonStyle {
	func makeBody(configuration: Configuration) -> some View {
		configuration.label
			.foregroundStyle(.white)
			.font(.system(size: 17, weight: .bold))
			.frame(height: 60)
			.frame(maxWidth: .infinity)
			.background(
				RoundedRectangle(cornerRadius: 16)
					.fill(Color.ypBlue)
					.opacity(configuration.isPressed ? 0.8 : 1.0)
			)
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
				.font(.system(size: 24, weight: .bold))
				.padding(.vertical, 16)

			ForEach(intervals.indices, id: \.self) { index in
				Toggle(intervals[index], isOn: $selections[index])
					.font(.system(size: 17))
					.toggleStyle(CheckboxToggleStyle())
					.frame(height: 60)
			}
		}
		.frame(maxWidth: .infinity, alignment: .leading)
		.padding(.horizontal, 16)
	}
}

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
				Image(systemName: configuration.isOn ? "largecircle.fill.circle" : "circle")
					.foregroundColor(.primary)
					.imageScale(.large)
			}
		}
		.buttonStyle(.plain)
	}
}

struct TransferView: View {
	@Binding var isTransferEnabled: Bool?
	var body: some View {
		VStack(alignment: .leading, spacing: 0) {
			Text("Время отправления")
				.font(.system(size: 24, weight: .bold))
				.padding(.vertical, 16)

			Toggle("Да", isOn: Binding(
				get: { isTransferEnabled ?? false },
				set: { isTransferEnabled = $0 }
			))
				.font(.system(size: 17))
				.toggleStyle(RadioToggleStyle())
				.frame(height: 60)

			Toggle("Нет", isOn: Binding(
				get: {
					guard let isTransferEnabled else { return false }
					return !isTransferEnabled
				},
				set: { isTransferEnabled = !$0 }
			))
				.font(.system(size: 17))
				.toggleStyle(RadioToggleStyle())
				.frame(height: 60)
		}
		.frame(maxWidth: .infinity, alignment: .leading)
		.padding(.horizontal, 16)
	}
}

#Preview {
	OptionsView()
}
