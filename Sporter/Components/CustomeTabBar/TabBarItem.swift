//
//  TabBarItem.swift
//  Sporter
//
//  Created by Minh Pham on 09/09/2022.
//

import Foundation
import SwiftUI


enum TabBarItem: Hashable {
    case home, explore, profile, friend

    var iconName: String {
        switch self {
        case .home: return "house"
        case .explore: return "sparkle.magnifyingglass"
        case .profile: return "person"
        case .friend: return "person.3"
        }
    }

    var title: String {
        switch self {
        case .home: return "Home"
        case .explore: return "Explore"
        case .profile: return "Profile"
        case .friend: return "Friends"
        }
    }

    var color: Color {
        switch self {
        default: return Color.accentColor
        }
    }
}
