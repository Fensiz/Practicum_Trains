//
//  SimpleTrip.swift
//  Trains
//
//  Created by Симонов Иван Дмитриевич on 21.07.2025.
//

import Foundation

struct SimpleTrip: Identifiable {
	let id: UUID = .init()
	var logoUrl: String?
	var carrierName: String
	var additionalInfo: String?
	var departureTime: String?
	var arrivalTime: String?
	var duration: String?
	var date: String?
}
