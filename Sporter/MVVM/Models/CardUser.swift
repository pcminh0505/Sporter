//
//  User.swift
//  TinderUI
//
//  Created by Long Tran on 04/09/2022.
//

import Foundation

struct CardUser: Identifiable {
    var id = UUID().uuidString
    var name: String
    var place: String
    var profilePic: String
}
