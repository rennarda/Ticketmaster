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

final class EventListViewModelTests: XCTestCase {
    var sut: EventListViewModel!
    var client: MockTicketmasterClient!
    
    override func setUpWithError() throws  {
        client = MockTicketmasterClient()
        sut = EventListViewModel(client: client)
    }
 
    func test_getEvents() async {
        await sut.getEvents(keyword: "testing")
        XCTAssertEqual(sut.events.count, 2)
    }
    
    func test_getEventsThrows() async {
        client.error = APIError.invalidResponse
        await sut.getEvents(keyword: "test")
        XCTAssertNotNil(sut.error)
        XCTAssertTrue(sut.showError)
    }
}
