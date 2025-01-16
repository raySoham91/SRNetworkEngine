

@available(iOS 15.0, *)
public typealias NetworkEngine = SRNetworkEngine

@available(iOS 15.0, *)
/// An object responsible for managing network requests and decoding responses.
public final class SRNetworkEngine: Sendable, DataRequestableAndParseable {
    /// The parser used for decoding network response data.
    public let parser: any DataParserProtocol
    
    /// The API manager responsible for executing network requests.
    public let dataRequestor: any DataRequesting
    
    /// Initializes a new instance with the specified parser and API manager.
    ///
    /// - Parameters:
    ///   - parser: An object conforming to the `DataParserProtocol` that is used to parse data.
    ///             The default is an instance of `DataParser`.
    ///   - dataRequestor: An object conforming to the `DataRequesting`.
    ///                 The default is an instance of `NetworkRequestService`.
    public init(parser: any DataParserProtocol = JSONParser(), dataRequestor: any DataRequesting = NetworkRequestService()) {
        self.parser = parser
        self.dataRequestor = dataRequestor
    }
    
    /// Executes a network request and decodes the response into a specified type.
    ///
    /// - Parameter components: The `RequestComponents` containing details of the network request.
    /// - Returns: A decoded instance of the specified `Decodable` type.
    /// - Throws: An error if the request fails or the decoding is unsuccessful.
    public func sendRequest<T: Decodable>(with components: any RequestComponents) async throws -> T {
        let data = try await dataRequestor.requestData(with: components)
        return try parser.parse(data: data)
    }
    
}
