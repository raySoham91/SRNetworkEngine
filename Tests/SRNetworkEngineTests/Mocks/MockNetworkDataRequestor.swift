//
//  MockNetworkDataRequestor.swift
//  SRNetworkEngine
//
//  Created by Soham Ray on 13.01.25.
//


import Foundation

@testable import SRNetworkEngine

final class MockNetworkDataRequestor: @unchecked Sendable, DataRequesting {
    var dataToReturn: Data?
    var errorToThrow: Error?

    func requestData(with components: RequestComponents) async throws -> Data {
        if let error = errorToThrow {
            throw error
        }
        return dataToReturn ?? Data()
    }
}
