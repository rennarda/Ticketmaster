//
//  Item.swift
//  Ticketmaster
//
//  Created by Andrew Rennard on 11/09/2023.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
