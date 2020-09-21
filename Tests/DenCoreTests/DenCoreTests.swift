import XCTest
@testable import DenCore

final class DenCoreTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(DenCore().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
