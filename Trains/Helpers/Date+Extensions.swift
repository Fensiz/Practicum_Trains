//
//  Date+Extension.swift
//  Trains
//
//  Created by Симонов Иван Дмитриевич on 20.07.2025.
//

import Foundation

extension Date {
	func toISODateString() -> String {
		let formatter = DateFormatter()
		formatter.locale = Locale(identifier: "en_US_POSIX")
		formatter.dateFormat = "yyyy-MM-dd"
		return formatter.string(from: self)
	}
}
