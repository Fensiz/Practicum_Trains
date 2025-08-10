//
//  MainViewModel.swift
//  Trains
//
//  Created by Симонов Иван Дмитриевич on 15.07.2025.
//

import SwiftUI
import Combine

@MainActor final class MainViewModel: ObservableObject {
	@Published var selectedFromStation: SimpleStation? = nil
	@Published var selectedToStation: SimpleStation? = nil

	private let onError: (any Error) -> Void

	var isFindButtonShowing: Bool {
		guard let selectedFromStation, let selectedToStation else {
			return false
		}
		return selectedFromStation != selectedToStation
	}

	@Published var allCities: [SettlementShort] = []

	private var loader: any SettlementLoaderProtocol
	private var cancellables = Set<AnyCancellable>()

	init(
		loader: any SettlementLoaderProtocol,
		onError: @escaping (any Error) -> Void
	) {
		self.loader = loader
		self.onError = onError
		loader.settlementsPublisher
			.receive(on: RunLoop.main)
			.sink(receiveCompletion: { [weak self] completion in
				if case let .failure(error) = completion {
					self?.onError(error)
				}
			}, receiveValue: { [weak self] settlements in
				self?.allCities = settlements
			})
			.store(in: &cancellables)
	}

	func startFetching() {
		loader.fetchAllStations()
	}

	func swapCities() {
		swap(&selectedToStation, &selectedFromStation)
	}
}
