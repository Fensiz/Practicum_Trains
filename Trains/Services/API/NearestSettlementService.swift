//
//  NearestSettlementService.swift
//  Trains
//
//  Created by Симонов Иван Дмитриевич on 27.06.2025.
//

import OpenAPIRuntime

typealias NearestCityResponse = Components.Schemas.NearestCityResponse

protocol NearestSettlementServiceProtocol: Actor {
	func getNearestCity(lat: Double, lng: Double) async throws -> NearestCityResponse
}

final actor NearestSettlementService: NearestSettlementServiceProtocol {
	private let client: Client
	private let apikey: String

	init(client: Client, apikey: String) {
		self.client = client
		self.apikey = apikey
	}

	func getNearestCity(lat: Double, lng: Double) async throws -> NearestCityResponse {
		let response = try await client.getNearestCity(
			query: .init(
				apikey: apikey,
				lat: lat,
				lng: lng
			)
		)
		return try response.ok.body.json
	}
}
