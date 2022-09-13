//
//  VenueDetailViewModel.swift
//  Sporter
//
//  Created by Khang on 13/09/2022.
//

import Foundation
import Combine
import SwiftUI

class VenueDetailViewModel : ObservableObject {
    var eventRepository = EventRespository()
    
    @Published var venue: Venue
    @Published var events: [EventData] = []
    @Published var cancellables: Set<AnyCancellable> = []
    @Published var didJoinEvent: [String : Bool] = [:]
    
    var id: Int = 0
    
    init(venue: Venue) {
        self.venue = venue
        
        $venue
          .compactMap { $0.id }
          .assign(to: \.id, on: self)
          .store(in: &cancellables)

        self.eventRepository.$eventsByVenue
            .assign(to: \.events, on: self)
            .store(in: &cancellables)
        
        self.eventRepository.$eventsByVenue
            .map{ venues in
                let id = UserDefaults.standard.value(forKey: "currentUser") as? String ?? ""
                
                return venues.reduce([String: Bool]()) { (dict, eventData) -> [String: Bool] in
                    var dict = dict
                    
                    if let eventID = eventData.event.id {
                        dict[eventID] = eventData.event.participants.contains(id)
                    }
                   
                    return dict
                }
                
            }
            .assign(to: \.didJoinEvent, on: self)
            .store(in: &cancellables)

        self.eventRepository.getEventsByVenue(id)
    }
    
    func joinEvent(_ eventID: String) {
        let id = UserDefaults.standard.value(forKey: "currentUser") as? String ?? ""
        
        // Prevent crash
        if !id.isBlank {
            if var eventData = events.first(where: {$0.event.id == eventID}) {
                eventData.event.participants.append(id)
                eventRepository.updateEvent(eventData.event)
                self.didJoinEvent[eventID] = true
            }
        }
    }
}
