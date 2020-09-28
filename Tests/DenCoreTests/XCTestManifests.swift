import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(NumberKeysTest.allTests),
        testCase(FunctionKeysTest.allTests),
        testCase(DefaultOperatorsTest.allTests),
        testCase(GeocodeTest.allTests)
    ]
}
#endif
