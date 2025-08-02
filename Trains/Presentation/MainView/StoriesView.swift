//
//  StoriesView.swift
//  Trains
//
//  Created by Симонов Иван Дмитриевич on 22.07.2025.
//

import SwiftUI

struct StoriesView: View {
	private let stories: [Image] = [
		Image("stories_1"),
		Image("stories_2"),
		Image("stories_3"),
		Image("stories_4"),
		Image("stories_5"),
		Image("stories_6"),
	]

	var body: some View {
		ScrollView(.horizontal) {
			LazyHGrid(rows: [.init(.fixed(92), spacing: 12)]) {
				ForEach(0..<10) { i in
					stories[i % stories.count]
						.resizable()
						.aspectRatio(contentMode: .fill)
						.frame(width: 92, height: 140)
						.clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
				}
			}
			.padding(.horizontal, Constants.padding)
		}
		.frame(height: 140)
		.padding(.vertical, 24)
		.scrollIndicators(.hidden)
	}
}
