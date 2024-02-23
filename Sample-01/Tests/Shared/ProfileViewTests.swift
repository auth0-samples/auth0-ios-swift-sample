import SwiftUI
import XCTest
import ViewInspector
@testable import SwiftSample

class ProfileViewTests: XCTestCase {
    func testHasHeader() throws {
        let user = User(id: "", name: "", email: "", emailVerified: "", picture: "", updatedAt: "")
        let sut = ProfileView(user: user)
        XCTAssertNoThrow(try sut.inspect().list().find(ProfileHeader.self))
    }

    func testHasProfileValues() throws {
        let user = User(id: "foo", name: "bar", email: "baz", emailVerified: "qux", picture: "", updatedAt: "quux")
        let sut = ProfileView(user: user)
        let cells = try sut.inspect().list().findAll(ProfileCell.self)
        XCTAssertEqual(cells.count, 5)
        XCTAssertEqual(try cells[0].findAll(ViewType.Text.self).last?.string(), user.id)
        XCTAssertEqual(try cells[1].findAll(ViewType.Text.self).last?.string(), user.name)
        XCTAssertEqual(try cells[2].findAll(ViewType.Text.self).last?.string(), user.email)
        XCTAssertEqual(try cells[3].findAll(ViewType.Text.self).last?.string(), user.emailVerified)
        XCTAssertEqual(try cells[4].findAll(ViewType.Text.self).last?.string(), user.updatedAt)
    }
}
