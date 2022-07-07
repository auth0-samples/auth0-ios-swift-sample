import SwiftUI
import Auth0

struct MainView: View {
    @State var user: User?

    var body: some View {
        if let userBinding = Binding(self.$user) {
            VStack {
                ProfileView(user: userBinding)
                Button("Logout", action: self.logout)
            }
        } else {
            VStack {
                HeroView()
                Button("Login", action: self.login)
            }
        }
    }
}

extension MainView {
    func login() {
        Auth0
            .webAuth()
            .start { result in
                switch result {
                case .success(let credentials):
                    self.user = User(from: credentials.idToken)
                case .failure(let error):
                    print("Failed with: \(error)")
                }
            }
    }

    func logout() {
        Auth0
            .webAuth()
            .clearSession { result in
                switch result {
                case .success:
                    self.user = nil
                case .failure(let error):
                    print("Failed with: \(error)")
                }
            }
    }
}
