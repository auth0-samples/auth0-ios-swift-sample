import SwiftUI
import XCTest
import ViewInspector
@testable import SwiftSample

extension ProfileView: Inspectable {}

class ProfileViewTests: XCTestCase {

    func testHasHeader() throws {
        let binding = Binding<Profile>(wrappedValue: Profile.empty)
        let sut = ProfileView(profile: binding)
        XCTAssertNotNil(try? sut.inspect().list().find(ProfileHeader.self))
    }

    func testHasProfileValues() throws {
        let profile = Profile(id: "foo",
                              name: "bar",
                              email: "baz",
                              emailVerified: "qux",
                              picture: "",
                              updatedAt: "quux")
        let binding = Binding<Profile>(wrappedValue: profile)
        let sut = ProfileView(profile: binding)
        let cells = try sut.inspect().list().findAll(ProfileCell.self)
        XCTAssertEqual(cells.count, 5)
        XCTAssertEqual(try cells[0].findAll(ViewType.Text.self).last?.string(), profile.id)
        XCTAssertEqual(try cells[1].findAll(ViewType.Text.self).last?.string(), profile.name)
        XCTAssertEqual(try cells[2].findAll(ViewType.Text.self).last?.string(), profile.email)
        XCTAssertEqual(try cells[3].findAll(ViewType.Text.self).last?.string(), profile.emailVerified)
        XCTAssertEqual(try cells[4].findAll(ViewType.Text.self).last?.string(), profile.updatedAt)
    }

}
