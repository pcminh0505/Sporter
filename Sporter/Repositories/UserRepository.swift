/*
    RMIT University Vietnam
    Course: COSC2659 iOS Development
    Semester: 2022B
    Assessment: Assignment 3
    Author: Minh Pham
    ID: s3818102
    Created date: 30/08/2022
    Last modified: 18/09/2022
*/

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class UserRepository: ObservableObject {
    private let db = Firestore.firestore()
    private let collection: String = "users"
    @Published var currentUser: User? = nil
    @Published var usersWithoutMatch: [User] = []
    @Published var users: [User] = []
    @Published var matchingUsers: [User] = []
    @Published var friends: [User] = []
    private var matchs: [String] = []

    init() {
        getCurrentUser()
        getAllUsers()
        getFilteredSend()
        getFilteredReceive()
        getFilteredUser()
    }

    // Get current user information
    func getCurrentUser() {
        let id = UserDefaults.standard.value(forKey: "currentUser") as? String ?? ""

        // Prevent crash
        if !id.isBlank {
            db.collection(collection).document(id)
                .addSnapshotListener { doc, err in

                if let doc = doc {
                    do {
                        let data = try doc.data(as: User.self)
                        self.currentUser = data

                        // Pre-load Friends
                        self.getAllFriends(data.friends)
                    } catch let err {
                        print("Error fetching data: \(err)")
                    }

                }
            }
        }
    }

    // Get filtered user for matching features
    func getFilteredUser() {
        let id = UserDefaults.standard.value(forKey: "currentUser") as? String ?? ""

        db.collection(collection)
            .addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }

            self.usersWithoutMatch = documents.compactMap { doc -> User? in
                let friendList: [String] = self.currentUser?.friends ?? []
                let senderList: [String] = self.matchs
                // Except the current logged user
                if doc.documentID == id {
                    return nil
                }

                if friendList.contains(doc.documentID) {
                    return nil
                }

                if senderList.contains(doc.documentID) {
                    return nil
                }

                return try? doc.data(as: User.self)
            }

            self.usersWithoutMatch = documents.compactMap { doc -> User? in
                let friendList: [String] = self.currentUser?.friends ?? []
                let senderList: [String] = self.matchs
                
                // Except the current logged user
                if doc.documentID == id {
                    return nil
                }

                if friendList.contains(doc.documentID) {
                    return nil
                }

                if senderList.contains(doc.documentID) {
                    return nil
                }

                return try? doc.data(as: User.self)
            }
        }
    }

    // Listen to all sent request of current user
    func getFilteredSend() {
        let id = UserDefaults.standard.value(forKey: "currentUser") as? String ?? ""

        // Get all relevant matches to user id
        db.collection("match")
            .whereField("sender", isEqualTo: id)
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

                matchs.append(match.sender)
                if (match.sender == id) {
                    matchs.append(match.receiver)
                }
            }
        }
    }

    // Listen to all received request of current user
    func getFilteredReceive() {
        // Except the current logged user
        let id = UserDefaults.standard.value(forKey: "currentUser") as? String ?? ""

        // Get all relevant matches to user id
        db.collection("match")
            .whereField("receiver", isEqualTo: id)
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

                matchs.append(match.sender)
                if (match.receiver == id) {
                    matchs.append(match.sender)
                }
            }
        }
    }

    // Get all user in the collection
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

    // Create new user
    func createUser(userID: String, _ user: User) {
        do {
            try db.collection(collection).document(userID).setData(from: user)
        } catch let error {
            print("Error adding User to Firestore: \(error.localizedDescription).")
        }
    }

    // Update user information
    func updateUser(_ user: User) {
        guard let userID = user.id else { return }
        do {
            try db.collection(collection).document(userID).setData(from: user)
            print("Update user successfully")
        } catch let error {
            print("Error adding User to Firestore: \(error.localizedDescription).")
        }
    }

    // Get user for friend request
    func getListOfUserBaseOnMatch(matchList: [Match]) -> [User] {
        // Prevent crash
        if !matchList.isEmpty {
            matchList.forEach { match in
                let docRef = db.collection(collection).document(match.sender)
                docRef.getDocument(as: User.self) { result in
                    switch result {
                    case .success(let user):
                        self.matchingUsers.append(user)
                    case .failure(let error):
                        // A User value could not be initialized from the DocumentSnapshot.
                        print("Error decoding document: \(error.localizedDescription)")
                    }
                }
            }
        }
        return matchingUsers
    }

    // Get all friends' information
    func getAllFriends(_ friendList: [String]) {
        db.collection(collection)
            .addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }

            self.friends = documents.compactMap { doc -> User? in
                // Exclude non-friend users
                if !friendList.contains(doc.documentID) {
                    return nil
                }

                return try? doc.data(as: User.self)
            }
        }
    }
}
