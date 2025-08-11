//
//  StoryBlock.swift
//  Trains
//
//  Created by Симонов Иван Дмитриевич on 10.08.2025.
//

struct StoryBlock: Sendable {
	let id: String
	let stories: [Story]
	var isViewed: Bool = false
}
