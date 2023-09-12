//
//  Decodable+extensions.swift
//  Starling Round Up
//
//  Created by Andy Rennard on 27/07/2023.
//

import Foundation

extension Decodable {
    /// Convenience function to decode a decodable type
    /// - Parameter data: the encoded data to decode
    /// - Returns: the decoded type
    public static func decode(from data: Data) throws -> Self {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(Self.self, from: data)
    }
}

extension Encodable {
    /// Convenience function to encode an encodable type
    /// - Parameter data: the encoded data to encode
    /// - Returns: the decoded type
    public func encode() throws -> Data {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        return try encoder.encode(self)
    }
}
