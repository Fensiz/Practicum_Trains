//
//  AppDependencies.swift
//  Trains
//
//  Created by Симонов Иван Дмитриевич on 19.07.2025.
//

import OpenAPIURLSession
import Foundation

final class AppDependencies: ObservableObject {
	lazy var stationService = StationListService(client: client, apikey: apiKey)
	lazy var searchService = SearchService(client: client, apikey: apiKey)
	lazy var carrierService = CarrierService(client: client, apikey: apiKey)
	lazy var copyrightService = CopyrightService(client: client, apikey: apiKey)
	lazy var stationCacheService: any StationCacheServiceProtocol = StationCacheService()
	@MainActor lazy var settlementLoader: any SettlementLoaderProtocol = SettlementLoader(
		stationService: stationService,
		cacheService: stationCacheService
	)
	@MainActor func getMainViewModel(onError: @escaping (any Error) -> Void) -> MainViewModel {
		MainViewModel(
			loader: settlementLoader,
			searchService: searchService,
			carrierService: carrierService,
			onError: onError
		)
	}
	@MainActor func getRootViewModel() -> RootViewModel {
		RootViewModel()
	}
//	@MainActor lazy var mainViewModel = MainViewModel(
//		loader: settlementLoader,
//		searchService: searchService,
//		carrierService: carrierService
//	)

	private let client: Client
	private let apiKey: String

	init(
		client: Client? = nil,
		apiKey: String = "3a2b4d4f-964a-4f03-b983-efa9e5dfc15b"
	) throws {
		if let client {
			self.client = client
		} else {
			self.client = Client(
				serverURL: try Servers.Server1.url(),
				transport: URLSessionTransport()
			)
		}
		self.apiKey = apiKey
	}
}
