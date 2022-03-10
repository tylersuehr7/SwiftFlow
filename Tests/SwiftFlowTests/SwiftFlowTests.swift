import XCTest
@testable import SwiftFlow

final class SwiftFlowTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        let state = StateFlow("Hello, World!")
        XCTAssertEqual(state.value, "Hello, World!")
    }
}
