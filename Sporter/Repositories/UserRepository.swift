//
//  UserRepository.swift
//  Sporter
//
//  Created by Minh Pham on 30/08/2022.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class UserRepository: ObservableObject {
    private let db = Firestore.firestore()
    private let collection: String = "users"

    @Published var currentUser: User = User.unset

    init() {
        getCurrentUser()
    }

    func getCurrentUser() {
//        let user = Auth.auth().currentUser
        // Mock
        let docRef = db.collection(collection).document("10dCqdT3pCeBRuVt07STOrPghEx2")

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
                
            } else {
                print("Document does not exist")
            }
        }
    }

    func getAllUsers() {
        print("GetAllUser")
    }

    func createUser(_ user: User) {
        do {
            try db.collection(collection).document(user.id).setData(user.dictionary)
        } catch let error {
            print("Error adding User to Firestore: \(error.localizedDescription).")
        }
    }

    func updateUser() {
        print("UpdateUser")
    }

    func swipeUser() {
        print("SwipeUser")
    }

    func unmatchUser() {
        print("UnmatchUser")
    }
}
