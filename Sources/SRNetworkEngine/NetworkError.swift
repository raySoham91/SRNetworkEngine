//
//  NetworkError.swift
//  SRNetworkEngine
//
//  Created by Soham Ray on 11.01.25.
//

import Foundation

/// `NetworkError` includes cases for invalid URLs, unexpected HTTP responses, and
/// specific HTTP response status codes.
public enum NetworkError: LocalizedError, Hashable, Sendable {

    /// Indicates that the URL provided is invalid.
    case invalidURL

    /// Indicates that the HTTP response received is not valid.
    case invalidHTTPURLResponse

    /// Represents an HTTP response with a specific status code.
    /// - Parameter code: The HTTP status code associated with the response.
    case httpResponse(code: Int)
}
