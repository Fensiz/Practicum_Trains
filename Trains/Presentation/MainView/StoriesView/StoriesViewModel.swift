//
//  StoriesViewModel.swift
//  Trains
//
//  Created by Симонов Иван Дмитриевич on 27.07.2025.
//

import Combine
import SwiftUI

struct StoryBlock {
	let stories: [Story]
	var isViewed: Bool = false
}

final class StoriesViewModel: ObservableObject {

	// MARK: - Inner Types

	private struct Configuration {
		let timerTickInternal: TimeInterval
		let progressPerTick: CGFloat

		init(
			storiesCount: Int,
			secondsPerStory: TimeInterval = 5,
			timerTickInternal: TimeInterval = 0.05
		) {
			self.timerTickInternal = timerTickInternal
			self.progressPerTick = 1.0 / CGFloat(storiesCount) / secondsPerStory * timerTickInternal
		}
	}

	// MARK: - @Published properties

	@Published var progress: CGFloat = 0
	@Published var storyBlocks: [StoryBlock]
	@Published var isStoriesShowing: Bool = false
	@Published var finalOffset: CGFloat = 0

	// MARK: - Public properties

	var currentStoryIndex: Int { Int(progress * CGFloat(storyBlocks[selectedId].stories.count)) }
	var currentStory: Story { storyBlocks[selectedId].stories.isEmpty ? .story1 : storyBlocks[selectedId].stories[currentStoryIndex] }
	var currentBlock: StoryBlock { storyBlocks[selectedId] }

	// MARK: - Private properties

	private var selectedId: Int = 0
	private var configuration: Configuration
	private var timer: Timer.TimerPublisher? {
		didSet {
			cancellable?.cancel()
			cancellable = timer?
				.autoconnect()
				.sink { [weak self] _ in
					self?.tick()
				}
		}
	}
	private var cancellable: AnyCancellable?

	// MARK: - Initializators

	init(storyBlocks: [StoryBlock]) {
		self._storyBlocks = .init(initialValue: storyBlocks)
		self.configuration = Configuration(storiesCount: 0)
		self.progress = 0
	}

	// MARK: - Public methods

	private func start() {
		let stories = storyBlocks[selectedId].stories
		configuration = Configuration(storiesCount: stories.count)
		progress = CGFloat(0) / CGFloat(stories.count)
		timer = Timer.publish(every: configuration.timerTickInternal, on: .main, in: .common)
	}

	func previousStory() {
		if currentStoryIndex > 0 {
			let stories = storyBlocks[selectedId].stories
			progress = CGFloat(currentStoryIndex - 1) / CGFloat(stories.count)
		} else {
			previousBlock()
		}
	}

	func nextStory() {
		let stories = storyBlocks[selectedId].stories
		let currentIndex = currentStoryIndex
		if currentIndex < stories.count - 1 {
			progress = CGFloat(currentIndex + 1) / CGFloat(stories.count)
		} else {
			nextBlock()
		}
	}

	private func previousBlock() {
		if selectedId > 0 {
			selectedId -= 1
			let stories = storyBlocks[selectedId].stories
			progress = CGFloat(stories.count - 1) / CGFloat(stories.count)
		} else {
			progress = 0
		}
	}

	private func nextBlock() {
		if selectedId < storyBlocks.count - 1 {
			selectedId += 1
			progress = 0
			stop()
			start()
		} else {
			close()
		}
	}

	func showStory(with id: Int) {
		self.finalOffset = 0
		self.selectedId = id
		self.isStoriesShowing = true
		start()
	}

	func close() {
		self.stop()
		withAnimation {
			self.isStoriesShowing = false
		}
	}

	func stop() {
		cancellable?.cancel()
		cancellable = nil
	}

	// MARK: - Private methods

	private func tick() {
		markCurrentStoryBlockAsViewed()
		print(progress)
		let next = progress + configuration.progressPerTick
		if next >= 1 {
			nextBlock()
		} else {
			progress = next
		}
	}

	private func markCurrentStoryBlockAsViewed() {
		let stories = storyBlocks[selectedId].stories
		let index = currentStoryIndex
		guard
			stories.indices.contains(index),
				!stories[index].isViewed,
			index == stories.count - 1
		else { return }
		storyBlocks[selectedId].isViewed = true
	}
}
