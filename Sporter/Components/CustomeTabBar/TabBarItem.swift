//
//  TabBarItem.swift
//  Sporter
//
//  Created by Minh Pham on 09/09/2022.
//

import Foundation
import SwiftUI


enum TabBarItem: Hashable {
    case home, explore, profile

    var iconName: String {
        switch self {
        case .home: return "house"
        case .explore: return "person.2"
        case .profile: return "person"
        }
    }

    var title: String {
        switch self {
        case .home: return "Home"
        case .explore: return "Explore"
        case .profile: return "Profile"
        }
    }

    var color: Color {
        switch self {
        default: return Color.accentColor
        }
    }
}
