//
//  OptionsViewModel.swift
//  Trains
//
//  Created by Симонов Иван Дмитриевич on 10.08.2025.
//

import SwiftUI

// MARK: - OptionsViewModel

@MainActor final class OptionsViewModel: ObservableObject {

	// MARK: - Published Properties

	@Published var selectedTimeIntervals: [Bool]
	@Published var transferFilter: Bool?

	// MARK: - External Bindings

	@Binding private var selectedTimeIntervalsExternal: [Bool]
	@Binding private var transferFilterExternal: Bool?

	// MARK: - Actions

	let backAction: (() -> Void)?

	// MARK: - Computed Properties

	var isButtonVisible: Bool {
		transferFilter != nil && selectedTimeIntervals.contains(true)
	}

	// MARK: - Initialization

	init(
		selectedTimeIntervals: Binding<[Bool]>,
		transferFilter: Binding<Bool?>,
		backAction: (() -> Void)? = nil
	) {
		_selectedTimeIntervals = .init(initialValue: selectedTimeIntervals.wrappedValue)
		_transferFilter = .init(initialValue: transferFilter.wrappedValue)
		_selectedTimeIntervalsExternal = selectedTimeIntervals
		_transferFilterExternal = transferFilter
		self.backAction = backAction
	}

	// MARK: - Methods

	func applyFilters() {
		selectedTimeIntervalsExternal = selectedTimeIntervals
		transferFilterExternal = transferFilter
		backAction?()
	}
}
