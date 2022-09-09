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
    let gender: String
    let bod: TimeInterval
    let email: String
    let phone: String
    let friends: [String]
    


    enum CodingKeys: String, CodingKey {
        case id
        case fname
        case lname
        case gender
        case bod
        case email
        case phone
        case friends
    }

    // For Firestore
    var dictionary: [String: Any] {
        let data = (try? JSONEncoder().encode(self)) ?? Data()
        return (try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]) ?? [:]
    }
    
    static var unset = User(id: "-1", fname: "FName", lname: "LName", gender: "Male", bod: 123123, email: "test@gmail.com", phone: "+84123456789", friends: [])
}
