//
//  ProgressBar.swift
//  Trains
//
//  Created by Симонов Иван Дмитриевич on 27.07.2025.
//

import SwiftUI

struct ProgressBar: View {

	let numberOfSections: Int
	let progress: CGFloat

	var body: some View {
		// Используем `GeometryReader` для получения размеров экрана
		GeometryReader { geometry in
			// Используем `ZStack` для отображения белой подложки прогресс бара и синей полоски прогресса
			ZStack(alignment: .leading) {
				// Белая подложка прогресс бара
				RoundedRectangle(cornerRadius: .progressBarCornerRadius)
					.frame(width: geometry.size.width, height: .progressBarHeight)
					.foregroundColor(.white)

				// Синяя полоска текущего прогресса
				RoundedRectangle(cornerRadius: .progressBarCornerRadius)
					.frame(
						// Ширина прогресса зависит от текущего прогресса.
						// Используем `min` на случай, если `progress` > 1
						width: min(
							progress * geometry.size.width,
							geometry.size.width
						),
						height: .progressBarHeight
					)
					.foregroundColor(.progressBarFill)
			}
			// Добавляем маску
			.mask {
				MaskView(numberOfSections: numberOfSections)
			}
		}
		.fixedSize(horizontal: false, vertical: true)
		.frame(height: .progressBarHeight)
	}
}

private struct MaskFragmentView: View {
	var body: some View {
		// Фрагмент маски - прямоугольник с закругленными углами и фиксированной высотой
		RoundedRectangle(cornerRadius: .progressBarCornerRadius)
			.fixedSize(horizontal: false, vertical: true)
			.frame(height: .progressBarHeight)
			.foregroundStyle(.white) // Здесь можно указать любой непрозрачный цвет
	}
}

// Маска с разбитием на секции
private struct MaskView: View {
	// Количество секций
	let numberOfSections: Int

	var body: some View {
		// Секции образуют горизонтальный стек
		HStack {
			// С помощью конструктора `ForEach` добавляем нужное колечество секций
			ForEach(0..<numberOfSections, id: \.self) { _ in
				MaskFragmentView()
			}
		}
	}
}
