//
//  NotificationViewModel.swift
//  TinderUI
//
//  Created by Long Tran on 04/09/2022.
//

import Foundation
import Combine

class NotificationViewModel: ObservableObject, Identifiable {
    private let userRepository = UserRepository()
    private let matchRepository = MatchRepository()
    
    @Published var currentUserMatch: [User] = []
    @Published var currentUser: User? = nil
    @Published var matches: [Match] = []
    private var cancellables: Set<AnyCancellable> = []

    init () {
        userRepository.$currentUser
            .sink(receiveValue: { user in
                self.currentUser = user
            })
            .store(in: &cancellables)
        
        matchRepository.$matches
            .assign(to: \.matches, on: self)
            .store(in: &cancellables)
        
        matchRepository.$matchUsers
            .assign(to: \.currentUserMatch, on: self)
            .store(in: &cancellables)
    }
    
    func updateUser(_ user: User) {
        userRepository.updateUser(user)
    }
    
    func updateCurrentUser() {
        userRepository.updateUser(self.currentUser!)
    }
    
    func getIndex(user: User) -> Int {
        let index = currentUserMatch.firstIndex(where: { currentUser in
            return user.id == currentUser.id
        }) ?? 0

        return index
    }
    
    func deleteMatchRequest(match: Match) {
        matchRepository.deleteMatch(match)
    }
}
