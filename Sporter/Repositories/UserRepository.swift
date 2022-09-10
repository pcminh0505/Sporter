//
//  UserRepository.swift
//  Sporter
//
//  Created by Minh Pham on 30/08/2022.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class UserRepository: ObservableObject {
    private let db = Firestore.firestore()
    private let collection: String = "users"

    @Published var currentUser: User? = nil
    @Published var users: [User] = []

    init() {
        getCurrentUser()
        getAllUsers()
    }

    func getCurrentUser() {
        let id = UserDefaults.standard.value(forKey: "currentUser") as? String ?? ""

        // Prevent crash
        if !id.isBlank {
            let docRef = db.collection(collection).document(id)

            docRef.getDocument(as: User.self) { result in
                switch result {
                case .success(let user):
                    self.currentUser = user
                case .failure(let error):
                    // A User value could not be initialized from the DocumentSnapshot.
                    print("Error decoding document: \(error.localizedDescription)")
                }
            }
        }
    }

    func getAllUsers() {
        // Except the current logged user
        let id = UserDefaults.standard.value(forKey: "currentUser") as? String ?? ""
        
        db.collection(collection)
            .addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }

            self.users = documents.compactMap { doc -> User? in
                // Except the current logged user
                if doc.documentID == id {
                    return nil
                }
                
                return try? doc.data(as: User.self)
            }
        }
    }

    func createUser(userID: String, _ user: User) {
        do {
            try db.collection(collection).document(userID).setData(from: user)
        } catch let error {
            print("Error adding User to Firestore: \(error.localizedDescription).")
        }
    }

    func updateUser(_ user: User) {
        guard let userID = user.id else { return }

        do {
            try db.collection(collection).document(userID).setData(from: user)
        } catch let error {
            print("Error adding User to Firestore: \(error.localizedDescription).")
        }
    }
}
