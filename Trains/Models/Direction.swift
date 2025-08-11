//
//  Direction.swift
//  Trains
//
//  Created by Симонов Иван Дмитриевич on 21.07.2025.
//

import SwiftUI

enum Direction: Sendable {
	case from(Binding<SimpleStation?>)
	case to(Binding<SimpleStation?>)
}
