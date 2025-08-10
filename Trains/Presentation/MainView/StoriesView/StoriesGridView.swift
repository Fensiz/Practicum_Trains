//
//  StoriesGridView.swift
//  Trains
//
//  Created by Симонов Иван Дмитриевич on 27.07.2025.
//

import SwiftUI

struct StoriesGridView: View {
	@ObservedObject var viewModel: StoriesViewModel

	var body: some View {
		ScrollView(.horizontal) {
			LazyHGrid(rows: [.init(.fixed(92), spacing: 12)]) {
				ForEach(viewModel.storyBlocks.indices, id: \.self) { i in
					let storyBlock = viewModel.storyBlocks[i % viewModel.storyBlocks.count]
					if let story = storyBlock.stories.first {
						ZStack(alignment: .bottomLeading) {
							story.image
								.resizable()
								.aspectRatio(contentMode: .fill)
								.frame(width: 92, height: 140)
								.overlay {
									RoundedRectangle(cornerRadius: Constants.cornerRadius)
										.strokeBorder(Color.ypBlue, lineWidth: storyBlock.isViewed ? 0 : 4)
								}
								.clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
								.onTapGesture {
									withAnimation(.spring()) {
										viewModel.showStory(with: i)
									}
								}
							Text(story.title)
								.lineLimit(3)
								.font(.ypSmall)
								.padding(8)
								.frame(maxWidth: 92)
						}
						.opacity(storyBlock.isViewed ? 0.5 : 1)
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
