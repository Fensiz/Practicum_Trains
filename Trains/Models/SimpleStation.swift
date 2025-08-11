//
//  SimpleStation.swift
//  Trains
//
//  Created by Симонов Иван Дмитриевич on 21.07.2025.
//

struct SimpleStation: Identifiable, Equatable, Sendable {
	let title: String
	let code: String
	var id: String { code }
}
