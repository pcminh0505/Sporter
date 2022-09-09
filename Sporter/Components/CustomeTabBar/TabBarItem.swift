//
//  TabBarItem.swift
//  Sporter
//
//  Created by Minh Pham on 09/09/2022.
//

import Foundation
import SwiftUI


enum TabBarItem: Hashable {
    case home, explore, profile, messages

    var iconName: String {
        switch self {
        case .home: return "house"
        case .explore: return "person.2"
        case .profile: return "person"
        case .messages: return "message"
        }
    }

    var title: String {
        switch self {
        case .home: return "Home"
        case .explore: return "Explore"
        case .profile: return "Profile"
        case .messages: return "Messages"
        }
    }

    var color: Color {
        switch self {
        case .home: return Color.accentColor
        case .explore: return Color.accentColor
        case .profile: return Color.accentColor
        case .messages: return Color.accentColor
        }
    }
}
