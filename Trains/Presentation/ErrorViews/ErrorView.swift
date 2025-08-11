//
//  AppErrorType.swift
//  Trains
//
//  Created by Симонов Иван Дмитриевич on 11.08.2025.
//

import SwiftUI

struct ErrorView: View {
	let type: AppErrorType

	var body: some View {
		ZStack {
			Color.ypWhite.ignoresSafeArea()
			VStack(spacing: 16) {
				Image(type.imageName)
				Text(type.message)
					.font(.ypMediumBold)
			}
		}
	}
}

#Preview {
	VStack {
		ErrorView(type: .noInternet)
		ErrorView(type: .server)
		ErrorView(type: .unknown)
	}
	.preferredColorScheme(.dark)
}
