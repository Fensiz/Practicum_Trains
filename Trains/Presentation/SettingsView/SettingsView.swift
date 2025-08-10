//
//  SettingsView.swift
//  Trains
//
//  Created by Симонов Иван Дмитриевич on 19.07.2025.
//

import SwiftUI

struct SettingsView: View {
	@AppStorage("isDarkMode") private var isDarkThemeEnabled = false
	@Binding var path: [Route]

	public var body: some View {
		VStack(spacing: .zero) {
			List {
				Toggle(isOn: $isDarkThemeEnabled) {
					Text("Темная тема")
				}
				.listRowSeparator(.hidden)
				.listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
				.frame(height: 60)
				.tint(.ypBlue)
				SelectableRow(title: "Пользовательское соглашение") {
					path.append(.agreement)
				}
			}
			.listStyle(.plain)

			VStack(spacing: 16) {
				Text("Приложение использует API \"Яндекс.Расписания\"")
				Text("Версия 1.0(beta)")
			}
			.font(.ypSmall)
			.padding(.horizontal, 16)
			.padding(.bottom, 24)
		}
	}
}

struct AgreementView: View {
	@State private var isVisible = true
	@Binding var path: [Route]
	@EnvironmentObject private var dependencies: AppDependencies
	@State var text: String = ""

	var body: some View {
		ZStack {
			ScrollView {
				AgreementWebView()
					.frame(height: UIScreen.main.bounds.height)
					.opacity(isVisible ? 1 : 0)
			}
			.frame(maxWidth: .infinity, maxHeight: .infinity)

			if !isVisible {
				ProgressView()
					.progressViewStyle(CircularProgressViewStyle())
			}
		}
		.navigationTitle("Пользовательское соглашение")
		.withBackToolbar(path: $path)
		.task {
				try? await Task.sleep(nanoseconds: 1_000)
				isVisible = false
				try? await Task.sleep(nanoseconds: 3_000_000_000)
				isVisible = true
		}
	}
}
