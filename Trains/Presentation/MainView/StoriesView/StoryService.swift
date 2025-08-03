//
//  StoryService.swift
//  Trains
//
//  Created by Симонов Иван Дмитриевич on 02.08.2025.
//

import Foundation

protocol StoryServiceProtocol: Actor {
	func fetchStoryBlocks() async -> [StoryBlock]
	func markBlockAsViewed(_ id: String)
}

final actor StoryService: StoryServiceProtocol {
	private let viewedKey = "viewedStoryBlockIDs"

	// MARK: - Viewed blocks persistence

	func markBlockAsViewed(_ id: String) {
		var ids = loadViewedBlockIDs()
		ids.insert(id)
		UserDefaults.standard.set(Array(ids), forKey: viewedKey)
	}

	private func loadViewedBlockIDs() -> Set<String> {
		let array = UserDefaults.standard.stringArray(forKey: viewedKey) ?? []
		return Set(array)
	}

	// MARK: - Mocked stories and blocks

	func fetchStoryBlocks() async -> [StoryBlock]  {
		let viewedIDs = loadViewedBlockIDs()

		let blocks = [
			StoryBlock(id: "block_1", stories: [.story1, .story2]),
			StoryBlock(id: "block_2", stories: [.story3, .story4]),
			StoryBlock(id: "block_3", stories: [.story5, .story6]),
			StoryBlock(id: "block_4", stories: [.story7, .story8]),
			StoryBlock(id: "block_5", stories: [.story9, .story10]),
			StoryBlock(id: "block_6", stories: [.story11, .story12]),
			StoryBlock(id: "block_7", stories: [.story13, .story14]),
			StoryBlock(id: "block_8", stories: [.story15, .story16]),
			StoryBlock(id: "block_9", stories: [.story17, .story18]),
		]

		return blocks.map { block in
			var copy = block
			copy.isViewed = viewedIDs.contains(block.id)
			return copy
		}
	}
}
