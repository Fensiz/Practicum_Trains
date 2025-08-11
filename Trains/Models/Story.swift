//
//  Story.swift
//  Trains
//
//  Created by Симонов Иван Дмитриевич on 27.07.2025.
//

import SwiftUI

struct Story: Sendable {
	let title: String
	let text: String
	let image: Image
	var isViewed: Bool = false

	private static let textSample: String = "Text text text text texty.. text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text"

	static let story1: Story = .init(
		title: textSample,
		text: textSample,
		image: Image("story_1")
	)
	static let story2: Story = .init(
		title: textSample,
		text: textSample,
		image: Image("story_2")
	)
	static let story3: Story = .init(
		title: textSample,
		text: textSample,
		image: Image("story_3")
	)
	static let story4: Story = .init(
		title: textSample,
		text: textSample,
		image: Image("story_4")
	)
	static let story5: Story = .init(
		title: textSample,
		text: textSample,
		image: Image("story_5")
	)
	static let story6: Story = .init(
		title: textSample,
		text: textSample,
		image: Image("story_6")
	)
	static let story7: Story = .init(
		title: textSample,
		text: textSample,
		image: Image("story_7")
	)
	static let story8: Story = .init(
		title: textSample,
		text: textSample,
		image: Image("story_8")
	)
	static let story9: Story = .init(
		title: textSample,
		text: textSample,
		image: Image("story_9")
	)
	static let story10: Story = .init(
		title: textSample,
		text: textSample,
		image: Image("story_10")
	)
	static let story11: Story = .init(
		title: textSample,
		text: textSample,
		image: Image("story_11")
	)
	static let story12: Story = .init(
		title: textSample,
		text: textSample,
		image: Image("story_12")
	)
	static let story13: Story = .init(
		title: textSample,
		text: textSample,
		image: Image("story_13")
	)
	static let story14: Story = .init(
		title: textSample,
		text: textSample,
		image: Image("story_14")
	)
	static let story15: Story = .init(
		title: textSample,
		text: textSample,
		image: Image("story_15")
	)
	static let story16: Story = .init(
		title: textSample,
		text: textSample,
		image: Image("story_16")
	)
	static let story17: Story = .init(
		title: textSample,
		text: textSample,
		image: Image("story_17")
	)
	static let story18: Story = .init(
		title: textSample,
		text: textSample,
		image: Image("story_12")
	)
}
