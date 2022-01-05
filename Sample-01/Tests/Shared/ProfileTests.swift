import XCTest
@testable import SwiftSample

extension Profile: Equatable {
    public static func == (lhs: Profile, rhs: Profile) -> Bool {
        return (lhs.id == rhs.id)
            && (lhs.name == rhs.name)
            && (lhs.email == rhs.email)
            && (lhs.emailVerified == rhs.emailVerified)
            && (lhs.picture == rhs.picture)
            && (lhs.updatedAt == rhs.updatedAt)
    }
}

class ProfileTests: XCTestCase {

    func testReturnsEmptyProfile() {
        let sut = Profile.empty
        XCTAssertEqual(sut.id, "")
        XCTAssertEqual(sut.name, "")
        XCTAssertEqual(sut.email, "")
        XCTAssertEqual(sut.emailVerified, "")
        XCTAssertEqual(sut.picture, "")
        XCTAssertEqual(sut.updatedAt, "")
    }

    func testReturnsProfileFromIDToken() {
        let idToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJmb28iLCJuYW1lIjoiYmFyIiwiZW1haWwiOiJmb29AZXhhbXBsZS5jb20iLCJlbWFpbF92ZXJpZmllZCI6dHJ1ZSwicGljdHVyZSI6ImJheiIsInVwZGF0ZWRfYXQiOiJxdXgifQ.vc9sxvhUVAHowIWJ7D_WDzvqJxC4-qYXHmiBVYEKn9E"
        let sut = Profile.from(idToken)
        XCTAssertEqual(sut.id, "foo")
        XCTAssertEqual(sut.name, "bar")
        XCTAssertEqual(sut.email, "foo@example.com")
        XCTAssertEqual(sut.emailVerified, "true")
        XCTAssertEqual(sut.picture, "baz")
        XCTAssertEqual(sut.updatedAt, "qux")
    }

    func testReturnsEmptyProfileWhenIDTokenDecodingFails() {
        let idToken = "foo.bar.baz"
        XCTAssertEqual(Profile.from(idToken), Profile.empty)
    }

    func testReturnsEmptyProfileWhenSubjectIsMissing() {
        let idToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYW1lIjoiYmFyIiwiZW1haWwiOiJmb29AZXhhbXBsZS5jb20iLCJlbWFpbF92ZXJpZmllZCI6dHJ1ZSwicGljdHVyZSI6ImJheiIsInVwZGF0ZWRfYXQiOiJxdXgifQ.dkS2qn1pbmznis5krUlKuornFIr-lZ_vTDn36ksFzFM"
        XCTAssertEqual(Profile.from(idToken), Profile.empty)
    }

    func testReturnsEmptyProfileWhenNameIsMissing() {
        let idToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJmb28iLCJlbWFpbCI6ImZvb0BleGFtcGxlLmNvbSIsImVtYWlsX3ZlcmlmaWVkIjp0cnVlLCJwaWN0dXJlIjoiYmF6IiwidXBkYXRlZF9hdCI6InF1eCJ9.92bnGEfJGKt5vsdkFHeyeykrlynn4J6tSRw9ex2XsqE"
        XCTAssertEqual(Profile.from(idToken), Profile.empty)
    }

    func testReturnsEmptyProfileWhenEmailIsMissing() {
        let idToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJmb28iLCJuYW1lIjoiYmFyIiwiZW1haWxfdmVyaWZpZWQiOnRydWUsInBpY3R1cmUiOiJiYXoiLCJ1cGRhdGVkX2F0IjoicXV4In0.g9zSyuxzfNlN_-6E1FJfJdQhGpPMTLI0W8hIaiyylng"
        XCTAssertEqual(Profile.from(idToken), Profile.empty)
    }

    func testReturnsEmptyProfileWhenEmailVerifiedIsMissing() {
        let idToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJmb28iLCJuYW1lIjoiYmFyIiwiZW1haWwiOiJmb29AZXhhbXBsZS5jb20iLCJwaWN0dXJlIjoiYmF6IiwidXBkYXRlZF9hdCI6InF1eCJ9.OpiRejUet5bC2-ea4AtTQp7PI1kvDHM_lGLKLyrM5Z0"
        XCTAssertEqual(Profile.from(idToken), Profile.empty)
    }

    func testReturnsEmptyProfileWhenPictureIsMissing() {
        let idToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJmb28iLCJuYW1lIjoiYmFyIiwiZW1haWwiOiJmb29AZXhhbXBsZS5jb20iLCJlbWFpbF92ZXJpZmllZCI6dHJ1ZSwidXBkYXRlZF9hdCI6InF1eCJ9.A1BwdpsSf3azr8I724tVdz0iWA9qrVwFOHOf_DWekQY"
        XCTAssertEqual(Profile.from(idToken), Profile.empty)
    }

    func testReturnsEmptyProfileWhenUpdatedAtIsMissing() {
        let idToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJmb28iLCJuYW1lIjoiYmFyIiwiZW1haWwiOiJmb29AZXhhbXBsZS5jb20iLCJlbWFpbF92ZXJpZmllZCI6dHJ1ZSwicGljdHVyZSI6ImJheiJ9.mHTo0v7jIVQ9ELcstaDV3FxSUsXr4IMejKRY0e2MQ9Y"
        XCTAssertEqual(Profile.from(idToken), Profile.empty)
    }

}
