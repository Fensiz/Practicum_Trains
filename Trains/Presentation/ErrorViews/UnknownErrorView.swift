//
//  ServerErrorView.swift
//  Trains
//
//  Created by Симонов Иван Дмитриевич on 21.07.2025.
//

import SwiftUI

struct UnknownErrorView: View {
	var body: some View {
		ZStack {
			Color.ypWhite.ignoresSafeArea()
			VStack(spacing: 16) {
				Image("server_error")
				Text("Неизвестная ошибка")
					.font(.ypMediumBold)
			}
		}
	}
}

#Preview {
	UnknownErrorView().preferredColorScheme(.dark)
}
