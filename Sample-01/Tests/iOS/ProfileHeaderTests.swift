import XCTest
import ViewInspector
@testable import SwiftSample

extension ProfileHeader: Inspectable {}

class ProfileHeaderTests: XCTestCase {
    private let sut = ProfileHeader(picture: "")

    func testHasAsyncImage() throws {
        XCTAssertNoThrow(try self.sut.inspect().asyncImage())
    }

    func testAsyncImageUsesFixedSize() throws {
        let size: CGFloat = 100
        XCTAssertEqual(try self.sut.inspect().asyncImage().fixedHeight(), size)
        XCTAssertEqual(try self.sut.inspect().asyncImage().fixedHeight(), size)
    }
}
