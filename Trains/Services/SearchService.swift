//
//  ScheduleBetweenStations.swift
//  Trains
//
//  Created by Симонов Иван Дмитриевич on 27.06.2025.
//

import OpenAPIRuntime

typealias Segments = Components.Schemas.Segments

protocol SearchServiceProtocol {
	func getScheduleBetweenStations(from: String, to: String) async throws -> Segments
}

final class SearchService: SearchServiceProtocol {
	private let client: Client
	private let apikey: String

	init(client: Client, apikey: String) {
		self.client = client
		self.apikey = apikey
	}

	func getScheduleBetweenStations(from: String, to: String) async throws -> Segments {
		let response = try await client.getScheduleBetweenStations(query: .init(apikey: apikey, from: from, to: to))
		return try response.ok.body.json
	}
}
