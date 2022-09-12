//
//  DiscoveryViewModel.swift
//  TinderUI
//
//  Created by Long Tran on 04/09/2022.
//

import Foundation
import Combine

class DiscoveryViewModel: ObservableObject, Identifiable {
    private let userRepo = UserRepository()
    private let matchRepo = MatchRepository()
    
    @Published var displayingUsers: [User] = []
    private var cancellables: Set<AnyCancellable> = []

    init () {
        userRepo.$users
            .assign(to: \.displayingUsers, on: self)
            .store(in: &cancellables)
    }

    func getIndex(user: User) -> Int {
        let index = displayingUsers.firstIndex(where: { currentUser in
            return user.id == currentUser.id
        }) ?? 0

        return index
    }
    
    func createMatch(receiver: String) {
        let id = UUID().uuidString
        let user_id = UserDefaults.standard.value(forKey: "currentUser") as? String ?? ""
        matchRepo.createMatch(matchID: id, Match(id: id, sender: receiver, receiver: user_id, accept: false))
    }
}