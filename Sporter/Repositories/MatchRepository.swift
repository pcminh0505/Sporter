/*
    RMIT University Vietnam
    Course: COSC2659 iOS Development
    Semester: 2022B
    Assessment: Assignment 3
    Author: Long Tran
    ID: s3755615
    Created date: 12/09/2022
    Last modified: 18/09/2022
*/

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import SwiftUI

class MatchRepository: ObservableObject {
    private let db = Firestore.firestore()
    private let collection: String = "match"
    @Published var matches: [Match] = []
    @Published var currentUser: User? = nil
    @Published var matchUsers: [User] = []
    @Published var currentFriendlist: [String] = []
    init() {
        getAllMatchRequest()
    }
    
    func resetAndInit() {
        self.matches = []
        self.matchUsers = []
        getAllMatchRequest()
    }
    
    // Get all match request of current user
    func getAllMatchRequest() {
        // Except the current logged user
        let id = UserDefaults.standard.value(forKey: "currentUser") as? String ?? ""
        
        // Prevent crash
        if !id.isBlank {
            db.collection("users").document(id)
                .addSnapshotListener { doc, err in
                if let doc = doc {
                    do {
                        let data = try doc.data(as: User.self)
                        self.currentUser = data
                    } catch let err {
                        print("Error fetching data: \(err)")
                    }

                }
            }
        }
        
        db.collection(collection).whereField("receiver", isEqualTo: id)
            .addSnapshotListener { [self] (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                    print("No documents")
                    return
                }
                
                // Get in match into a list from documents
                for doc in documents {
                    let data = doc.data()
                    
                    let match = Match(id: doc.documentID,
                                      sender: data["sender"] as! String,
                                      receiver: data["receiver"] as! String,
                                      accept: (data["accept"] != nil))
                    
                    // If current friend list does not have the match
                    currentFriendlist = currentUser?.friends ?? []
                    if (!currentFriendlist.contains(match.sender)) {
                        // Add people to match list for display
                        matches.append(match)
                        
                        // Fetch each users
                        let docRef = self.db.collection("users").document(data["sender"] as! String)
                        docRef.getDocument(as: User.self) { result in
                            switch result {
                            case .success(let user):
                                self.matchUsers.append(user)
                            case .failure(let error):
                                // A User value could not be initialized from the DocumentSnapshot.
                                print("Error decoding document: \(error.localizedDescription)")
                            }
                        }
                    }
                    else {
                        // Delete the match request
                        deleteMatch(match)
                    }
                }
                
                let temp: [Match] = matches.reversed()
                self.matches = temp
            }
    }
    
    // Create a new match request
    func createMatch(matchID: String, _ match: Match) {
        var cancel: Bool = false
        matches.forEach { matching in
            if (matching.sender == match.receiver) {
                if (matching.receiver == match.sender) {
                    print("Sending to existing request")
                    cancel = true
                }
            }
        }
        
        if (!cancel) {
            do {
                try db.collection(collection).document(matchID).setData(from: match)
            } catch let error {
                print("Error adding User to Firestore: \(error.localizedDescription).")
            }
        }
    }
    
    // Update match request
    func updateMatch(_ match: Match) {
        guard let matchID = match.id else { return }
        
        do {
            try db.collection(collection).document(matchID).setData(from: match)
        } catch let error {
            print("Error updating Match to Firestore: \(error.localizedDescription).")
        }
    }
    
    // Delete match request
    func deleteMatch (_ match: Match) {
        self.matches = []
        self.matchUsers = []
        db.collection(collection).document(match.id!).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
}
