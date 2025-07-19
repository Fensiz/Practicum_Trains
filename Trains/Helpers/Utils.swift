//
//  Utils.swift
//  Trains
//
//  Created by Симонов Иван Дмитриевич on 13.07.2025.
//

import UIKit

enum Utils {
	@MainActor static func setupTabBarAppearance() {
		let appearance = UITabBarAppearance()
		appearance.configureWithOpaqueBackground()			// Убирает размытие и прозрачность
		appearance.backgroundColor = .systemBackground		// Устанавливает белый фон
		appearance.shadowColor = .separator					// Или .lightGray, если нужен разделитель

		// Применяет к обычному и прокручиваемому состоянию (iOS 15+)
		UITabBar.appearance().standardAppearance = appearance
		if #available(iOS 15.0, *) {
			UITabBar.appearance().scrollEdgeAppearance = appearance
		}
	}
}
