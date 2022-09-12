//
//  DiscoveryViewModel.swift
//  TinderUI
//
//  Created by Long Tran on 04/09/2022.
//

import Foundation
import Combine

class DiscoveryViewModel: ObservableObject, Identifiable {
    private let userRepository = UserRepository()
    
    @Published var displayingUsers: [User] = []
    private var cancellables: Set<AnyCancellable> = []

    init () {
        userRepository.$users
            .assign(to: \.displayingUsers, on: self)
            .store(in: &cancellables)
    }

    func getIndex(user: User) -> Int {
        let index = displayingUsers.firstIndex(where: { currentUser in
            return user.id == currentUser.id
        }) ?? 0

        return index
    }
}
