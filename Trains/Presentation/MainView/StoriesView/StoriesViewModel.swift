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
	let isViewed: Bool
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
	@Published private(set) var stories: [Story]
	@Published var isStoriesShowing: Bool = false
	@Published var finalOffset: CGFloat = 0

	// MARK: - Public properties

	var currentStoryIndex: Int { Int(progress * CGFloat(stories.count)) }
	var currentStory: Story { stories.isEmpty ? .story1 : stories[currentStoryIndex] }

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

	init(stories: [Story]) {
		self._stories = .init(initialValue: stories)
		self.configuration = Configuration(storiesCount: stories.count)
		self.progress = CGFloat(selectedId) / CGFloat(stories.count)
	}

	// MARK: - Public methods

	func start() {
		configuration = Configuration(storiesCount: stories.count)
		progress = CGFloat(selectedId) / CGFloat(stories.count)
		timer = Timer.publish(every: configuration.timerTickInternal, on: .main, in: .common)
	}

	func nextStory() {
		let currentIndex = currentStoryIndex
		if currentIndex < stories.count - 1 {
			progress = CGFloat(currentIndex + 1) / CGFloat(stories.count)
		} else {
			progress = 0
		}
	}

	func showStory(with id: Int) {
		self.finalOffset = 0
		self.selectedId = id
		self.isStoriesShowing = true
		start()
		print("+")
	}

	func close() {
		self.stop()
		self.isStoriesShowing = false
		print("-")
	}

	func stop() {
		cancellable?.cancel()
		cancellable = nil
	}

	// MARK: - Private methods

	private func tick() {
		markCurrentStoryAsViewed()
		let next = progress + configuration.progressPerTick
		progress = next >= 1 ? 0 : next
	}

	private func markCurrentStoryAsViewed() {
		let index = currentStoryIndex
		guard stories.indices.contains(index), !stories[index].isViewed else { return }
		stories[index].isViewed = true
	}
}
