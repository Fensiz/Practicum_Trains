//
//  ServerErrorView.swift
//  Trains
//
//  Created by Симонов Иван Дмитриевич on 21.07.2025.
//

import SwiftUI

struct ServerErrorView: View {
	var body: some View {
		ZStack {
			Color.ypWhite.ignoresSafeArea()
			VStack(spacing: 16) {
				Image("server_error")
				Text("Ошибка сервера")
					.font(.ypMediumBold)
			}
		}
	}
}

#Preview {
	ServerErrorView().preferredColorScheme(.dark)
}
