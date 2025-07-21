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

	static func formatDateString(_ date: String?) -> String? {
		guard let date else { return nil }
		let inputFormatter = DateFormatter()
		inputFormatter.dateFormat = "yyyy-MM-dd"
		inputFormatter.locale = Locale(identifier: "ru_RU")

		if let date = inputFormatter.date(from: date) {
			let outputFormatter = DateFormatter()
			outputFormatter.dateFormat = "d MMMM"
			outputFormatter.locale = Locale(identifier: "ru_RU")

			let formatted = outputFormatter.string(from: date)
			return formatted
		}
		return nil
	}

	static func secondsToRoundedHoursString(_ seconds: Int?) -> String? {
		guard let seconds else { return nil }
		let hours = seconds / 3600
		let remainingSeconds = seconds % 3600
		let roundedHours = hours + (remainingSeconds > 0 ? 1 : 0)

		switch roundedHours {
		case 1:
			return "1 час"
		case 2...4:
			return "\(roundedHours) часа"
		default:
			return "\(roundedHours) часов"
		}
	}

	static func formatTime(from isoString: String) -> String? {
		let formatter = ISO8601DateFormatter()
		formatter.formatOptions = [.withInternetDateTime]

		guard let date = formatter.date(from: isoString) else { return nil }

		let outputFormatter = DateFormatter()
		outputFormatter.dateFormat = "HH:mm"

		return outputFormatter.string(from: date)
	}
}
