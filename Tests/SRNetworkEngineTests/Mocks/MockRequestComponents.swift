//
//  MockRequestComponents.swift
//  SRNetworkEngine
//
//  Created by Soham Ray on 13.01.25.
//



@testable import SRNetworkEngine

struct MockRequestComponents: @unchecked Sendable, RequestComponents {
    
    let scheme: String
    let host: String
    let path: String
    let requestType: RequestType
    let headers: [String: String]
    let params: [String: Any]
    let urlParams: [String: String?]
    let addAuthorizationToken: Bool
    
    static func make(scheme: String = "https",
                     host: String = "api.themoviedb.org",
                     path: String = "/test",
                     requestType: RequestType = .GET,
                     headers: [String: String] = [:],
                     params: [String: Any] = [:],
                     urlParams: [String: String?] = [:],
                     addAuthorizationToken: Bool = false) -> Self {
        return MockRequestComponents(scheme: scheme,
                                     host: host,
                                     path: path,
                                     requestType: requestType,
                                     headers: headers,
                                     params: params,
                                     urlParams: urlParams,
                                     addAuthorizationToken: addAuthorizationToken)
    }
}
