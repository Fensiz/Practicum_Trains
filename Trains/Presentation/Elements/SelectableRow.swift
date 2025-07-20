//
//  SelectableRow.swift
//  Trains
//
//  Created by Симонов Иван Дмитриевич on 19.07.2025.
//

import SwiftUI

struct SelectableRow: View {
	let title: String
	let action: () -> Void

	var body: some View {
		Button(action: action) {
			HStack {
				Text(title)
					.font(.ypMedium)
					.foregroundColor(.primary)
				Spacer()
				Image("chevron")
					.resizable()
					.frame(width: 24, height: 24)
					.tint(.primary)
			}
			.frame(height: 60)
		}
		.listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
		.listRowSeparator(.hidden)
	}
}
