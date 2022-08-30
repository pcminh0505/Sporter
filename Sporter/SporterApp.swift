//
//  SporterApp.swift
//  Sporter
//
//  Created by Minh Pham on 30/08/2022.
//

import SwiftUI

@main
struct SporterApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
