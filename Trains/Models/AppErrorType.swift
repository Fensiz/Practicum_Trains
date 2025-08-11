//
//  AppErrorType.swift
//  Trains
//
//  Created by Симонов Иван Дмитриевич on 11.08.2025.
//

enum AppErrorType: Sendable {
	case noInternet
	case server
	case unknown

	var imageName: String {
		switch self {
			case .noInternet: return "no_internet"
			case .server: return "server_error"
			case .unknown: return "server_error"
		}
	}

	var message: String {
		switch self {
			case .noInternet: return "Нет интернета"
			case .server: return "Ошибка сервера"
			case .unknown: return "Неизвестная ошибка"
		}
	}
}
