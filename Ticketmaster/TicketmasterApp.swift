//
//  TicketmasterApp.swift
//  Ticketmaster
//
//  Created by Andrew Rennard on 11/09/2023.
//

import SwiftUI
import TicketmasterClient

@main
struct TicketmasterApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                EventList(viewModel: EventListViewModel())
            }
        }
    }
}
