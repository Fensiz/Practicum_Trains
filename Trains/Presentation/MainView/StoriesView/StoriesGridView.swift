//
//  StoriesGridView.swift
//  Trains
//
//  Created by Симонов Иван Дмитриевич on 27.07.2025.
//

import SwiftUI

struct StoriesGridView: View {
	@Binding var stories: [Story]
	@Binding var isStoriesShowning: Bool
	@Binding var selectedStoryId: Int?

	var body: some View {
		ScrollView(.horizontal) {
			LazyHGrid(rows: [.init(.fixed(92), spacing: 12)]) {
				ForEach(stories.indices, id: \.self) { i in
					let story = stories[i % stories.count]
					story.image
						.resizable()
						.aspectRatio(contentMode: .fill)
						.frame(width: 92, height: 140)
						.overlay {
							RoundedRectangle(cornerRadius: Constants.cornerRadius)
								.strokeBorder(Color.ypBlue, lineWidth: story.isViewed ? 0 : 4)
						}
						.clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
						.opacity(story.isViewed ? 0.5 : 1)
						.onTapGesture {
							selectedStoryId = i
							withAnimation(.spring()) {
								isStoriesShowning = true
							}
						}
				}
			}
			.padding(.horizontal, Constants.padding)
		}
		.frame(height: 140)
		.padding(.vertical, 24)
		.scrollIndicators(.hidden)
	}
}
