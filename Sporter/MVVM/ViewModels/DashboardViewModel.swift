//
//  DashboardViewModel.swift
//  Sporter
//
//  Created by Khang on 15/09/2022.
//

import Foundation
import SwiftUI
import Combine

class DashboardViewModel : ObservableObject {
    @Published var eventRepository = EventRespository()
    @Published var events: [EventData] = []
    @Published var isEventCreator: [String : Bool] = [:]
    @Published var cancellables: Set<AnyCancellable> = []
    
    init() {
        self.eventRepository.$eventsByUser
            .assign(to: \.events, on: self)
            .store(in: &cancellables)
        
        self.eventRepository.$eventsByUser
            .map{ events in
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

        self.eventRepository.getEventsByCurrentUser()
    }
    
    func deleteEvent(_ eventID: String) {
        // update on cloud
        if let eventData = events.first(where: {$0.event.id == eventID}) {
            eventRepository.deleteEvent(eventData.event)
        }
    }
    
    func withdrawEvent(_ eventID: String) {
        // update on cloud
        let id = UserDefaults.standard.value(forKey: "currentUser") as? String ?? ""
        
        // Prevent crash
        if !id.isBlank {
            if var eventData = events.first(where: {$0.event.id == eventID}) {
                eventData.event.participants.removeAll(where: {$0 == id})
                eventRepository.updateEvent(eventData.event, isWithdraw: true)
            }
        }
    }
}
