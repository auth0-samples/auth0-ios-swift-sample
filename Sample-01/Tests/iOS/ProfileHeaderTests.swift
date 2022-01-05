import XCTest
import ViewInspector
@testable import SwiftSample

extension ProfileHeader: Inspectable {}

class ProfileHeaderTests: XCTestCase {

    func testHasAsyncImage() throws {
        let sut = ProfileHeader(picture: "")
        XCTAssertNotNil(try? sut.inspect().asyncImage())
    }

    func testUsesFixedSize() throws {
        let size: CGFloat = 100
        let sut = ProfileHeader(picture: "")
        XCTAssertEqual(try sut.inspect().asyncImage().fixedHeight(), size)
        XCTAssertEqual(try sut.inspect().asyncImage().fixedHeight(), size)
    }

}
