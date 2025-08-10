//
//  AgreementViewModel.swift
//  Trains
//
//  Created by Симонов Иван Дмитриевич on 10.08.2025.
//

import SwiftUI

@MainActor final class AgreementViewModel: ObservableObject {
	@Published var isVisible = true
	var webViewOpacity: Double {
		isVisible ? 1 : 0
	}

	func onFirstAppear() async {
		try? await Task.sleep(nanoseconds: 1_000)
		isVisible = false
		try? await Task.sleep(nanoseconds: 3_000_000_000)
		isVisible = true
	}
}
