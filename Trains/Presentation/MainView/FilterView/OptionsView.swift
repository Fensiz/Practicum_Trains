//
//  OptionsView.swift
//  Trains
//
//  Created by Симонов Иван Дмитриевич on 16.07.2025.
//

import SwiftUI

struct OptionsView: View {
	@StateObject var viewModel: OptionsViewModel

	var body: some View {
		VStack(spacing: .zero) {
			TimeOptionView(selections: $viewModel.selectedTimeIntervals)
			TransferView(isTransferEnabled: $viewModel.transferFilter)
			Spacer()
			if viewModel.isButtonVisible {
				Button("Применить") {
					viewModel.applyFilters()
				}
				.buttonStyle(PrimaryButtonStyle())
				.padding(.bottom, Constants.paddingMedium)
				.padding(.horizontal, Constants.padding)
			}
		}
		.withBackToolbar(backAction: viewModel.backAction)
	}
}

// MARK: - OptionsView Previews

#Preview("Пустые фильтры (кнопки нет)") {
	OptionsView(
		viewModel: OptionsViewModel(
			selectedTimeIntervals: .constant([false, false, false, false]),
			transferFilter: .constant(nil),
			backAction: nil
		)
	)
	.preferredColorScheme(.light)
}

#Preview("Есть выбор (кнопка видна)") {
	OptionsView(
		viewModel: OptionsViewModel(
			selectedTimeIntervals: .constant([true, false, false, false]),
			transferFilter: .constant(true),
			backAction: nil
		)
	)
	.preferredColorScheme(.dark)
}
