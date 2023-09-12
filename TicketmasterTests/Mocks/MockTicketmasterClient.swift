//
//  MockTicketmasterClient.swift
//  TicketmasterTests
//
//  Created by Andrew Rennard on 12/09/2023.
//

import Foundation
import TicketmasterClient
import SwiftData

class MockTicketmasterClient: TicketmasterClientProtocol {
    var error: Error?
    func getEvents(keyword: String) async throws -> [Event] {
        if let error {
            throw error
        } else {
            return []
        }
    }
}

// How to create this mock data - causes a compiler error? 
//extension Event {
//    static var mocks: [Event] {
//        [
//            Event(id: "123", name: "Test event 1", date: .now,
//               images: [EventImage(width: 100, height: 200, url: URL(string: "https://test.image/1")!)]),
//            Event(id: "456", name: "Test event 2", date: .now,
//               images: [EventImage(width: 100, height: 200, url: URL(string: "https://test.image/2")!)])
//        ]
//    }
//}
