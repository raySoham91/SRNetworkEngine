//
//  NetworkRequestService.swift
//  SRNetworkEngine
//
//  Created by Soham Ray on 11.01.25.
//
import Foundation
import os.log

@available(iOS 15.0, *)
public final actor NetworkRequestService: DataRequesting {

    private let logger = Logger(subsystem: "NetworkEngine.Package", category: "NetworkRequestService")
    private let urlSession: URLSession

    /// Creates a new instance of `NetworkRequestService`.
    ///
    /// - Parameter urlSession: The `URLSession` instance to use for executing network requests.
    ///   Defaults to `URLSession.shared`.
    public init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }

    /// Executes a network request and validates the response.
    ///
    /// - Parameter components: The `RequestComponents` containing details of the network request.
    /// - Returns: The raw `Data` returned from the server.
    /// - Throws: A `NetworkError` if the response is invalid or if the request fails.
    public func requestData(with components: RequestComponents) async throws -> Data {
        let urlRequest = try components.makeURLRequest()
        let (data, response) = try await urlSession.data(for: urlRequest)
        guard let httpResponse = response as? HTTPURLResponse else {
            logger.error("Invalid HTTPURLResponse")
            throw NetworkError.invalidHTTPURLResponse
        }
        guard (200...299).contains(httpResponse.statusCode) else {
            logger.error("Request to \(urlRequest.url?.absoluteString ?? "unknown URL") failed with status code \(httpResponse.statusCode)")
            throw NetworkError.httpResponse(code: httpResponse.statusCode)
        }
        return data
    }
}
