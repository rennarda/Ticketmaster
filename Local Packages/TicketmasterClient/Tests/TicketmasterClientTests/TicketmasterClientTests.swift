import XCTest
@testable import TicketmasterClient
import APIClient

final class TicketmasterClientTests: XCTestCase {
    var sut: TicketmasterClient!
    var apiClient: MockAPIClient!
    
    override func setUp() async throws {
        apiClient = MockAPIClient()
        sut = TicketmasterClient(apiKey: "ABC123", apiClient: apiClient)
    }
    
    /// This test validates that the TicketmasterClient is constructing the correct URL
    func test_get() async throws {
        apiClient.response = #"{"_embedded":{"events":[]}}"#.data(using: .utf8)
        _ = try await sut.getEvents(keyword: "testing")
        XCTAssertEqual(apiClient.requestURL?.absoluteString, "https://app.ticketmaster.com/discovery/v2/events.json?keyword=testing")
        
    }
}
