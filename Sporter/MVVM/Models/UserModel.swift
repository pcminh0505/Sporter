/*
    RMIT University Vietnam
    Course: COSC2659 iOS Development
    Semester: 2022B
    Assessment: Assignment 3
    Author: Minh Pham
    ID: s3818102
    Created date: 30/08/2022
    Last modified: 18/09/2022
*/

import Foundation
import FirebaseFirestoreSwift

struct User: Codable, Identifiable {
    // attributes for User struct
    @DocumentID var id: String?
    var fname: String
    var lname: String
    var gender: String
    var bod: TimeInterval
    var email: String
    var phone: String
    
    var profileImage: String = "https://t4.ftcdn.net/jpg/00/64/67/63/360_F_64676383_LdbmhiNM6Ypzb3FM4PPuFP9rHe7ri8Ju.jpg"
    var friends: [String] = []
    var weight: Double = 0
    var height: Double = 0
    var sportType: String = SportType.none.rawValue
    var level: String = Level.none.rawValue
    
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
        
        case weight
        case height
        case sportType
        case level
    }

    // For Firestore
    var dictionary: [String: Any] {
        let data = (try? JSONEncoder().encode(self)) ?? Data()
        return (try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]) ?? [:]
    }
    // object for UI previews
    static let unset = User(fname: "Minh", lname: "Pham", gender: "male", bod: 0, email: "pcminh0505@gmail.com", phone: "0123456789")
}
// user gender values
enum Gender: String, CaseIterable, Identifiable {
    case male
    case female
    case other
    var id: String { self.rawValue }
}
// user level values
enum Level: String, CaseIterable, Identifiable {
    case beginner
    case casual
    case expert
    case none
    var id: String { self.rawValue }
}
// user sport type values
enum SportType: String, CaseIterable, Identifiable {
    case strength
    case health
    case endurance
    case none
    var id: String { self.rawValue }
}

