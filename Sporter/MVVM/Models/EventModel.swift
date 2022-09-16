//
//  EventModel.swift
//  Sporter
//
//  Created by Khang on 12/09/2022.
//
import Foundation
import FirebaseFirestoreSwift

struct Event: Codable, Identifiable {
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
