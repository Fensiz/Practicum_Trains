//
//  SimpleErrorView.swift
//  Trains
//
//  Created by Симонов Иван Дмитриевич on 11.08.2025.
//

import SwiftUI

struct SimpleErrorView: View {
	let error: any Error
	let onRetry: () -> Void

	var body: some View {
		VStack {
			Text("Произошла ошибка:")
			Text(error.localizedDescription)
				.font(.caption)
				.multilineTextAlignment(.center)
				.padding()
			Button("Повторить", action: onRetry)
		}
		.padding()
	}
}
