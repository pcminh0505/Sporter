/*
    RMIT University Vietnam
    Course: COSC2659 iOS Development
    Semester: 2022B
    Assessment: Assignment 3
    Author: Long Tran
    ID: s3755615
    Created date: 10/09/2022
    Last modified: 18/09/2022
*/

import Foundation
import FirebaseFirestoreSwift

struct Match: Codable, Identifiable {
    // Attributes for Match struct
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
