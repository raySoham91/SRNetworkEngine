//
//  DataRequestableAndParseable.swift
//  SRNetworkEngine
//
//  Created by Soham Ray on 11.01.25.
//

import Foundation

/// A protocol for managing network requests and decoding responses into Swift types.
///
/// Conformance to `Sendable` ensures that implementations of this protocol can be used safely
/// in concurrent contexts.
@available(iOS 15.0, *)
public protocol DataRequestableAndParseable: Sendable {

    /// The parser conforming ot the `DataParserProtocol` used for decoding network response data.
    var parser: DataParserProtocol { get }

    /// The API manager conforming to the `APIManagerProtocol`, responsible for executing network requests.
    var dataRequestor: DataRequesting { get }

    /// Executes a network request and decodes the response into a specified type.
    ///
    /// - Parameter components: The `RequestComponents` containing details of the network request.
    /// - Returns: A decoded instance of the specified `Decodable` type.
    /// - Throws: An error if the request fails or the decoding is unsuccessful.
    func sendRequest<T: Decodable>(with components: RequestComponents) async throws -> T
}
