import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    var tests: [XCTestCaseEntry] = []
    
    if #available(macOS 11.0, iOS 14.0, *) {
        tests.append(testCase(AvatarTests.allTests))
        tests.append(testCase(QRScannerServiceTests.allTests))
    }
    
    if #available(macOS 10.15, iOS 13.0, *) {
        tests.append(testCase(AvatarViewModelTests.allTests))
    }
    
    return tests
}
#endif 