import JWTDecode

struct Profile {
    let id: String
    let email: String
    let picture: String
    let updatedAt: String

    static var empty: Self {
        return Profile(id: "", email: "", picture: "", updatedAt: "")
    }

    static func from(_ idToken: String) -> Self {
        let jwt = try! decode(jwt: idToken)
        return Profile(id: jwt.subject!,
                       email: jwt.claim(name: "email").string!,
                       picture: jwt.claim(name: "picture").string!,
                       updatedAt: jwt.claim(name: "updated_at").string!)
    }
}
