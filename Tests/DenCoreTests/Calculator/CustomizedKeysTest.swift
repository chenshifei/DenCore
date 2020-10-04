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
        var customizedKey = CustomizedKey(name: name)
        XCTAssertEqual(customizedKey.name, name)
        XCTAssertTrue(customizedKey.enabled)
        
        customizedKey.enabled = false
        XCTAssertFalse(customizedKey.enabled)
    }
    
    static var allTests = [
        ("testCustomizedKey", testCustomizedKey)
    ]
}
