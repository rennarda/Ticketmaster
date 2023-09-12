//
//  Event.swift
//
//
//  Created by Andrew Rennard on 11/09/2023.
//

import Foundation

/// An event returned from the TicketMaster API
public struct Event: Identifiable, Decodable {
    public let id: String
    public let name: String
    public let images: [EventImage]
    public let date: Date?
    
    public var thumbnailImageURL: URL? {
        images
            .sorted(by: {$0.width > $1.width})
            .first(where: {$0.width < 500})?.url
    }
    
    public init(id: String, name: String, date: Date, images: [EventImage]) {
        self.id = id
        self.name = name
        self.date = date
        self.images = images
    }
    
    enum CodingKeys: CodingKey {
        case id
        case name
        case images
        case dates
        case start
        case dateTime
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.images = try container.decode([EventImage].self, forKey: .images)
        
        let datesContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .dates)
        let startContainer = try datesContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .start)
        self.date = try startContainer.decodeIfPresent(Date.self, forKey: .dateTime)
    }
}

/// An image for an `Event`
public final class EventImage: Decodable {
    public let width: Int
    public let height: Int
    public let url: URL
    
    public init(width: Int, height: Int, url: URL) {
        self.width = width
        self.height = height
        self.url = url
    }
}
