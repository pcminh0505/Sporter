//
//  VenueRepository.swift
//  Sporter
//
//  Created by Minh Pham on 30/08/2022.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine

class VenueRepository {
    private let db = Firestore.firestore()
    private let collection: String = "venues"
    @Published var venues: [Venue] = []
    
    init() {
        getAllVenues()
    }
    // Query Firestore for all venues
    func getAllVenues() {
        db.collection(collection)
          .addSnapshotListener { querySnapshot, error in
            // Error
            if let error = error {
              print("Error getting venues: \(error.localizedDescription)")
              return
            }

            // Get venues, map to venues array
            self.venues = querySnapshot?.documents.compactMap { document in
              try? document.data(as: Venue.self)
            } ?? []
          }
    }
}
