//
//  SettingsView.swift
//  Trains
//
//  Created by Симонов Иван Дмитриевич on 19.07.2025.
//

import SwiftUI

struct SettingsView: View {
	@AppStorage("isDarkMode") private var isDarkThemeEnabled = false
	@State private var path: [String] = []
	public var body: some View {
		NavigationStack(path: $path) {
			VStack(spacing: 0) {
				List {
					Toggle(isOn: $isDarkThemeEnabled) {
						Text("Темная тема")
					}
					.listRowSeparator(.hidden)
					.listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
					.frame(height: 60)
					.tint(.ypBlue)
					SelectableRow(title: "Пользовательское соглашение") {
						path.append("detail")
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
			.navigationDestination(for: String.self) { value in
				if value == "detail" {
					Text("123")
				}
			}
		}
	}
}
