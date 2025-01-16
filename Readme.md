# SRNetworkEngine

SRNetworkEngine is a Swift package designed to simplify network requests and data parsing. It provides a flexible and extensible framework for making HTTP requests, handling responses, and parsing JSON data.

## Features

- Supports various HTTP request methods (GET, POST, PUT, PATCH, DELETE)
- Provides a protocol-oriented design for easy customization and testing
- Includes built-in support for JSON parsing with `JSONDecoder`
- Supports async/await for modern concurrency

## Requirements

- iOS 13.0+
- Swift 6.0+
- Xcode 13.0+

## Installation

### Swift Package Manager

To integrate SRNetworkEngine into your project using Swift Package Manager, add the following dependency to your `Package.swift` file:

```swift
// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "YourProjectName",
    dependencies: [
        .package(url: "https://github.com/raySoham91/SRNetworkEngine.git", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "YourTargetName",
            dependencies: ["SRNetworkEngine"]),
    ]
)
```

## Usage

### Creating a network request
1. Define your request components by conforming to the `RequestComponents` protocol:
```swift
// filepath: SRNetworkEngine.swift
import Foundation

struct MyRequestComponents: RequestComponents {
    let scheme = "https"
    let host = "api.example.com"
    let path = "/endpoint"
    let requestType: RequestType = .GET
    let headers: [String: String] = ["Authorization": "Bearer token"]
    let params: [String: Any] = [:]
    let urlParams: [String: String?] = ["query": "value"]
}
```
2. Create an instance of `NetworkEngine` and send a request:
```swift
// filepath: SRNetworkEngine.swift
import Foundation

@available(iOS 15.0, *)
func fetchData() async {
    let components = MyRequestComponents()
    let networkEngine = NetworkEngine()

    do {
        let response: MyResponseModel = try await networkEngine.sendRequest(with: components)
        print("Response: \(response)")
    } catch {
        print("Error: \(error)")
    }
}
```
3. Define your response model:
```swift
// filepath: SRNetworkEngine.swift
import Foundation

struct MyResponseModel: Decodable {
    let id: Int
    let name: String
}
```
4. Full Example
```swift
// filepath: SRNetworkEngine.swift
import Foundation

// Define request components
struct MyRequestComponents: RequestComponents {
    let scheme = "https"
    let host = "api.example.com"
    let path = "/endpoint"
    let requestType: RequestType = .GET
    let headers: [String: String] = ["Authorization": "Bearer token"]
    let params: [String: Any] = [:]
    let urlParams: [String: String?] = ["query": "value"]
}

// Define response model
struct MyResponseModel: Decodable {
    let id: Int
    let name: String
}

// Fetch data using NetworkEngine
@available(iOS 15.0, *)
func fetchData() async {
    let components = MyRequestComponents()
    let networkEngine = NetworkEngine()

    do {
        let response: MyResponseModel = try await networkEngine.sendRequest(with: components)
        print("Response: \(response)")
    } catch {
        print("Error: \(error)")
    }
}
```