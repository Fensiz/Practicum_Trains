//
//  NoInternetView.swift
//  Trains
//
//  Created by Симонов Иван Дмитриевич on 21.07.2025.
//

import SwiftUI

struct NoInternetErrorView: View {
	var body: some View {
		ZStack {
			Color.ypWhite.ignoresSafeArea()
			VStack(spacing: 16) {
				Image("no_internet")
				Text("Нет интернета")
					.font(.ypMediumBold)
			}
		}
	}
}

#Preview {
	NoInternetErrorView().preferredColorScheme(.dark)
}
