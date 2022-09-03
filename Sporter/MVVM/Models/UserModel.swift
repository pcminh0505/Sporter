//
//  UserModel.swift
//  Sporter
//
//  Created by Minh Pham on 30/08/2022.
//

import Foundation

struct User: Codable {
    let id: String
    let fname: String
    let lname: String
    let email: String
    let phone: String
    let friends: [String]

    enum CodingKeys: String, CodingKey {
        case id
        case fname
        case lname
        case email
        case phone
        case friends
    }

    // For Firestore
    var dictionary: [String: Any] {
        let data = (try? JSONEncoder().encode(self)) ?? Data()
        return (try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]) ?? [:]
    }
}
