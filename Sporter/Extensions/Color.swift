//
//  Color.swift
//  Sporter
//
//  Created by Minh Pham on 31/08/2022.
//

import Foundation
import SwiftUI

// Color extension to allow using custom color theme in Asset
extension Color {
    static let theme = ColorTheme()
}

struct ColorTheme {
    let textColor = Color("TextColor")

    let lightGray = Color("Gray")
    let darkGray = Color("DarkGray")
    let red = Color("Red")
    let darkRed = Color("DarkRed")
}
