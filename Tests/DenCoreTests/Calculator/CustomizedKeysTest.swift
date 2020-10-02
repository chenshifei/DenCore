//
//  CustomizedKeyTest.swift
//  DenCoreTests
//
//  Created by Shifei Chen on 2020-10-02.
//

import XCTest
@testable import DenCore

final class CustomizedKeysTest: XCTestCase {
    func testCustomizedKey() {
        let name = "stringify"
        let customizedKey = CustomizedKey(name: name)
        XCTAssertEqual(customizedKey.name, name)
    }
    
    static var allTests = [
        ("testCustomizedKey", testCustomizedKey)
    ]
}
