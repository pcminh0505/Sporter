//
//  ProfileViewModel.swift
//  Sporter
//
//  Created by Minh Pham on 12/09/2022.
//


import Foundation
import Combine
import UIKit
import Firebase

class ProfileViewModel: ObservableObject, Identifiable {
    private let userRepository = UserRepository()
    private let storageManager = StorageManager()

    @Published var currentUser: User? = nil
    private var cancellables: Set<AnyCancellable> = []

    init () {
        userRepository.$currentUser
            .sink(receiveValue: { user in
                self.currentUser = user
            })
            .store(in: &cancellables)
    }

    func uploadImage(_ image: UIImage) {
        let id = UserDefaults.standard.value(forKey: "currentUser") as? String ?? ""
        storageManager.upload(id: id, image: image)
    }
    
    func updateUser() {
        userRepository.updateUser(self.currentUser!)
    }
    
    func logout() {
        try! Auth.auth().signOut()
        UserDefaults.standard.set("", forKey: "currentUser")
        UserDefaults.standard.set(false, forKey: "authStatus")
        NotificationCenter.default.post(name: NSNotification.Name("authStatus"), object: nil)
    }
}
