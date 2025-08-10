//
//  StoryView.swift
//  Trains
//
//  Created by Симонов Иван Дмитриевич on 27.07.2025.
//

import SwiftUI

struct StoryView: View {
	let story: Story

	var body: some View {
		GeometryReader { proxy in
			ZStack(alignment: .bottomLeading) {
				story.image
					.resizable()
					.scaledToFill()
					.frame(width: proxy.size.width, height: proxy.size.height)
					.clipped()

				VStack(alignment: .leading, spacing: 16) {
					Text(story.title)
						.lineLimit(2)
						.font(.ypBigBold)
					Text(story.text)
						.lineLimit(3)
						.font(.ypBig)
				}
				.foregroundStyle(.white)
				.padding(.horizontal, 16)
				.padding(.bottom, 40 + (Utils.safeAreaInsets?.bottom ?? 44)
				)
				.frame(width: proxy.size.width)
			}
			.frame(width: proxy.size.width, height: proxy.size.height)
		}
		.ignoresSafeArea()
	}
}

#Preview {
	StoryView(story: .story1)
}
