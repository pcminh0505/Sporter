//
//  VenueModel.swift
//  Sporter
//
//  Created by Khang on 03/09/2022.
//

import Foundation

struct Venue: Codable, Identifiable {
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
    let tag: String
    
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
        case tag
    }
    
    // For Firestore
    var dictionary: [String: Any] {
        let data = (try? JSONEncoder().encode(self)) ?? Data()
        return (try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]) ?? [:]
    }

}
