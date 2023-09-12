//
//  EventListViewModel.swift
//  Ticketmaster
//
//  Created by Andrew Rennard on 12/09/2023.
//

import Foundation
import TicketmasterClient
import SwiftUI
import Observation

@Observable
public final class EventListViewModel {
    var client = TicketmasterClient(apiKey: "DW0E98NrxUIfDDtNN7ijruVSm60ryFLX")
    var events: [Event] = []
    var searching = false
    var error: Error?
    var showError = false
    
    func getEvents(keyword: String) async {
        guard !searching else { return }
        searching = true
        defer { searching = false }
        do {
            events = try await client.getEvents(keyword: keyword)
        } catch {
            // Publish the error to the UI layer
            // in practice, we might want to create a different error, or filter out certain errors
            self.error = error
            showError = true
        }
    }
}
