//
//  RequestsComponentsTests.swift
//  SRNetworkEngine
//
//  Created by Soham Ray on 13.01.25.
//

import XCTest

@testable import SRNetworkEngine

final class RequestsComponentsTests: XCTestCase {
    
    func test_valid_url_creation() throws {
        let mockComponents = MockRequestComponents.make()
        let request = try mockComponents.makeURLRequest()
        
        XCTAssertEqual(request.url?.scheme, "https")
        XCTAssertEqual(request.url?.host, "api.themoviedb.org")
        XCTAssertEqual(request.url?.path, "/test")
        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertEqual(mockComponents.urlParams, [:])
    }
    
    func test_headers_setup() throws {
        let headers = ["Authorization": "Bearer token"]
        let mockComponents = MockRequestComponents.make(headers: headers)

        let urlRequest = try mockComponents.makeURLRequest()

        XCTAssertEqual(urlRequest.allHTTPHeaderFields?["Authorization"], "Bearer token")
        XCTAssertEqual(urlRequest.allHTTPHeaderFields?["Content-Type"], "application/json")
        XCTAssertEqual(mockComponents.urlParams, [:])
    }

    func test_url_params_setup() throws {
        let urlParams = ["query": "value", "filter": "active"]
        let mockComponents = MockRequestComponents.make(urlParams: urlParams)

        let urlRequest = try mockComponents.makeURLRequest()

        let queryItems = URLComponents(url: urlRequest.url!, resolvingAgainstBaseURL: false)?.queryItems

        XCTAssertEqual(queryItems?.count, 2)
        XCTAssertEqual(queryItems?.first(where: { $0.name == "query" })?.value, "value")
        XCTAssertEqual(queryItems?.first(where: { $0.name == "filter" })?.value, "active")
        XCTAssertEqual(mockComponents.urlParams["query"], "value")
        XCTAssertEqual(mockComponents.urlParams["filter"], "active")
    }

    func test_json_body_encoding() throws {
        let params: [String: Any] = ["key1": "value1", "key2": 42]
        let mockComponents = MockRequestComponents.make(params: params)

        let urlRequest = try mockComponents.makeURLRequest()

        let json = try JSONSerialization.jsonObject(with: urlRequest.httpBody!, options: []) as? [String: Any]

        XCTAssertEqual(json?["key1"] as? String, "value1")
        XCTAssertEqual(json?["key2"] as? Int, 42)
        XCTAssertEqual(mockComponents.urlParams, [:])
    }
}
