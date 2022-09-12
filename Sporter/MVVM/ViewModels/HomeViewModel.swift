//
//  HomeViewModel.swift
//  Sporter
//
//  Created by Minh Pham on 11/09/2022.
//


import Foundation
import Combine

class HomeViewModel: ObservableObject, Identifiable {
    private let userRepository = UserRepository()
    private let matchRepository = MatchRepository()

    @Published var currentUser: User? = nil
    
    private var cancellables: Set<AnyCancellable> = []

    init () {
        userRepository.$currentUser
            .sink(receiveValue: { user in
                self.currentUser = user
            })
            .store(in: &cancellables)
    }
}
