//
//  NetworkTest.swift
//  DenCoreTests
//
//  Created by Shifei Chen on 2020-09-29.
//

import XCTest
@testable import DenCore

struct MockSession: NetworkSession {
    var resultToReturn: Data?
    var responseToReturn: URLResponse?
    var errorToReturn: Error?
    
    func get(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        completion(resultToReturn, responseToReturn, errorToReturn)
    }
}

struct MockData: Codable, Equatable {
    let id: Int
    let name: String
}

struct AnotherMockData: Codable, Equatable {
    let id: Int
    let address: String
}

final class NetworkTest: XCTestCase {
    let testURL: URL = URL(string: "https://testdomain.com")!
    
    func testStatusCodeNot200() {
        let statusCode = 404
        
        var mockSession = MockSession()
        let mockResponse = HTTPURLResponse(url: testURL, statusCode: statusCode, httpVersion: "2.0", headerFields: nil)
        mockSession.responseToReturn = mockResponse
        
        let networkService = NetworkCable()
        networkService.session = mockSession
        networkService.fetchData(from: testURL) { (data: Data?, error) in
            XCTAssertNil(data)
            XCTAssertNotNil(error)
            guard let error = error, error is NetworkCableError else {
                XCTFail()
                return
            }
            if case NetworkCableError.HTTPStatusCodeError(let code) = error {
                XCTAssertEqual(code, statusCode)
            }
        }
    }
    
    func testEmptyObject() {
        var mockSession = MockSession()
        let mockResponse = HTTPURLResponse(url: testURL, statusCode: 200, httpVersion: "2.0", headerFields: nil)
        mockSession.responseToReturn = mockResponse
        let networkService = NetworkCable()
        networkService.session = mockSession
        networkService.fetchData(from: testURL) { (data: Data?, error) in
            XCTAssertNil(data)
            XCTAssertNotNil(error)
            guard let error = error, error is NetworkCableError else {
                XCTFail()
                return
            }
            if case NetworkCableError.EmptyData = error {} else {
                XCTFail()
            }
        }
        
        mockSession.resultToReturn = Data()
        networkService.session = mockSession
        networkService.fetchData(from: testURL) { (data: Data?, error) in
            XCTAssertNil(data)
            XCTAssertNotNil(error)
        }
    }
    
    func testUndecodeableObject() {
        var mockSession = MockSession()
        let mockResponse = HTTPURLResponse(url: testURL, statusCode: 200, httpVersion: "2.0", headerFields: nil)
        mockSession.responseToReturn = mockResponse
        let networkService = NetworkCable()
        let mockData = MockData(id: 12, name: "testName")
        mockSession.resultToReturn = try? JSONEncoder().encode(mockData)
        networkService.session = mockSession
        networkService.fetchData(from: testURL) { (result: AnotherMockData?, error) in
            XCTAssertNil(result)
            XCTAssertNotNil(error)
        }
    }
    
    func testRequestSuccess() {
        var mockSession = MockSession()
        let mockResponse = HTTPURLResponse(url: testURL, statusCode: 200, httpVersion: "2.0", headerFields: nil)
        mockSession.responseToReturn = mockResponse
        let mockData = MockData(id: 12, name: "testName")
        mockSession.resultToReturn = try? JSONEncoder().encode(mockData)
        let networkService = NetworkCable()
        networkService.session = mockSession
        networkService.fetchData(from: testURL) { (result: MockData?, error) in
            XCTAssertNotNil(result)
            XCTAssertEqual(result, mockData)
            XCTAssertNil(error)
            XCTAssert(Thread.isMainThread)
        }
    }
    
    func testRequestReturnedError() {
        var mockSession = MockSession()
        let errorMessage = "testError"
        mockSession.errorToReturn = NetworkCableError.Other(errorMessage)
        let networkService = NetworkCable()
        networkService.session = mockSession
        networkService.fetchData(from: testURL) { (data: Data?, error) in
            XCTAssertNil(data)
            XCTAssertNotNil(error)
            XCTAssert(Thread.isMainThread)
            guard let error = error, error is NetworkCableError else {
                XCTFail()
                return
            }
            if case NetworkCableError.Other(let s) = error {
                XCTAssertEqual(s, errorMessage)
            } else {
                XCTFail()
            }
        }
    }
    
    static var allTests = [
        ("testStatusCodeNot200", testStatusCodeNot200),
        ("testUndecodeableObject", testUndecodeableObject),
        ("testRequestSuccess", testRequestSuccess),
        ("testRequestReturnedError", testRequestReturnedError),
        ("testEmptyObject", testEmptyObject)
    ]
}
