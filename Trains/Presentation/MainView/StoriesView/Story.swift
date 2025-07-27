//
//  Story.swift
//  Trains
//
//  Created by Симонов Иван Дмитриевич on 27.07.2025.
//

import SwiftUI

struct Story {
	let title: String
	let text: String
	let image: Image
	var isViewed: Bool = false

	static let story1: Story = .init(
		title: "Text text text text texty.. text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text",
		text: "Text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text",
		image: Image("stories_1")
	)
	static let story2: Story = .init(
		title: "Text text text text texty.. text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text",
		text: "Text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text",
		image: Image("stories_2")
	)
	static let story3: Story = .init(
		title: "Text text text text texty.. text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text",
		text: "Text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text",
		image: Image("stories_3")
	)
	static let story4: Story = .init(
		title: "Text text text text texty.. text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text",
		text: "Text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text",
		image: Image("stories_4")
	)
	static let story5: Story = .init(
		title: "Text text text text texty.. text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text",
		text: "Text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text",
		image: Image("stories_5")
	)
}
