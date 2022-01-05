import XCTest
import ViewInspector
@testable import SwiftSample

extension ProfileHeader: Inspectable {}

class ProfileHeaderTests: XCTestCase {

    func testHasText() throws {
        let sut = ProfileHeader(picture: "")
        XCTAssertEqual(try sut.inspect().text().string(), "Profile")
    }

}
