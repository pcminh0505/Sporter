//
//  MatchRepository.swift
//  Sporter
//
//  Created by Long Tran on 12/09/2022.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class MatchRepository: ObservableObject {
    private let db = Firestore.firestore()
    private let collection: String = "match"
    @Published var matches: [Match] = []
    @Published var matchUsers: [User] = []
    
    init() {
        getAllMatchRequest()
    }
    
    func resetAndInit() {
        self.matches = []
        self.matchUsers = []
        getAllMatchRequest()
    }
    
    func getAllMatchRequest() {
        // Except the current logged user
        let id = UserDefaults.standard.value(forKey: "currentUser") as? String ?? ""
        
        db.collection(collection).whereField("receiver", isEqualTo: id)
            .addSnapshotListener { [self] (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                    print("No documents")
                    return
                }
                
                for doc in documents {
                    let data = doc.data()
                    let match = Match(id: doc.documentID,
                                      sender: data["sender"] as! String,
                                      receiver: data["receiver"] as! String,
                                      accept: (data["accept"] != nil))
                    matches.append(match)
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
                
                let temp: [Match] = matches.reversed()
                self.matches = temp
            }
    }
    func createMatch(matchID: String, _ match: Match) {
        do {
            try db.collection(collection).document(matchID).setData(from: match)
        } catch let error {
            print("Error adding User to Firestore: \(error.localizedDescription).")
        }
    }
    
    func updateMatch(_ match: Match) {
        guard let matchID = match.id else { return }
        
        do {
            try db.collection(collection).document(matchID).setData(from: match)
        } catch let error {
            print("Error updating Match to Firestore: \(error.localizedDescription).")
        }
    }
    
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
