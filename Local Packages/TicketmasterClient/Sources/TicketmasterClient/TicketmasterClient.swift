// The Swift Programming Language
// https://docs.swift.org/swift-book
import APIClient
import Foundation

public protocol TicketmasterClientProtocol {
    func getEvents(keyword: String) async throws -> [Event]
}

public struct TicketmasterClient: TicketmasterClientProtocol {
    private static let defaultBaseURL = URL(string: "https://app.ticketmaster.com/discovery/v2/")!
    
    private let apiClient: APIClientProtocol
    private let baseURL: URL
    
    
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
