//
//  UserModel.swift
//  Sporter
//
//  Created by Minh Pham on 30/08/2022.
//

import Foundation
import FirebaseFirestoreSwift

struct User: Codable, Identifiable {
    @DocumentID var id: String?
    var fname: String
    var lname: String
    var gender: String
    var bod: TimeInterval
    var email: String
    var phone: String
    var profileImage: String
    var friends: [String]

    enum CodingKeys: String, CodingKey {
        case id
        case fname
        case lname
        case gender
        case bod
        case email
        case phone
        case profileImage
        case friends
    }

    // For Firestore
    var dictionary: [String: Any] {
        let data = (try? JSONEncoder().encode(self)) ?? Data()
        return (try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]) ?? [:]
    }
}

