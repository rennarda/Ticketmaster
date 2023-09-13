//
//  TicketmasterTests.swift
//  TicketmasterTests
//
//  Created by Andrew Rennard on 11/09/2023.
//

import XCTest
@testable import Ticketmaster
import TicketmasterClient
import APIClient
import SwiftData

@MainActor
final class EventListViewModelTests: XCTestCase {
    var sut: EventListViewModel!
    var client: MockTicketmasterClient!
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Event.self, EventImage.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    override func setUpWithError() throws  {
        client = MockTicketmasterClient()
        sut = EventListViewModel(context: sharedModelContainer.mainContext, client: client)
    }
 
    func test_getEvents() async {
        await sut.getEvents(keyword: "testing")
        do {
            let events: [Event] = try sharedModelContainer.mainContext.fetch(FetchDescriptor())
            XCTAssertEqual(events.count, 2)
        } catch {
            XCTFail()
        }
    }
    
    func test_getEventsThrows() async {
        client.error = APIError.invalidResponse
        await sut.getEvents(keyword: "test")
        XCTAssertNotNil(sut.error)
        XCTAssertTrue(sut.showError)
    }
}
