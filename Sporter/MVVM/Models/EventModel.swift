/*
    RMIT University Vietnam
    Course: COSC2659 iOS Development
    Semester: 2022B
    Assessment: Assignment 3
    Author: Khang Nguyen
    ID: s3817970
    Created date: 12/09/2022
    Last modified: 18/09/2022
*/

import Foundation
import FirebaseFirestoreSwift

struct Event: Codable, Identifiable {
    // Attributes for Event struct
    @DocumentID var id: String?
    var title: String
    var description: String
    var creator: String
    var venue: Int
    var startTime: TimeInterval
    var endTime: TimeInterval
    var isPrivate: Bool
    var participants: [String] = []
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case creator
        case venue
        case startTime
        case endTime
        case isPrivate
        case participants
    }

    // For Firestore
    var dictionary: [String: Any] {
        let data = (try? JSONEncoder().encode(self)) ?? Data()
        return (try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]) ?? [:]
    }
}
