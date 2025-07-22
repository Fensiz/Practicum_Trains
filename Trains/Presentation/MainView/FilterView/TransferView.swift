//
//  TransferView.swift
//  Trains
//
//  Created by Симонов Иван Дмитриевич on 21.07.2025.
//

import SwiftUI

struct TransferView: View {
	@Binding var isTransferEnabled: Bool?
	
	var body: some View {
		VStack(alignment: .leading, spacing: .zero) {
			Text("Показывать варианты с пересадками")
				.font(.ypMediumBold)
				.padding(.vertical, Constants.padding)

			Toggle("Да", isOn: Binding(
				get: { isTransferEnabled ?? false },
				set: { isTransferEnabled = $0 }
			))
			.toggleStyle(RadioToggleStyle())

			Toggle("Нет", isOn: Binding(
				get: {
					guard let isTransferEnabled else { return false }
					return !isTransferEnabled
				},
				set: { isTransferEnabled = !$0 }
			))
			.toggleStyle(RadioToggleStyle())
		}
		.frame(maxWidth: .infinity, alignment: .leading)
		.padding(.horizontal, Constants.padding)
	}
}
