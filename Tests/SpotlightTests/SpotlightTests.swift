import XCTest
@testable import Spotlight

final class SpotlightTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(Spotlight().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
