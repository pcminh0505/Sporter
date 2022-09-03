//
//  UserRepository.swift
//  Sporter
//
//  Created by Minh Pham on 30/08/2022.
//

import Foundation
import Firebase

class UserRepository: ObservableObject {
    private let db = Firestore.firestore()
    private let collection: String = "users"

    func getUser() {
        print("GetUser")
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
