import SwiftUI
import Auth0

struct MainView: View {
    @State var profile = Profile.empty
    @State var loggedIn = false

    var body: some View {
        if loggedIn {
            VStack {
                ProfileView(profile: self.$profile)
                Button("Logout", action: self.login)
            }
        } else {
            VStack {
                HeroView()
                Button("Login", action: self.logout)
            }
        }
    }

    func login() {
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

    func logout() {
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
