//
//  Utils.swift
//  Trains
//
//  Created by Симонов Иван Дмитриевич on 13.07.2025.
//

import UIKit

enum Utils {
	
	// MARK: - TabBar

	@MainActor static func setupTabBarAppearance() {
		let appearance = UITabBarAppearance()
		appearance.configureWithOpaqueBackground()
		appearance.backgroundColor = .systemBackground
		appearance.shadowColor = .separator

		UITabBar.appearance().standardAppearance = appearance
		if #available(iOS 15.0, *) {
			UITabBar.appearance().scrollEdgeAppearance = appearance
		}
	}

	// MARK: - Formatters

	private static let inputDateFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy-MM-dd"
		formatter.locale = Locale(identifier: "ru_RU")
		return formatter
	}()

	private static let outputDateFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateFormat = "d MMMM"
		formatter.locale = Locale(identifier: "ru_RU")
		return formatter
	}()

	private static let timeOutputFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateFormat = "HH:mm"
		return formatter
	}()

	nonisolated(unsafe) private static let isoFormatter: ISO8601DateFormatter = {
		let formatter = ISO8601DateFormatter()
		formatter.formatOptions = [.withInternetDateTime]
		return formatter
	}()

	// MARK: - Public Methods

	static func formatDateString(_ date: String?) -> String? {
		guard let date, let parsed = inputDateFormatter.date(from: date) else { return nil }
		return outputDateFormatter.string(from: parsed)
	}

	static func secondsToRoundedHoursString(_ seconds: Int?) -> String? {
		guard let seconds else { return nil }
		let hours = seconds / 3600
		let remainingSeconds = seconds % 3600
		let rounded = hours + (remainingSeconds > 0 ? 1 : 0)

		switch rounded {
			case 1: return "1 час"
			case 2...4: return "\(rounded) часа"
			default: return "\(rounded) часов"
		}
	}

	static func formatTime(from isoString: String) -> String? {
		guard let date = isoFormatter.date(from: isoString) else { return nil }
		return timeOutputFormatter.string(from: date)
	}
}
