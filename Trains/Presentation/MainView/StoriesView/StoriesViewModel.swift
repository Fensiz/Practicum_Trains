//
//  StoriesViewModel.swift
//  Trains
//
//  Created by Симонов Иван Дмитриевич on 27.07.2025.
//

import Combine
import SwiftUI

final class StoriesViewModel: ObservableObject {
	private struct Configuration {
		let timerTickInternal: TimeInterval
		let progressPerTick: CGFloat

		init(storiesCount: Int, secondsPerStory: TimeInterval = 5, timerTickInternal: TimeInterval = 0.05) {
			self.timerTickInternal = timerTickInternal
			self.progressPerTick = 1.0 / CGFloat(storiesCount) / secondsPerStory * timerTickInternal
		}
	}

	@Published var progress: CGFloat = 0
	@Binding private(set) var stories: [Story]

	var currentStoryIndex: Int { Int(progress * CGFloat(stories.count)) }
	var currentStory: Story { stories.isEmpty ? .story1 : stories[currentStoryIndex] }

	private let selectedId: Int
	private let closeAction: () -> Void
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

	init(stories: Binding<[Story]>, selectedId: Int, closeAction: @escaping () -> Void) {
		self._stories = stories
		self.selectedId = selectedId
		self.closeAction = closeAction
		self.configuration = Configuration(storiesCount: stories.count)
		self.progress = CGFloat(selectedId) / CGFloat(stories.count)
	}

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

	func close() {
		self.stop()
		self.closeAction()
	}

	func stop() {
		cancellable?.cancel()
		cancellable = nil
	}

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
