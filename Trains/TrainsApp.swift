//
//  TrainsApp.swift
//  Trains
//
//  Created by Симонов Иван Дмитриевич on 26.06.2025.
//

import SwiftUI

@main
struct TrainsApp: App {
	@StateObject private var appState = AppState()

	var body: some Scene {
		WindowGroup {
			if let dependencies = appState.dependencies {
				ContentView(viewModel: dependencies.getRootViewModel())
					.tint(.ypBlue)
					.environmentObject(dependencies)
			} else if let error = appState.error {
				ErrorView(error: error) {
					appState.retry()
				}
			} else {
				ProgressView("Загрузка...")
					.task {
						await appState.loadDependencies()
					}
			}
		}
	}
}

@MainActor final class AppState: ObservableObject {
	@Published var dependencies: AppDependencies?
	@Published var error: (any Error)?

	func loadDependencies() async {
		do {
			let deps = try AppDependencies()
			self.dependencies = deps
		} catch {
			self.error = error
		}
	}

	func retry() {
		dependencies = nil
		error = nil
		Task {
			await loadDependencies()
		}
	}
}

struct ErrorView: View {
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
