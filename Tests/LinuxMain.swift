import XCTest

#if os(Linux)
import AvatarQRTests

@main
struct LinuxMain {
    static func main() {
        var tests = [XCTestCaseEntry]()
        tests += AvatarQRTests.allTests()
        XCTMain(tests)
    }
}
#endif 