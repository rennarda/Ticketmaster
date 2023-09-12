//
//  EventResponseTests.swift
//  
//
//  Created by Andrew Rennard on 12/09/2023.
//

import XCTest
@testable import TicketmasterClient

final class EventResponseTests: XCTestCase {
    func testDecoding() throws {
        let response = try loadJSON(from: "sampleEvents", as: EventResponse.self)
        
        XCTAssertEqual(response.events.count, 20)
        XCTAssertEqual(response.events[0].name, "Tool")
        XCTAssertEqual(response.events[0].id, "G5vzZ9ikhiw4K")
        XCTAssertEqual(response.events[0].images.count, 10)
        
        let image = response.events[0].images[0]
        XCTAssertEqual(image.height, 427)
        XCTAssertEqual(image.width, 640)
        XCTAssertEqual(image.url.absoluteString, "https://s1.ticketm.net/dam/a/d1d/9ff2c038-6ae7-4aca-a97f-4f472d92ed1d_1517601_RETINA_PORTRAIT_3_2.jpg")
    }
}
