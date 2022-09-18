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
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine

struct EventData: Identifiable {
    var id: UUID = UUID()
    var event: Event
    var creator: User
    var venue: Venue
}


class EventRespository: ObservableObject {
    private let db = Firestore.firestore()
    private let eventCollection: String = "events"
    private let userCollection: String = "users"
    private let venueCollection: String = "venues"
    @Published var eventsByUser: [EventData] = []
    @Published var eventsByVenue: [EventData] = []

    // Query Firestore for events that current user attends
    func getEventsByCurrentUser() {
        let id = UserDefaults.standard.value(forKey: "currentUser") as? String ?? ""

        // Prevent crash
        if !id.isBlank {
            db.collection(eventCollection).whereField("participants", arrayContains: id)
                .addSnapshotListener { querySnapshot, error in
                // Error
                if let error = error {
                    print("Error getting events: \(error.localizedDescription)")
                    return
                }
                // Get events, map to eventsByUser, with each event's venue and creator
                if let events = querySnapshot?.documents.compactMap({ document in
                    try? document.data(as: Event.self)
                }) {
                    for e in events {
                        Task {
                            // Get event's creator and venue
                            let user = try await self.getEventCreator(e.creator)
                            let venue = try await self.getEventVenue(e.venue)

                            let result = EventData.init(event: e, creator: user, venue: venue)
                            // Check if new event then append
                            if !self.eventsByUser.contains(where: { $0.event.id == e.id }) {
                                self.eventsByUser.append(result)
                            }
                        }
                    }
                }
            }
        }
    }
    // Query Firestore for events that a venue host
    func getEventsByVenue(_ id: Int) {
        db.collection(eventCollection).whereField("venue", isEqualTo: id)
            .addSnapshotListener { querySnapshot, error in
            // Error
            if let error = error {
                print("Error getting events: \(error.localizedDescription)")
                return
            }
            // Get events, map to eventsByVenue, with each event's venue and creator
            if let events = querySnapshot?.documents.compactMap({ document in
                try? document.data(as: Event.self)
            }) {
                for e in events {
                    Task {
                        // Get event's creator and venue
                        let user = try await self.getEventCreator(e.creator)
                        let venue = try await self.getEventVenue(e.venue)
                        
                        // If private event, check current user friendship with event creator
                        if e.isPrivate {
                            let id = UserDefaults.standard.value(forKey: "currentUser") as? String ?? ""
                            // If is event creator -> add event to list
                            // If friend with creator -> add
                            // If not friend -> skip event
                            if id != e.creator {
                                if !id.isBlank {
                                    if !user.friends.contains(id) {
                                        return
                                    }
                                }
                            }
                        }

                        let result = EventData.init(event: e, creator: user, venue: venue)
                        // Check if new event then append
                        if !self.eventsByVenue.contains(where: { $0.event.id == e.id }) {
                            self.eventsByVenue.append(result)
                        }
                    }
                }
            }
        }
    }
    // Create new event on Firestore
    func createEvent(_ event: Event) {
        do {
            let _ = try db.collection(eventCollection).addDocument(from: event)
        } catch let error {
            print("Error adding event to Firestore: \(error.localizedDescription).")
        }
    }
    // Update existing event on Firetore
    func updateEvent(_ event: Event, isWithdraw: Bool) {
        guard let eventID = event.id else { return }
        do {
            try db.collection(eventCollection).document(eventID).setData(from: event)
            print("Update event successfully")
        } catch let error {
            print("Error updating event to Firestore: \(error.localizedDescription).")
        }
        if isWithdraw {
            eventsByUser.removeAll(where: { $0.event.id == eventID })
        }
    }
    // Delete existing event on Firestore
    func deleteEvent(_ event: Event) {
        guard let eventID = event.id else { return }
        db.collection(eventCollection).document(eventID).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            }
            else {
                print("Document successfully removed!")
            }
        }
        eventsByUser.removeAll(where: { $0.event.id == eventID })
    }
    // Get event creator
    func getEventCreator(_ id: String) async throws -> User {
        return try await db.collection(userCollection).document(id).getDocument(as: User.self)
    }
    // Get event venue
    func getEventVenue(_ id: Int) async throws -> Venue {
        return try await db.collection(venueCollection).document(String(id)).getDocument(as: Venue.self)
    }
}
