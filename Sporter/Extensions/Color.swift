/*
    RMIT University Vietnam
    Course: COSC2659 iOS Development
    Semester: 2022B
    Assessment: Assignment 3
    Author: Minh Pham
    ID: s3818102
    Created date: 31/08/2022
    Last modified: 18/09/2022
*/

import Foundation
import SwiftUI

// Color extension to allow using custom color theme in Asset
extension Color {
    static let theme = ColorTheme()
}

struct ColorTheme {
    let textColor = Color("TextColor")
    let popupColor = Color("PopupColor")

    let lightGray = Color("Gray")
    let darkGray = Color("DarkGray")
    let red = Color("Red")
    let darkRed = Color("DarkRed")
}
