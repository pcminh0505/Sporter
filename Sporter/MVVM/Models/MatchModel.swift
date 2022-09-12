//
//  MatchModel.swift
//  Sporter
//
//  Created by Long Tran on 10/09/2022.
//

import Foundation
import FirebaseFirestoreSwift

struct Match: Codable, Identifiable {
    @DocumentID var id: String?
    var sender: String
    var receiver: String
    var accept: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case sender
        case receiver
        case accept
    }

    // For Firestore
    var dictionary: [String: Any] {
        let data = (try? JSONEncoder().encode(self)) ?? Data()
        return (try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]) ?? [:]
    }
}
