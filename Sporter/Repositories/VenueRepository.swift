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
    
    func getAllVenues() {
        db.collection(collection)
          .addSnapshotListener { querySnapshot, error in
            // 4
            if let error = error {
              print("Error getting venues: \(error.localizedDescription)")
              return
            }

            // 5
            self.venues = querySnapshot?.documents.compactMap { document in
              // 6
              try? document.data(as: Venue.self)
            } ?? []
          }
    }
    
    func getVenue() {
        print("GetVenue")
    }
}
