//
//  CloseButton.swift
//  Trains
//
//  Created by Симонов Иван Дмитриевич on 27.07.2025.
//

import SwiftUI

struct CloseButton: View {
	let closeAction: () -> Void

	var body: some View {
		Button {
			closeAction()
		} label: {
			Image("xmark")
				.resizable()
				.frame(width: 30, height: 30)
				.symbolRenderingMode(.palette)
				.foregroundStyle(.white, .black)
		}
	}
}
