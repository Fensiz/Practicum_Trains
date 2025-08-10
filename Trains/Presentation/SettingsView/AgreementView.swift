//
//  AgreementView.swift
//  Trains
//
//  Created by Симонов Иван Дмитриевич on 10.08.2025.
//

import SwiftUI

struct AgreementView: View {
	@StateObject var viewModel = AgreementViewModel()
	@Binding var path: [Route]

	var body: some View {
		ZStack {
			ScrollView {
				AgreementWebView()
					.frame(height: UIScreen.main.bounds.height)
					.opacity(viewModel.webViewOpacity)
			}
			.frame(maxWidth: .infinity, maxHeight: .infinity)

			if !viewModel.isVisible {
				ProgressView()
					.progressViewStyle(CircularProgressViewStyle())
			}
		}
		.navigationTitle("Пользовательское соглашение")
		.withBackToolbar(path: $path)
		.task(viewModel.onFirstAppear)
	}
}
