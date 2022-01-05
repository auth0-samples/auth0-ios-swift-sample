import XCTest
import ViewInspector
@testable import SwiftSample

extension HeroView: Inspectable {}

class HeroViewTests: XCTestCase {

    func testHasLogo() throws {
        let sut = HeroView()
        let logo = try sut.inspect().image(0)
        XCTAssertEqual(try logo.actualImage().name(), "Auth0")
        XCTAssertEqual(try logo.aspectRatio().contentMode, .fit)
        XCTAssertEqual(try logo.fixedWidth(), 25)
        XCTAssertEqual(try logo.fixedHeight(), 28)
    }

    func testHasText() throws {
        let sut = HeroView()
        let textViews = try sut.inspect().vStack(1).findAll(ViewType.Text.self)
        XCTAssertEqual(textViews.count, 3)
        XCTAssertEqual(try textViews[0].string(), "Swift")
        XCTAssertEqual(try textViews[1].string(), "Sample")
        XCTAssertEqual(try textViews[2].string(), "App")
    }

    func testUsesCustomFont() throws {
        let sut = HeroView()
        for text in try sut.inspect().vStack(1).findAll(ViewType.Text.self) {
            XCTAssertEqual(try text.attributes().font().name(), "SpaceGrotesk-Medium")
            XCTAssertEqual(try text.attributes().font().size(), 80)
        }
    }

    func testUsesFlexibleSize() throws {
        let sut = HeroView()
        let vStack = try sut.inspect().vStack(1)
        XCTAssertEqual(try vStack.flexFrame().maxWidth, .infinity)
        XCTAssertEqual(try vStack.flexFrame().maxHeight, .infinity)
    }

}
