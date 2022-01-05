import XCTest
import ViewInspector
@testable import SwiftSample

extension ProfileCell: Inspectable {}

class ProfileCellTests: XCTestCase {

    func testHasKeyAndValue() throws {
        let key = "foo"
        let value = "bar"
        let sut = ProfileCell(key: key, value: value)
        let textViews = try sut.inspect().hStack().findAll(ViewType.Text.self)
        XCTAssertEqual(textViews.count, 2)
        XCTAssertEqual(try textViews[0].string(), key)
        XCTAssertEqual(try textViews[1].string(), value)
    }

    func testUsesSemiboldFontForKey() throws {
        let sut = ProfileCell(key: "", value: "")
        let key = try sut.inspect().findAll(ViewType.Text.self).first
        XCTAssertEqual(try key?.attributes().font().weight(), .semibold)
        XCTAssertEqual(try key?.attributes().font().size(), 14)
    }

    func testUsesRegularFontForValue() throws {
        let sut = ProfileCell(key: "", value: "")
        let key = try sut.inspect().findAll(ViewType.Text.self).last
        XCTAssertEqual(try key?.attributes().font().weight(), .regular)
        XCTAssertEqual(try key?.attributes().font().size(), 14)
    }

}
