import XCTest
import ViewInspector
@testable import SwiftSample

extension HeroView: Inspectable {}

class HeroViewTests: XCTestCase {

    func testHasText() throws {
        let sut = HeroView()
        XCTAssertEqual(try sut.inspect().text().string(), "Auth0 Swift Sample")
    }

    func testUsesTitleFont() throws {
        let sut = HeroView()
        XCTAssertEqual(try sut.inspect().text().attributes().font().style(), .title)
    }

}
