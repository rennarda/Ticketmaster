//
//  JSONLoader.swift
//
//
//  Created by Andrew Rennard on 08/09/2023.
//

import Foundation
import XCTest

enum JSONLoaderError: Error {
    case fileNotFound
    case unableToReadData
    case unableToDecodeJSON
}

func loadJSON<T: Decodable>(from fileName: String, as type: T.Type) throws -> T {
    // Get the path to the JSON file in the test bundle
    guard let jsonFilePath = Bundle.module.path(forResource: fileName, ofType: "json") else {
        throw JSONLoaderError.fileNotFound
    }

    // Load the data from the JSON file
    guard let jsonData = FileManager.default.contents(atPath: jsonFilePath) else {
        throw JSONLoaderError.unableToReadData
    }

    // Decode the JSON data into the specified type
    do {
        let decodedObject = try T.decode(from: jsonData)
        return decodedObject
    } catch let DecodingError.dataCorrupted(context) {
        XCTFail(context.debugDescription)
        throw JSONLoaderError.unableToDecodeJSON
    } catch let DecodingError.keyNotFound(key, context) {
        XCTFail("Value '\(key)' not found: \(context.debugDescription), codingPath: \(context.codingPath)")
        throw JSONLoaderError.unableToDecodeJSON
    } catch let DecodingError.valueNotFound(value, context) {
        XCTFail("Value '\(value)' not found: \(context.debugDescription), codingPath: \(context.codingPath)")
        throw JSONLoaderError.unableToDecodeJSON
    } catch let DecodingError.typeMismatch(type, context)  {
        XCTFail("Value '\(type)' not found: \(context.debugDescription), codingPath: \(context.codingPath)")
        throw JSONLoaderError.unableToDecodeJSON
    } catch {
        throw JSONLoaderError.unableToDecodeJSON
    }
}
