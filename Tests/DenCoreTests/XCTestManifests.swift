import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(NumpadKeysTest.allTests),
        testCase(FunctionKeysTest.allTests),
        testCase(DefaultOperatorsTest.allTests),
        testCase(OperatorsKeysTest.allTests),
        testCase(CustomizedKeysTest.allTests),
        testCase(GeocodeTest.allTests),
        testCase(NetworkTest.allTests)
    ]
}
#endif
