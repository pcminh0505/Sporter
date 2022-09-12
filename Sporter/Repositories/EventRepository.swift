//
//  EventRepository.swift
//  Sporter
//
//  Created by Khang on 12/09/2022.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine

class EventRespository: ObservableObject {
    private let db = Firestore.firestore()
    private let collection: String = "events"
    @Published var eventsByUser : [Event] = []
    @Published var eventsByVenue : [Event] = []
    
    init() {
        getEventsByCurrentUser()
    }
    
    func getEventsByCurrentUser() {
        let id = UserDefaults.standard.value(forKey: "currentUser") as? String ?? ""
        
        // Prevent crash
        if !id.isBlank {
            db.collection(collection).whereField("creator", isEqualTo: id)
              .addSnapshotListener { querySnapshot, error in
                // 4
                if let error = error {
                  print("Error getting venues: \(error.localizedDescription)")
                  return
                }

                  self.eventsByUser = querySnapshot?.documents.compactMap { document in
                    try? document.data(as: Event.self)
                } ?? []
              }
        }
    }
    
    func getEventsByVenue(id: Int) {
        db.collection(collection).whereField("venue", isEqualTo: id)
          .addSnapshotListener { querySnapshot, error in
            // 4
            if let error = error {
              print("Error getting venues: \(error.localizedDescription)")
              return
            }

              self.eventsByUser = querySnapshot?.documents.compactMap { document in
                try? document.data(as: Event.self)
            } ?? []
          }
    }
    
    func createEvent(_ event: Event) {
        do {
            let _ = try db.collection(collection).addDocument(from: event)
        } catch let error {
            print("Error adding User to Firestore: \(error.localizedDescription).")
        }
    }
    
    func updateEvent(_ event: Event) {
        guard let eventID = event.id else { return }
        do {
            try db.collection(collection).document(eventID).setData(from: event)
            print("Update user successfully")
        } catch let error {
            print("Error adding User to Firestore: \(error.localizedDescription).")
        }
    }
}
