//
//  APIClient.swift
//
//  Created by Andy Rennard on 27/07/2023.
//

import Foundation

public enum HTTPMethod: String {
    case `get` = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

enum APIError: Error, LocalizedError {
    case notImplemented
    case invalidURL
    case invalidResponse
    case responseError(Error)
    case decodingError(Error)
    case encodingError(Error)
    case genericError(Error)
}

extension URLRequest {
    mutating func setStandardHeaders(withAPIToken token: String) {
        self.setValue("application/json", forHTTPHeaderField: "Accept")
    }
}

public protocol APIClientProtocol {
    /// Perform a `GET` request
    /// - Parameters:
    ///   - url: the URL to request
    /// - Returns: The decoded response type
    func get<T: Decodable>(url: URL) async throws -> T
    
    // NOT IMPLEMENTED: methods for POST, PUT, PATCH, DELETE
}

/// An API Client for the Starling API
public class APIClient: APIClientProtocol {
    public init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    private let apiKey: String
    
    /// Perform a request with an encodable body type
    /// - Parameters:
    ///   - url: the URL to request
    ///   - method: the HTTP method to use
    ///   - body: an encodable type to set as the request body
    /// - Returns: The decoded response type
    private func request<T: Decodable, U: Encodable>(url: URL, method: HTTPMethod, with body: U? = nil) async throws -> T {
        var request = URLRequest(url: url.appending(queryItems: [URLQueryItem(name: "apikey", value: apiKey)]))

        do {
            request.httpBody = try body.encode()
        } catch let error as EncodingError {
            throw APIError.encodingError(error)
        } catch {
            throw APIError.genericError(error)
        }
        request.httpMethod = method.rawValue
        return try await perform(request)
    }
    
    /// Perform a request that does not contain a http body
    /// - Parameters:
    ///   - url: the URL to request
    ///   - method: the HTTP method to use
    /// - Returns: The decoded response type
    private func request<T: Decodable>(url: URL, method: HTTPMethod, additionalHeaders: [String: String]? = nil) async throws -> T {
        var request = URLRequest(url: url.appending(queryItems: [URLQueryItem(name: "apikey", value: apiKey)]))
        request.httpMethod = method.rawValue
        return try await perform(request)
    }
    
    /// The main request handler function - all other functions call into this to actually perform the request
    /// - Parameters:
    ///   - request: the `URLRequest` to perform
    /// - Returns: The decoded response type
    private func perform<T: Decodable>(_ request: URLRequest) async throws -> T {
    
        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
                200...299 ~= httpResponse.statusCode
        else {
            //TODO: Parse an API error response
            throw APIError.invalidResponse
        }
        
        do {
            return try T.decode(from: data)
        } catch {
            throw APIError.decodingError(error)
        }
    }
    
    public func get<T: Decodable>(url: URL) async throws -> T {
        try await request(url: url, method: .get)
    }
}
