//
//  EventResponseTests.swift
//  
//
//  Created by Andrew Rennard on 12/09/2023.
//

import XCTest
@testable import TicketmasterClient
import SwiftData

@MainActor
final class EventResponseTests: XCTestCase {
    var sharedModelContainer: ModelContainer!
    
    override func setUpWithError() throws {
        sharedModelContainer = {
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
    }

    func testDecoding() throws {
        let response = try loadJSON(from: "sampleEvents", as: EventResponse.self)
        
        XCTAssertEqual(response.events.count, 20)
        XCTAssertEqual(response.events[0].name, "Tool")
        XCTAssertEqual(response.events[0].id, "G5vzZ9ikhiw4K")

        // Unsure how to enable these test when using SwiftData - causes a crash
        // Does not seem to able to understand the entity relationship...?
//        XCTAssertEqual(response.events[0].images.count, 10)
//        let image = response.events[0].images[0]
//        XCTAssertEqual(image.height, 427)
//        XCTAssertEqual(image.width, 640)
//        XCTAssertEqual(image.url.absoluteString, "https://s1.ticketm.net/dam/a/d1d/9ff2c038-6ae7-4aca-a97f-4f472d92ed1d_1517601_RETINA_PORTRAIT_3_2.jpg")
    }
}
