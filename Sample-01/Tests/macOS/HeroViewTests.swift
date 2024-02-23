import XCTest
import ViewInspector
@testable import SwiftSample

class HeroViewTests: XCTestCase {
    private let sut = HeroView()

    func testHasText() throws {
        XCTAssertEqual(try self.sut.inspect().text().string(), "Swift Sample App")
    }

    func testTextUsesTitleFont() throws {
        XCTAssertEqual(try self.sut.inspect().text().attributes().font().style(), .title)
    }
}
