import XCTest
@testable import Refs

final class RefsTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(Refs().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
