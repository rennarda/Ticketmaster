//
//  EventResponse.swift
//
//
//  Created by Andrew Rennard on 11/09/2023.
//

import Foundation
public struct EventResponse: Decodable {
    public let events: [Event]
    
    private enum CodingKeys: String, CodingKey {
        case embedded = "_embedded"
        case events = "events"
    }
    
    init(events: [Event]) {
        self.events = events
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let embeddedContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .embedded)
        self.events = try embeddedContainer.decode([Event].self, forKey: .events)
    }
}
