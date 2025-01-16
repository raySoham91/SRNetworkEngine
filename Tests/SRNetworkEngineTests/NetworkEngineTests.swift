//
//  NetworkEngineTests.swift
//  SRNetworkEngine
//
//  Created by Soham Ray on 16.01.25.
//


import XCTest

@testable import SRNetworkEngine

@available(iOS 15.0, *)
final class NetworkEngineTests: XCTestCase {

    private var mockAPIManager: MockNetworkDataRequestor!
    private var requestManager: NetworkEngine!

    override func setUp() {
        super.setUp()

        mockAPIManager = MockNetworkDataRequestor()
        requestManager = NetworkEngine(dataRequestor: mockAPIManager)
    }

    override func tearDown() {
        mockAPIManager = nil
        requestManager = nil
        super.tearDown()
    }

    func test_decode_valid_data_successful_parsing() async throws {
        let json = """
        {
            "id": 1,
            "name": "John Doe"
        }
        """
        let jsonData = Data(json.utf8)
        mockAPIManager.dataToReturn = jsonData
        let mockComponents = MockRequestComponents.make()

        let result: MockResponse = try await requestManager.sendRequest(with: mockComponents)

        let expectedResponse = MockResponse(id: 1, name: "John Doe")
        XCTAssertEqual(result, expectedResponse)
    }

    func test_decode_invalid_json_throws_decoding_error() async throws {
        let invalidJsonData = Data("Invalid JSON Data".utf8)
        mockAPIManager.dataToReturn = invalidJsonData
        let mockComponents = MockRequestComponents.make()

        do {
            _ = try await requestManager.sendRequest(with: mockComponents) as MockResponse
            XCTFail("Expected to throw DecodingError, but no error was thrown.")
        } catch {
            XCTAssertTrue(error is DecodingError, "Expected DecodingError but got \(error)")
        }
    }

    func test_decode_api_manager_throws_network_error() async throws {
        mockAPIManager.errorToThrow = NetworkError.invalidURL
        let mockComponents = MockRequestComponents.make()

        do {
            _ = try await requestManager.sendRequest(with: mockComponents) as MockResponse
            XCTFail("Expected to throw NetworkError, but no error was thrown.")
        } catch {
            XCTAssertEqual(error as? NetworkError, .invalidURL)
        }
    }

    // MARK: - Sample Decodable struct for testing

    private struct MockResponse: Decodable, Equatable {
        let id: Int
        let name: String
    }
}
