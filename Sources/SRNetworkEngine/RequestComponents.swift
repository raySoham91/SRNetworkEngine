//
//  RequestComponents.swift
//  SRNetworkEngine
//
//  Created by Soham Ray on 11.01.25.
//

import Foundation

public protocol RequestComponents: Sendable {

    /// The URL scheme (e.g., "http" or "https").
    var scheme: String { get }

    /// The base host/domain for the URL.
    var host: String { get }

    /// The specific path for the resource being requested (e.g., "/movie/popular").
    var path: String { get }

    /// The HTTP request method used (e.g., GET, POST).
    var requestType: RequestType { get }
    
    /// The HTTP request MIME Type (e.g., application/json or multipart/form-data)
    var requestMIMEType: RequestMIMEType { get }

    /// Any custom HTTP headers to include in the request.
    var headers: [String: String] { get }

    /// The body parameters to include in the request, typically for POST or PUT requests.
    var params: [String: Any] { get }

    /// The URL query parameters to append to the request URL.
    var urlParams: [String: String?] { get }

    /// A flag indicating whether an authorization token should be included in the request.
    var addAuthorizationToken: Bool { get }
}

// MARK: - Default Request Implementation

public extension RequestComponents {
    /// Indicates whether an authorization token should be included in the request.
    /// The default is `true`, meaning the token will be included unless specified otherwise.
    var addAuthorizationToken: Bool {
        true
    }

    /// Default empty body parameters for requests (usually POST or PUT).
    var params: [String: Any] {
        [:]
    }

    /// Default empty URL query parameters.
    var urlParams: [String: String?] {
        [:]
    }
    
    var requestMIMEType: RequestMIMEType {
        return .json
    }

    /// Default empty HTTP headers.
    var headers: [String: String] {
        [:]
    }

    /// Constructs and returns a `URLRequest` based on the components provided by the conforming type.
    ///
    /// - Returns: A fully constructed `URLRequest` object with the provided URL, method, headers, and body.
    /// - Throws: `NetworkError.invalidURL` if the URL components cannot form a valid URL.
    func makeURLRequest() throws -> URLRequest {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        components.queryItems = urlParams.map { URLQueryItem(name: $0, value: $1) }

        guard let url = components.url else {
            throw NetworkError.invalidURL
        }

        var urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData)
        urlRequest.httpMethod = requestType.rawValue

        if !headers.isEmpty {
            urlRequest.allHTTPHeaderFields = headers
        }

        urlRequest.setValue(requestMIMEType.rawValue, forHTTPHeaderField: "Content-Type")

        if !params.isEmpty {
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params)
        }

        return urlRequest
    }
}
