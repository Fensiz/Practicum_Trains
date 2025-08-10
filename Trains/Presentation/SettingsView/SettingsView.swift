//
//  SettingsView.swift
//  Trains
//
//  Created by Симонов Иван Дмитриевич on 19.07.2025.
//

import SwiftUI

struct SettingsView: View {
	@StateObject var viewModel: SettingsViewModel
	@Binding var path: [Route]

	public var body: some View {
		VStack(spacing: .zero) {
			List {
				Toggle(isOn: $viewModel.isDarkThemeEnabled) {
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
