//
//  BackToolbarModifier.swift
//  Trains
//
//  Created by Симонов Иван Дмитриевич on 18.07.2025.
//

import SwiftUI

struct BackToolbarModifier: ViewModifier {
	@Binding var path: [Route]

	func body(content: Content) -> some View {
		content
			.toolbar {
				ToolbarItem(placement: .navigationBarLeading) {
					if !path.isEmpty {
						Button(action: {
							path.removeLast()
						}) {
							Image(systemName: "chevron.left")
						}
					}
				}
			}
	}
}

extension View {
	func withBackToolbar(path: Binding<[Route]>) -> some View {
		self.modifier(BackToolbarModifier(path: path))
	}
}
