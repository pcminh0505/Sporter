//
//  HomeViewModel.swift
//  TinderUI
//
//  Created by Long Tran on 04/09/2022.
//

import Foundation

class CardViewModel: ObservableObject {
    @Published var fetched_users: [CardUser] = []
    
    @Published var displaying_users: [CardUser]?
    
    init (){
        fetched_users = [
            CardUser(name:"Nam", place: "D1 HCM", profilePic: "User1"),
            CardUser(name:"Minh", place: "D1 HCM", profilePic: "User2"),
            CardUser(name:"Ngan", place: "D.Hoan Kiem Hanoi", profilePic: "User3")
//            User(name:"Tu", place: "D10 Da Nang", profilePic: "User4"),
//            User(name:"Thinh", place: "D1 Bien Hoa", profilePic: "User5")
        ]
        
        displaying_users = fetched_users
    }
    
    func getIndex(user: CardUser) -> Int {
        let index = displaying_users?.firstIndex(where: { currentUser in
            return user.id == currentUser.id
        }) ?? 0
        
        return index
    }
}
