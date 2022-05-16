import SwiftUI
import XCTest
import ViewInspector
@testable import SwiftSample

extension ProfileView: Inspectable {}

class ProfileViewTests: XCTestCase {
    func testHasHeader() throws {
        let binding = Binding<User>(wrappedValue: User.empty)
        let sut = ProfileView(user: binding)
        XCTAssertNotNil(try? sut.inspect().list().find(ProfileHeader.self))
    }

    func testHasProfileValues() throws {
        let user = User(id: "foo", name: "bar", email: "baz", emailVerified: "qux", picture: "", updatedAt: "quux")
        let binding = Binding<User>(wrappedValue: user)
        let sut = ProfileView(user: binding)
        let cells = try sut.inspect().list().findAll(ProfileCell.self)
        XCTAssertEqual(cells.count, 5)
        XCTAssertEqual(try cells[0].findAll(ViewType.Text.self).last?.string(), user.id)
        XCTAssertEqual(try cells[1].findAll(ViewType.Text.self).last?.string(), user.name)
        XCTAssertEqual(try cells[2].findAll(ViewType.Text.self).last?.string(), user.email)
        XCTAssertEqual(try cells[3].findAll(ViewType.Text.self).last?.string(), user.emailVerified)
        XCTAssertEqual(try cells[4].findAll(ViewType.Text.self).last?.string(), user.updatedAt)
    }
}
