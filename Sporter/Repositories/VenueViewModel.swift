//
//  VenueViewModel.swift
//  Sporter
//
//  Created by Khang on 03/09/2022.
//

import Foundation
import Combine

class VenueViewModel : ObservableObject, Identifiable {
    @Published var venueRepository =  VenueRepository()
    @Published var venues: [Venue] = []
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        venueRepository.$venues
            .assign(to: \.venues, on: self)
            .store(in: &cancellables)
    }
}
