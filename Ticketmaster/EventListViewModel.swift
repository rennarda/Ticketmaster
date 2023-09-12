//
//  EventListViewModel.swift
//  Ticketmaster
//
//  Created by Andrew Rennard on 12/09/2023.
//

import Foundation
import TicketmasterClient
import Observation
import SwiftData

@Observable
public final class EventListViewModel {
    var context: ModelContext
    var client: TicketmasterClientProtocol
    var searching = false
    var error: Error?
    var showError = false
    
    /// In practice this could come from a build environment value, or from a configuration setting
    static let apiKey = "DW0E98NrxUIfDDtNN7ijruVSm60ryFLX"
    
    public init(context: ModelContext, client: TicketmasterClientProtocol? = nil) {
        self.context = context
        self.client = client ?? TicketmasterClient(apiKey: Self.apiKey)
    }
    
    func getEvents(keyword: String) async {
        guard !searching else { return }
        searching = true
        defer { searching = false }
        do {
            try context.delete(model: Event.self)
            let events = try await client.getEvents(keyword: keyword)
            for event in events {
                context.insert(event)
            }
        } catch {
            // Publish the error to the UI layer
            // in practice, we might want to create a different error, or filter out certain errors
            self.error = error
            showError = true
        }
    }
}
