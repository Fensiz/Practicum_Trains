//
//  NearestStationsServiceProtocol.swift
//  Trains
//
//  Created by Симонов Иван Дмитриевич on 27.06.2025.
//

import OpenAPIRuntime

typealias CopyrightResponse = Components.Schemas.CopyrightResponse

protocol CopyrightServiceProtocol: Actor {
	func getCopyright() async throws -> CopyrightResponse
}

final actor CopyrightService: CopyrightServiceProtocol {
	private let client: Client
	private let apikey: String

	init(client: Client, apikey: String) {
		self.client = client
		self.apikey = apikey
	}

	func getCopyright() async throws -> CopyrightResponse {
		let response = try await client.getCopyright(query: .init(apikey: apikey))
		return try response.ok.body.json
	}
}
