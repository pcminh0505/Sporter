/*
    RMIT University Vietnam
    Course: COSC2659 iOS Development
    Semester: 2022B
    Assessment: Assignment 3
    Author: Khang Nguyen
    ID: s3817970
    Created date: 13/09/2022
    Last modified: 18/09/2022
*/

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
        // Get venue
        $venue
          .compactMap { $0.id }
          .assign(to: \.id, on: self)
          .store(in: &cancellables)
        // Get events in selected venue, save to events
        self.eventRepository.$eventsByVenue
            .assign(to: \.events, on: self)
            .store(in: &cancellables)
        // Map events to dictionary array, showing if current user has joined each event
        self.eventRepository.$eventsByVenue
            .map{ events in
                let id = UserDefaults.standard.value(forKey: "currentUser") as? String ?? ""
                
                return events.reduce([String: Bool]()) { (dict, eventData) -> [String: Bool] in
                    var dict = dict
                    
                    if let eventID = eventData.event.id {
                        dict[eventID] = eventData.event.participants.contains(id)
                    }
                   
                    return dict
                }
                
            }
            .assign(to: \.didJoinEvent, on: self)
            .store(in: &cancellables)
        // Call function from event repo
        self.eventRepository.getEventsByVenue(id)
    }
    
    // Join event
    func joinEvent(_ eventID: String) {
        let id = UserDefaults.standard.value(forKey: "currentUser") as? String ?? ""
        
        // Prevent crash
        if !id.isBlank {
            if var eventData = events.first(where: {$0.event.id == eventID}) {
                // Append user id to event participants
                // Update event on Firebase
                // Edit Bool value for event in didJoinEvent
                eventData.event.participants.append(id)
                eventRepository.updateEvent(eventData.event, isWithdraw: false)
                self.didJoinEvent[eventID] = true
            }
        }
    }
    
    // Convert timeinterval to NSDate
    func timeConversion(_ unixTime: Double) -> String {
        let date = NSDate(timeIntervalSince1970: TimeInterval(unixTime))
        let utcDateFormatter = DateFormatter()
        utcDateFormatter.dateStyle = .short
        utcDateFormatter.timeStyle = .short

        return utcDateFormatter.string(from: date as Date)
    }
}
