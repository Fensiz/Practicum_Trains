//
//  OptionsView.swift
//  Trains
//
//  Created by Симонов Иван Дмитриевич on 16.07.2025.
//

import SwiftUI

struct OptionsView: View {
	@ObservedObject private var viewModel: MainViewModel
	@Binding private var path: [Route]

	init(viewModel: MainViewModel, path: Binding<[Route]>) {
		self.viewModel = viewModel
		self._path = path
	}

	var body: some View {
		VStack(spacing: 0) {
			TimeOptionView(selections: $viewModel.selectedTimeIntervals)
			TransferView(isTransferEnabled: $viewModel.transferFilter)
			Spacer()
			if let _ = viewModel.transferFilter, viewModel.selectedTimeIntervals.reduce(false, { $0 || $1 }) {
				Button("Применить") {
					viewModel.applyFilters()
					path.removeLast()
				}
				.buttonStyle(PrimaryButtonStyle())
				.padding(.bottom, 24)
				.padding(.horizontal, 16)
			}
		}
		.withBackToolbar(path: $path)
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
			Text("Показывать варианты с пересадками")
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

//#Preview {
//	OptionsView()
//}

#Preview {
	TransferView(isTransferEnabled: .constant(false))
}
