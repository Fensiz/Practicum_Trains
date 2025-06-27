//
//  StationListServiceProtocol.swift
//  Trains
//
//  Created by Симонов Иван Дмитриевич on 27.06.2025.
//

import OpenAPIRuntime
//import OpenAPIURLSession
import Foundation

typealias AllStationsResponse = Components.Schemas.AllStationsResponse

protocol StationListServiceProtocol {
	func getAllStations() async throws -> AllStationsResponse
}

final class StationListService: StationListServiceProtocol {
	private let client: Client
	private let apikey: String

	init(client: Client, apikey: String) {
		self.client = client
		self.apikey = apikey
	}

	func getAllStations() async throws -> AllStationsResponse {
		let response = try await client.getAllStations(query: .init(apikey: apikey))

		let responseBody = try response.ok.body.html

		let limit = 50 * 1024 * 1024 // 50Mb

		var fullData = try await Data(collecting: responseBody, upTo: limit)

		let allStations = try JSONDecoder().decode(AllStationsResponse.self, from: fullData)

		return allStations
	}
}
