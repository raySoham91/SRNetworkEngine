//
//  NetworkRequestServiceTests.swift
//  SRNetworkEngine
//
//  Created by Soham Ray on 16.01.25.
//


import Foundation
import XCTest

@testable import SRNetworkEngine

@available(iOS 15.0, *)
final class NetworkRequestServiceTests: XCTestCase {

    private let mockComponents = MockRequestComponents.make()
    private let mockURLsession: URLSession = {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        return URLSession(configuration: configuration)
    }()

    func test_request_data_should_throw_a_401_http_response_error() async throws {
        let service = NetworkRequestService(urlSession: mockURLsession)

        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.url?.absoluteString, "https://api.themoviedb.org/test?")
            let response = HTTPURLResponse(url: request.url!,
                                           statusCode: 401,
                                           httpVersion: nil,
                                           headerFields: nil)!
            return (response, Data())
        }
        do {
            _ = try await service.requestData(with: mockComponents)
            XCTFail("Expected error to be thrown, but no error was thrown")
        } catch {
            XCTAssertEqual(error as? NetworkError, .httpResponse(code: 401))
        }
    }

    func test_request_data_should_succeed() async throws {
        let json = """
        "id": 1
        "title": "This is a title"
        """
        let mockData = Data(json.utf8)

        let service = NetworkRequestService(urlSession: mockURLsession)

        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.url?.absoluteString, "https://api.themoviedb.org/test?")
            let response = HTTPURLResponse(url: request.url!,
                                           statusCode: 201,
                                           httpVersion: nil,
                                           headerFields: nil)!
            return (response, mockData)
        }

        let result = try await service.requestData(with: mockComponents)
        XCTAssertEqual(result, mockData)
    }
}
