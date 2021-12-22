import SwiftUI
import Auth0
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

struct ProfileView: View {
    @Binding var profile: Profile

    var body: some View {
        AsyncImage(url: URL(string: profile.picture))
        Text(profile.id)
        Text(profile.email)
        Text(profile.updatedAt)
    }
}

struct ContentView: View {
    @State var profile = Profile.empty
    @State var loggedIn = false

    var body: some View {
        if loggedIn {
            VStack(spacing: 24) {
                ProfileView(profile: self.$profile)
                Button("Logout") {
                    Auth0
                        .webAuth()
                        .clearSession { result in
                            switch result {
                            case .success:
                                self.loggedIn = false
                            case .failure(let error):
                                print("Failed with: \(error)")
                            }
                        }
                }
            }
        } else {
            Button("Login") {
                Auth0
                    .webAuth()
                    .start { result in
                        switch result {
                        case .success(let credentials):
                            self.profile = Profile.from(credentials.idToken)
                            self.loggedIn = true
                        case .failure(let error):
                            print("Failed with: \(error)")
                        }
                    }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
