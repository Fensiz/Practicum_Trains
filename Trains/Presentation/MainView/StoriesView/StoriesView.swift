//
//  StoriesView.swift
//  Trains
//
//  Created by Симонов Иван Дмитриевич on 22.07.2025.
//

import SwiftUI

struct StoriesView: View {
	@StateObject var viewModel: StoriesViewModel
	@GestureState private var dragOffset: CGFloat = 0
	@State private var finalOffset: CGFloat = 0

	var body: some View {
		ZStack(alignment: .topTrailing) {
			StoryView(story: viewModel.currentStory)
			VStack(alignment: .trailing, spacing: 16) {
				ProgressBar(
					numberOfSections: viewModel.stories.count,
					progress: viewModel.progress
				)
				CloseButton(closeAction: viewModel.close)
				Spacer()
			}
			.padding(.horizontal, 16)
			.padding(.top, Utils.safeAreaInsets?.top ?? 44)
		}
		.ignoresSafeArea()
		.onTapGesture {
			viewModel.nextStory()
		}
		.offset(y: finalOffset + dragOffset)
		.gesture(
			DragGesture(minimumDistance: 30)
				.updating($dragOffset) { value, state, _ in
					if value.translation.height < 0 {
						state = value.translation.height
					}
				}
				.onEnded { value in
					if value.translation.height < -50 {
						finalOffset = value.translation.height
						viewModel.close()
					}
				}
		)
		.onAppear {
			viewModel.start()
		}
		.frame(maxHeight: .infinity, alignment: .top)
		.transition(.move(edge: .top))
		.zIndex(1)
		.toolbar(.hidden, for: .tabBar)
	}
}

struct PreviewView: View {
	@State private var show = false
	@State private var selectedStoryId: Int?
	@State private var isShowingStoryDetails: Bool = false
	var body: some View {

		ZStack {
			StoriesGridView(stories: .constant([.story1, .story2]), isStoriesShowning: $show, selectedStoryId: $selectedStoryId)
				.onTapGesture {
					withAnimation(.spring()) {
						show = true
					}
				}
			if show {
				StoriesView(
					viewModel: StoriesViewModel(
						stories: .constant([.story1, .story2, .story3, .story4]),
						selectedId: 0,
						closeAction: {
							withAnimation(.spring()) {
								show = false
							}
						})
				)
				.frame(maxHeight: .infinity, alignment: .top)
				.transition(.move(edge: .top))
				.zIndex(1)
			}
		}
		.ignoresSafeArea()
	}
}

#Preview {
	PreviewView()
//	StoriesView(stories: [.story1, .story2, .story1], closeAction: { print("+") })
}

//#Preview {
//	StoriesView(stories: [.story1, .story2], closeAction: {})
//}

#Preview {
	StoryView(story: .story1)
}
