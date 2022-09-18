/*
    RMIT University Vietnam
    Course: COSC2659 iOS Development
    Semester: 2022B
    Assessment: Assignment 3
    Author: Minh Pham
    ID: s3818102
    Created date: 12/09/2022
    Last modified: 18/09/2022
*/

import SwiftUI
import FirebaseStorage
import Firebase

public class StorageManager: ObservableObject {
    private let storage = Storage.storage()
    private let root: String = "images"

    private let db = Firestore.firestore()
    private let collection: String = "users"

    private let DEFAULT_PROFILE_IMG_URL = "https://t4.ftcdn.net/jpg/00/64/67/63/360_F_64676383_LdbmhiNM6Ypzb3FM4PPuFP9rHe7ri8Ju.jpg"

    @Published var results = [String: String]()
    @Published var isDoingTask: Bool = false

    init() {
        let id = UserDefaults.standard.value(forKey: "currentUser") as? String ?? ""
        listItem(id)
    }

    // Upload image to Firebase Storage
    func upload(id: String, image: UIImage) {
        self.isDoingTask = true
        // Create a storage reference
        let imgPath = "\(self.root)/\(id).jpg"
        let storageRef = storage.reference().child(imgPath)

        // Convert the image into JPEG and compress the quality to reduce its size
        let data = image.jpegData(compressionQuality: 0.5)

        guard data != nil else { return }

        // Change the content type to jpg. If you don't, it'll be saved as application/octet-stream type
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"

        // Upload the image
        if let data = data {
            storageRef.putData(data, metadata: metadata) { (metadata, error) in
                if let error = error {
                    print("Error while uploading file: ", error)
                }

                storageRef.downloadURL { url, err in
                    if let error = error {
                        print("Error while getting URL: ", error)
                    }

                    // Store in Firestore
                    let urlString = url?.absoluteString ?? self.DEFAULT_PROFILE_IMG_URL
                    self.db.collection(self.collection).document(id).updateData(["profileImage": urlString]) { err in
                        if let err = err {
                            print("Error updating document: \(err)")
                        } else {
                            print("Document successfully updated")
                        }
                    }
                }
            }
        }
        self.isDoingTask = false
    }

    // Get URL profileImage of an user
    func listItem(_ id: String) {
        self.isDoingTask = true
        // Create a reference
        let imgPath = "\(self.root)/\(id).jpg"
        let storageRef = storage.reference().child(imgPath)

        // Fetch the download URL
        storageRef.downloadURL { url, error in
            if let error = error {
                // Handle any errors
                print("Error getting Image: \(error.localizedDescription)")
                self.results[id] = self.DEFAULT_PROFILE_IMG_URL
            } else {
                // Get the download URL for profile image
                self.results[id] = url?.absoluteString
            }
        }
        self.isDoingTask = false
    }

    // Get all URLs of profileImage in the storage
    func listAllFiles() {
        // Create a reference
        let storageRef = storage.reference().child(self.root)

        // List all items in the images folder
        storageRef.listAll { (result, error) in
            if let error = error {
                print("Error while listing all files: ", error)
            }

            if let result = result {
                for item in result.items {
                    print("Item in images folder: ", item)
                }
            }
        }
    }
}
