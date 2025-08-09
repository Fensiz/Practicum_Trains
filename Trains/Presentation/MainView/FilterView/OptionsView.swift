//
//  OptionsView.swift
//  Trains
//
//  Created by Симонов Иван Дмитриевич on 16.07.2025.
//

import SwiftUI

struct OptionsView: View {
	@ObservedObject private var viewModel: TripsViewModel
	@Binding private var path: [Route]
	@State private var selectedTimeIntervals: [Bool]
	@State private var transferFilter: Bool?

	init(viewModel: TripsViewModel, path: Binding<[Route]>) {
		self.viewModel = viewModel
		self._path = path
		if let transferFilter = viewModel.transferFilter {
			_transferFilter = .init(initialValue: transferFilter)
		} else {
			_transferFilter = .init(initialValue: nil)
		}
		selectedTimeIntervals = viewModel.selectedTimeIntervals
	}

	var body: some View {
		VStack(spacing: .zero) {
			TimeOptionView(selections: $selectedTimeIntervals)
			TransferView(isTransferEnabled: $transferFilter)
			Spacer()
			if let _ = transferFilter, selectedTimeIntervals.reduce(false, { $0 || $1 }) {
				Button("Применить") {
					viewModel.selectedTimeIntervals = selectedTimeIntervals
					viewModel.transferFilter = transferFilter
//					viewModel.applyFilters()
					path.removeLast()
				}
				.buttonStyle(PrimaryButtonStyle())
				.padding(.bottom, Constants.paddingMedium)
				.padding(.horizontal, Constants.padding)
			}
		}
		.withBackToolbar(path: $path)
	}
}

#Preview {
	TransferView(isTransferEnabled: .constant(false))
}
