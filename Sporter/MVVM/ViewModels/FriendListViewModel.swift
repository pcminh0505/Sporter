//
//  FriendListViewModel.swift
//  Sporter
//
//  Created by Minh Pham on 17/09/2022.
//

import Foundation
import Combine

class FriendListViewModel: ObservableObject, Identifiable {
    private let userRepository = UserRepository()

    @Published var friendList = [User]()
    
    private var cancellables: Set<AnyCancellable> = []

    init () {
        userRepository.$friends
            .assign(to: \.friendList, on: self)
            .store(in: &cancellables)
    }
}
