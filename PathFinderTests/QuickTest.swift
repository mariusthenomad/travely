import XCTest

class QuickTest: XCTestCase {
    
    func testBasicMath() {
        XCTAssertEqual(2 + 2, 4, "Basic math should work")
    }
    
    func testStringComparison() {
        let hello = "Hello"
        let world = "World"
        XCTAssertNotEqual(hello, world, "Different strings should not be equal")
    }
}
