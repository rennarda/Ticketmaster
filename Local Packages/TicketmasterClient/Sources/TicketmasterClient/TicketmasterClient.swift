// The Swift Programming Language
// https://docs.swift.org/swift-book
import APIClient
import Foundation

/// A type that communicates with the Ticketmaster API
public protocol TicketmasterClientProtocol {
    /// Get all matching events from the API
    /// - Parameter keyword: the keyword to search for
    /// - Returns: an array of `Event`s
    func getEvents(keyword: String) async throws -> [Event]
}

/// An implementation of `TicketMasterClientProtocol`
public struct TicketmasterClient: TicketmasterClientProtocol {
    private static let defaultBaseURL = URL(string: "https://app.ticketmaster.com/discovery/v2/")!
    
    private let apiClient: APIClientProtocol
    private let baseURL: URL
    
    /// Create a `TicketmasterClient`
    /// - Parameters:
    ///   - apiKey: the API key to use for all API requests
    ///   - baseURL: the base URL to use for all API requests
    ///   - apiClient: an API client to use - if not provided, one will be created with the supplied API key
    public init(apiKey: String, baseURL: URL? = nil, apiClient: APIClientProtocol? = nil) {
        self.apiClient = apiClient ?? APIClient(apiKey: apiKey)
        self.baseURL = baseURL ?? Self.defaultBaseURL
    }
    
    public func getEvents(keyword: String) async throws -> [Event] {
        let url = baseURL
            .appending(path: "events.json")
            .appending(queryItems: [URLQueryItem(name: "keyword", value: keyword)])

        let response: EventResponse = try await apiClient.get(url: url)
        return response.events
    }
}
