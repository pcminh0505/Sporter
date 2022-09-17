//
//  FriendListViewModel.swift
//  Sporter
//
//  Created by Minh Pham on 17/09/2022.
//

import Foundation
import Combine

enum SortOption: String, Codable, CaseIterable {
    case name = "Name (A-Z)"
    case nameReversed = "Name (Z-A)"
    case age = "Age (Ascending)"
    case ageReversed = "Age (Descending)"
}

class FriendListViewModel: ObservableObject, Identifiable {
    private let userRepository = UserRepository()

    @Published var friendList = [User]()
    @Published var searchText: String = ""
    @Published var sortOption: SortOption = .name
    @Published var isLoading: Bool = false

    private var cancellables: Set<AnyCancellable> = []

    init () {
        addSubcriber()
    }

    func addSubcriber() {
        // Update coinList
        $searchText
            .combineLatest(userRepository.$friends, $sortOption)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterAndSort)
            .sink { [weak self] (returnedData) in
            self?.friendList = returnedData
            self?.isLoading = false
        }
            .store(in: &cancellables)
    }

    private func filterByText(text: String, users: [User]) -> [User] {
        guard !text.isEmpty else {
            return users
        }

        let lowercasedText = text.lowercased()

        return users.filter { (user) -> Bool in
            return user.fname.lowercased().contains(lowercasedText) ||
                user.lname.lowercased().contains(lowercasedText)
        }
    }

    // Inout : Return the same input to the output -> Work like Pointer
    private func sortFriendList(sort: SortOption, users: inout [User]) {
        switch sort {
        case .name:
            users.sort(by: { $0.fname > $1.fname })
        case .nameReversed:
            users.sort(by: { $0.fname < $1.fname })
        case .age:
            users.sort(by: { ConversionHelper.getAge($0.bod) < ConversionHelper.getAge($1.bod) })
        case .ageReversed:
            users.sort(by: { ConversionHelper.getAge($0.bod) > ConversionHelper.getAge($1.bod) })
        }
    }

    private func filterAndSort(text: String, users: [User], sort: SortOption) -> [User] {
        var updatedFriendList = filterByText(text: text, users: users)
        // Sort
        sortFriendList(sort: sort, users: &updatedFriendList)
        return updatedFriendList
    }
}
