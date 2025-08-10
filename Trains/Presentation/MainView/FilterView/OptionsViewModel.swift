//
//  OptionsViewModel.swift
//  Trains
//
//  Created by Симонов Иван Дмитриевич on 10.08.2025.
//

import SwiftUI

@MainActor final class OptionsViewModel: ObservableObject {
	@Published var selectedTimeIntervals: [Bool]
	@Published var transferFilter: Bool?
	let backAction: (() -> Void)?
	var isButtonVisible: Bool {
		transferFilter != nil && selectedTimeIntervals.reduce(false, { $0 || $1 })
	}
	@Binding private var selectedTimeIntervalsExternal: [Bool]
	@Binding private var transferFilterExternal: Bool?

	init(
		selectedTimeIntervals: Binding<[Bool]>,
		transferFilter: Binding<Bool?>,
		backAction: (() -> Void)? = nil
	) {
		self._selectedTimeIntervals = .init(initialValue: selectedTimeIntervals.wrappedValue)
		self._transferFilter = .init(initialValue: transferFilter.wrappedValue)
		self._selectedTimeIntervalsExternal = selectedTimeIntervals
		self._transferFilterExternal = transferFilter
		self.backAction = backAction
	}

	func applyFilters() {
		selectedTimeIntervalsExternal = selectedTimeIntervals
		transferFilterExternal = transferFilter
		backAction?()
	}
}
