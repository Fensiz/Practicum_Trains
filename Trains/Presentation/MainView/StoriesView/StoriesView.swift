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

	var body: some View {
		ZStack(alignment: .topTrailing) {
			StoryView(story: viewModel.currentStory)
			VStack(alignment: .trailing, spacing: 16) {
				ProgressBar(
					numberOfSections: viewModel.currentBlock.stories.count,
					progress: viewModel.progress
				)
				CloseButton(closeAction: viewModel.close)
				HStack {
					Color.clear
						.contentShape(Rectangle())
						.onTapGesture {
							viewModel.previousStory()
						}
					Color.clear
						.contentShape(Rectangle())
						.onTapGesture {
							viewModel.nextStory()
						}
				}
				.ignoresSafeArea()
				Spacer()
			}
			.padding(.horizontal, 16)
			.padding(.top, Utils.safeAreaInsets?.top ?? 44)

		}
		.ignoresSafeArea()
		.offset(y: viewModel.finalOffset + dragOffset)
		.gesture(
			DragGesture(minimumDistance: 30)
				.updating($dragOffset) { value, state, _ in
					if value.translation.height < 0 {
						state = value.translation.height
					}
				}
				.onEnded { value in
					if value.translation.height < -50 {
						viewModel.finalOffset = value.translation.height
						viewModel.close()
					}
				}
		)
		.frame(maxHeight: .infinity, alignment: .top)
		.transition(.move(edge: .top))
		.zIndex(1)
		.toolbar(.hidden, for: .tabBar)
	}
}

private struct PreviewView: View {
	@State private var show = false
	@State private var selectedStoryId: Int?
	@State private var isShowingStoryDetails: Bool = false
	var body: some View {

		ZStack {
			let storyService = StoryService()
			let vm = StoriesViewModel(storyService: storyService)
			StoriesGridView(viewModel: vm)
				.onTapGesture {
					withAnimation(.spring()) {
						show = true
					}
				}
			if show {
				StoriesView(viewModel: vm)
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
}
