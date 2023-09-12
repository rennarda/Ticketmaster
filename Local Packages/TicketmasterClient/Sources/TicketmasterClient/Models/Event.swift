//
//  Event.swift
//
//
//  Created by Andrew Rennard on 11/09/2023.
//

import Foundation

public struct Event: Identifiable, Decodable {
    public let id: String
    public let name: String
    public let images: [EventImage]
}

public struct EventImage: Decodable {
    public let width: Int
    public let height: Int
    public let url: URL
}
