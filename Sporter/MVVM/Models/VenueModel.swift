//
//  VenueModel.swift
//  Sporter
//
//  Created by Khang on 03/09/2022.
//

import Foundation
import CoreLocation

struct Venue: Codable, Identifiable, Equatable {
    let id: Int
    let name: String
    let address: String
    let phone: String
    let img: String
    let latitude : String
    let longitude: String
    let rating: String
    let website: String
    let open_time: String
    let close_time: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case address
        case phone
        case img
        case latitude
        case longitude
        case rating
        case website
        case open_time
        case close_time
    }
    
    static func == (lhs: Venue, rhs: Venue) -> Bool {
        return lhs.id == rhs.id
    }
    
    // For Firestore
    var dictionary: [String: Any] {
        let data = (try? JSONEncoder().encode(self)) ?? Data()
        return (try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]) ?? [:]
    }
}

extension Venue {
    static let sampleData: [Venue] = [
        Venue(
            id: 1,
            name: "Sample Venue",
            address: "Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
            phone: "911",
            img: "",
            latitude: "0",
            longitude: "0",
            rating: "0",
            website: "0",
            open_time: "9AM",
            close_time: "5PM"
        )
    ]
}
