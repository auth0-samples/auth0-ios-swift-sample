import XCTest
import ViewInspector
@testable import SwiftSample

extension ProfileCell: Inspectable {}

class ProfileCellTests: XCTestCase {

    private var sut: ProfileCell!

    override func setUp() {
        self.sut = ProfileCell(key: "", value: "")
    }

    func testHasKeyAndValue() throws {
        let key = "foo"
        let value = "bar"
        self.sut = ProfileCell(key: key, value: value)
        let textViews = try self.sut.inspect().findAll(ViewType.Text.self)
        XCTAssertEqual(textViews.count, 2)
        XCTAssertEqual(try textViews[0].string(), key)
        XCTAssertEqual(try textViews[1].string(), value)
    }

    func testKeyUsesSemiboldFont() throws {
        let key = try self.sut.inspect().findAll(ViewType.Text.self).first
        XCTAssertEqual(try key?.attributes().font().weight(), .semibold)
        XCTAssertEqual(try key?.attributes().font().size(), 14)
    }

    func testValueUsesRegularFont() throws {
        let key = try self.sut.inspect().findAll(ViewType.Text.self).last
        XCTAssertEqual(try key?.attributes().font().weight(), .regular)
        XCTAssertEqual(try key?.attributes().font().size(), 14)
    }

}
