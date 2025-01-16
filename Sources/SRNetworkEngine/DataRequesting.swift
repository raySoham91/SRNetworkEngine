//
//  DataRequesting.swift
//  SRNetworkEngine
//
//  Created by Soham Ray on 11.01.25.
//
import Foundation

public protocol DataRequesting: Sendable {
    /// Executes a network request and returns the response data.
    ///
    /// - Parameter components: The `RequestComponents` object that defines the details
    ///   of the network request to be performed.
    /// - Returns: The raw `Data` retrieved from the server.
    /// - Throws: A `NetworkError` if the request fails or the response is invalid.
    func requestData(with components: RequestComponents) async throws -> Data
}
