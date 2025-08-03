//
//  AgreementWebView.swift
//  Trains
//
//  Created by Симонов Иван Дмитриевич on 28.07.2025.
//

import SwiftUI
import WebKit

struct AgreementWebView: UIViewRepresentable {
	let url: URL = URL(string: "https://yandex.ru/legal/timetable_termsofuse/ru/")!

	func makeCoordinator() -> Coordinator {
		Coordinator()
	}

	func makeUIView(context: Context) -> WKWebView {
		let webView = WKWebView()
		webView.isUserInteractionEnabled = false
		webView.navigationDelegate = context.coordinator
		return webView
	}

	func updateUIView(_ uiView: WKWebView, context: Context) {
		uiView.load(URLRequest(url: url))
	}

	class Coordinator: NSObject, WKNavigationDelegate {
		func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
			let isDark = webView.traitCollection.userInterfaceStyle == .dark

			let js = """
			if ('\(isDark)' === 'true') {
				document.documentElement.style.filter = 'invert(1) hue-rotate(180deg)';
				document.body.style.backgroundColor = '#000';
				document.body.style.color = '#fff';
			}
			"""
			webView.evaluateJavaScript(js, completionHandler: { result, error in
				if let error {
					print("JavaScript error: \(error.localizedDescription)")
				}
			})
		}
	}
}
