import XCTest
import ViewInspector
@testable import SwiftSample

extension HeroView: Inspectable {}

class HeroViewTests: XCTestCase {

    private let sut = HeroView()

    func testHasLogo() throws {
        let logo = try self.sut.inspect().image(0)
        XCTAssertEqual(try logo.actualImage().name(), "Auth0")
        XCTAssertEqual(try logo.aspectRatio().contentMode, .fit)
        XCTAssertEqual(try logo.fixedWidth(), 25)
        XCTAssertEqual(try logo.fixedHeight(), 28)
    }

    func testLogoUsesFixedSize() throws {
        let logo = try self.sut.inspect().image(0)
        XCTAssertEqual(try logo.fixedWidth(), 25)
        XCTAssertEqual(try logo.fixedHeight(), 28)
        XCTAssertEqual(try logo.aspectRatio().contentMode, .fit)
    }

    func testHasText() throws {
        let textViews = try self.sut.inspect().vStack(1).findAll(ViewType.Text.self)
        XCTAssertEqual(textViews.count, 3)
        XCTAssertEqual(try textViews[0].string(), "Swift")
        XCTAssertEqual(try textViews[1].string(), "Sample")
        XCTAssertEqual(try textViews[2].string(), "App")
    }

    func testTextUsesCustomFont() throws {
        for text in try self.sut.inspect().vStack(1).findAll(ViewType.Text.self) {
            XCTAssertEqual(try text.attributes().font().name(), "SpaceGrotesk-Medium")
            XCTAssertEqual(try text.attributes().font().size(), 80)
        }
    }

    func testTextUsesFlexibleSize() throws {
        let vStack = try self.sut.inspect().vStack(1)
        XCTAssertEqual(try vStack.flexFrame().maxWidth, .infinity)
        XCTAssertEqual(try vStack.flexFrame().maxHeight, .infinity)
    }

}
