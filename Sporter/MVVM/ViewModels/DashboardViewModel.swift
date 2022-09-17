//
//  DashboardViewModel.swift
//  Sporter
//
//  Created by Khang on 15/09/2022.
//

import Foundation
import SwiftUI
import Combine

class DashboardViewModel: ObservableObject {
    @Published var eventRepository = EventRespository()
    @Published var events: [EventData] = []
    @Published var isEventCreator: [String: Bool] = [:]
    @Published var cancellables: Set<AnyCancellable> = []

    init() {
        // Get events that current user attends, save to events
        self.eventRepository.$eventsByUser
            .assign(to: \.events, on: self)
            .store(in: &cancellables)
        // Map events to dictionary array, showing if current user is the creator of each event
        self.eventRepository.$eventsByUser
            .map { events in
            let id = UserDefaults.standard.value(forKey: "currentUser") as? String ?? ""

            return events.reduce([String: Bool]()) { (dict, eventData) -> [String: Bool] in
                var dict = dict

                if let eventID = eventData.event.id {
                    dict[eventID] = eventData.event.creator == id ? true : false
                }

                return dict
            }

        }
            .assign(to: \.isEventCreator, on: self)
            .store(in: &cancellables)
        // Call function from event repo
        self.eventRepository.getEventsByCurrentUser()
    }
    
    // Delete an event
    func deleteEvent(_ eventID: String) {
        // update on cloud
        if let eventData = events.first(where: { $0.event.id == eventID }) {
            eventRepository.deleteEvent(eventData.event)
        }
    }

    // Leave an event
    func leaveEvent(_ eventID: String) {
        // update on cloud
        let id = UserDefaults.standard.value(forKey: "currentUser") as? String ?? ""

        // Prevent crash
        if !id.isBlank {
            if var eventData = events.first(where: { $0.event.id == eventID }) {
                eventData.event.participants.removeAll(where: { $0 == id })
                eventRepository.updateEvent(eventData.event, isWithdraw: true)
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
