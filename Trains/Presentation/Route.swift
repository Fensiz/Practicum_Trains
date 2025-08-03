//
//  Route.swift
//  Trains
//
//  Created by Симонов Иван Дмитриевич on 22.07.2025.
//

enum Route: Hashable {
	case selectCity(Direction)
	case selectStation(Direction)
	case trips
	case filters
	case agreement
	case carrierDetails(SimpleCarrier)

	static func == (lhs: Route, rhs: Route) -> Bool {
		switch (lhs, rhs) {
			case (.selectCity, .selectCity): true
			case (.selectStation, .selectStation): true
			case (.trips, .trips): true
			case (.filters, .filters): true
			case (.agreement, .agreement): true
			case (.carrierDetails, .carrierDetails): true
			default: false
		}
	}

	func hash(into hasher: inout Hasher) {
		// Уникальные константы, чтобы отличать маршруты
		switch self {
			case .selectCity:
				hasher.combine("selectCity")
			case .selectStation:
				hasher.combine("selectStation")
			case .trips:
				hasher.combine("trips")
			case .filters:
				hasher.combine("filters")
			case .agreement:
				hasher.combine("agreement")
			case .carrierDetails:
				hasher.combine("carrierDetails")
		}
	}
}
