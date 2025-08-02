//
//  CarrierService.swift
//  Trains
//
//  Created by Симонов Иван Дмитриевич on 27.06.2025.
//

import OpenAPIRuntime

typealias CarrierResponse = Components.Schemas.CarrierResponse

protocol CarrierServiceProtocol: Actor {
	func getCarrierInfo(code: String) async throws -> CarrierResponse
}

final actor CarrierService: CarrierServiceProtocol {
	private let client: Client
	private let apikey: String

	init(client: Client, apikey: String) {
		self.client = client
		self.apikey = apikey
	}

	func getCarrierInfo(code: String) async throws -> CarrierResponse {
		let response = try await client.getCarrierInfo(query: .init(apikey: apikey, code: code))
		return try response.ok.body.json
	}
}
