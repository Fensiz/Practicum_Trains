//
//  StationCacheServiceProtocol.swift
//  Trains
//
//  Created by Симонов Иван Дмитриевич on 19.07.2025.
//

import Foundation

protocol StationCacheServiceProtocol {
	func loadCache() -> AllStationsResponse?
	func saveCache(_ response: AllStationsResponse) throws
}


final class StationCacheService: StationCacheServiceProtocol {
	private let cacheURL: URL = {
		let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
		return docDir.appendingPathComponent("AllStationsCache.json")
	}()

	func loadCache() -> AllStationsResponse? {
		guard FileManager.default.fileExists(atPath: cacheURL.path) else { return nil }

		guard let fileHandle = try? FileHandle(forReadingFrom: cacheURL) else { return nil }
		defer { try? fileHandle.close() }

		guard
			let data = try? fileHandle.readToEnd() ?? Data(),
			let decoded = try? JSONDecoder().decode(AllStationsResponse.self, from: data)
		else { return nil }
		return decoded
	}

	func saveCache(_ response: AllStationsResponse) throws {
		let data = try JSONEncoder().encode(response)

		if !FileManager.default.fileExists(atPath: cacheURL.path) {
			FileManager.default.createFile(atPath: cacheURL.path, contents: nil)
		}
		let fileHandle = try FileHandle(forWritingTo: cacheURL)
		defer { try? fileHandle.close() }

		try fileHandle.truncate(atOffset: 0)
		try fileHandle.write(contentsOf: data)
	}
}
