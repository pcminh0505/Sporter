/*
    RMIT University Vietnam
    Course: COSC2659 iOS Development
    Semester: 2022B
    Assessment: Assignment 3
    Author: Long Tran
    ID: s3755615
    Created date: 04/09/2022
    Last modified: 18/09/2022
*/

import Foundation
import Combine

class DiscoveryViewModel: ObservableObject, Identifiable {
    private let userRepo = UserRepository()
    private let matchRepo = MatchRepository()
    
    @Published var displayingUsers: [User] = []
    private var cancellables: Set<AnyCancellable> = []

    init () {
        userRepo.$usersWithoutMatch
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
        matchRepo.createMatch(matchID: id, Match(id: id, sender: user_id, receiver: receiver, accept: false))
    }
}
