//
//  ThreadService.swift
//  Trains
//
//  Created by Симонов Иван Дмитриевич on 27.06.2025.
//

import OpenAPIRuntime

typealias ThreadStationsResponse = Components.Schemas.ThreadStationsResponse

protocol ThreadServiceProtocol {
	func getRouteStations(uid: String) async throws -> ThreadStationsResponse
}

final class ThreadService: ThreadServiceProtocol {
	private let client: Client
	private let apikey: String

	init(client: Client, apikey: String) {
		self.client = client
		self.apikey = apikey
	}

	func getRouteStations(uid: String) async throws -> ThreadStationsResponse {
		let response = try await client.getRouteStations(query: .init(apikey: apikey, uid: uid))
		return try response.ok.body.json
	}
}
