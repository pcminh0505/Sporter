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

struct EventData: Identifiable {
    var id: UUID = UUID()
    var event: Event
    var creator: User
}

class EventRespository: ObservableObject {
    private let db = Firestore.firestore()
    private let eventCollection: String = "events"
    private let userCollection: String = "users"
    @Published var eventsByUser : [Event] = []
    @Published var eventsByVenue : [EventData] = []
    
    var queriedData =  [EventData]()
    
    init() {
        getEventsByCurrentUser()
    }
    
    func getEventsByCurrentUser() {
        let id = UserDefaults.standard.value(forKey: "currentUser") as? String ?? ""
        
        // Prevent crash
        if !id.isBlank {
            db.collection(eventCollection).whereField("creator", isEqualTo: id)
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
    
    func getEventsByVenue(_ id: Int) {
        db.collection(eventCollection).whereField("venue", isEqualTo: id)
          .addSnapshotListener { querySnapshot, error in
            // 4
            if let error = error {
              print("Error getting venues: \(error.localizedDescription)")
              return
            }

              if let events = querySnapshot?.documents.compactMap({ document in
                  try? document.data(as: Event.self)
              }) {
                  for e in events {
                      Task {
                          let user = try await self.getEventCreator(e.creator)
                          
                          let result = EventData.init(event: e, creator: user)
                          // Check if new event then append
                          if !self.eventsByVenue.contains(where: {$0.event.id == e.id}) {
                              self.eventsByVenue.append(result)
                          }
                      }
                  }
              }
          }
    }
    
    func createEvent(_ event: Event) {
        do {
            let _ = try db.collection(eventCollection).addDocument(from: event)
        } catch let error {
            print("Error adding User to Firestore: \(error.localizedDescription).")
        }
    }
    
    func updateEvent(_ event: Event) {
        guard let eventID = event.id else { return }
        do {
            try db.collection(eventCollection).document(eventID).setData(from: event)
            print("Update user successfully")
        } catch let error {
            print("Error adding User to Firestore: \(error.localizedDescription).")
        }
    }
    
    func getEventCreator(_ id : String) async throws -> User  {
        return try await db.collection(userCollection).document(id).getDocument(as: User.self)
    }
}
