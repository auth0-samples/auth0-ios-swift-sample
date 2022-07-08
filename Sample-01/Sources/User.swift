import JWTDecode

struct User {
    let id: String
    let name: String
    let email: String
    let emailVerified: String
    let picture: String
    let updatedAt: String
}

extension User {
    init?(from idToken: String) {
        guard let jwt = try? decode(jwt: idToken),
              let id = jwt.subject,
              let name = jwt.claim(name: "name").string,
              let email = jwt.claim(name: "email").string,
              let emailVerified = jwt.claim(name: "email_verified").boolean,
              let picture = jwt.claim(name: "picture").string,
              let updatedAt = jwt.claim(name: "updated_at").string else {
            return nil
        }
        self.id = id
        self.name = name
        self.email = email
        self.emailVerified = String(describing: emailVerified)
        self.picture = picture
        self.updatedAt = updatedAt
    }
}
