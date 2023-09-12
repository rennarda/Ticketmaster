//
//  TicketmasterApp.swift
//  Ticketmaster
//
//  Created by Andrew Rennard on 11/09/2023.
//

import SwiftUI
import TicketmasterClient
import SwiftData

@main
struct TicketmasterApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Event.self, EventImage.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                EventList(viewModel: EventListViewModel(context: sharedModelContainer.mainContext))
            }
            .modelContainer(sharedModelContainer)
            .networkAlert()
        }
    }
}
