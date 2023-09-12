//
//  MockAPIClient.swift
//
//
//  Created by Andrew Rennard on 12/09/2023.
//

import Foundation
import APIClient

class MockAPIClient: APIClientProtocol {
    var requestURL: URL?
    var response: Data!
    
    func get<T>(url: URL) async throws -> T where T : Decodable {
        requestURL = url
        return try JSONDecoder().decode(T.self, from: response)
    }
}
