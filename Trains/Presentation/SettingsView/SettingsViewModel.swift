//
//  SettingsViewModel.swift
//  Trains
//
//  Created by Симонов Иван Дмитриевич on 10.08.2025.
//

import SwiftUI

@MainActor final class SettingsViewModel: ObservableObject {
	@AppStorage("isDarkMode") var isDarkThemeEnabled = false
}
