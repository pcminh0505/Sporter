//
//  HomeViewModel.swift
//  TinderUI
//
//  Created by Long Tran on 04/09/2022.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject, Identifiable {
    private let userRepository = UserRepository()
    let id = UserDefaults.standard.value(forKey: "currentUser") as? String ?? ""
    
    @Published var currentUser: User? = nil
    @Published var displayingUsers: [User] = []
    private var cancellables: Set<AnyCancellable> = []

    init () {
        userRepository.$users
            .assign(to: \.displayingUsers, on: self)
            .store(in: &cancellables)
        
        userRepository.$currentUser
            .assign(to: \.currentUser, on: self)
            .store(in: &cancellables)
        
        //            .sink { [weak self] (returnedUsers) in
        //            self?.displayingUsers = returnedUsers
        //        }
    }

    func getIndex(user: User) -> Int {
        let index = displayingUsers.firstIndex(where: { currentUser in
            return user.id == currentUser.id
        }) ?? 0

        return index
    }
}
