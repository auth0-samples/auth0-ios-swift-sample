import SwiftUI
import Auth0

let credentialsManager = CredentialsManager(authentication: Auth0.authentication())

struct MainView: View {
    @State var isLoggedIn: Bool

    var body: some View {
        VStack {
            if self.isLoggedIn {
                Text("Logged in!")
                Button("Logout", action: self.logout)
            } else {
                Text("Not logged in")
                Button("Login", action: self.login)
            }
        }.onAppear(perform: self.checkLogin)
    }
}

extension MainView {
    func checkLogin() {
        guard credentialsManager.canRenew() else {
            return print("No renewable credentials exist")
        }
        credentialsManager.credentials { result in
            switch result {
            case .success:
                print("User is already logged in")
            case .failure(let error):
                print("Credentials retrieval failed with: \(error)")
            }
        }
        self.isLoggedIn = true
    }

    func login() {
        Auth0
            .webAuth()
            .scope("openid profile email offline_access")
            .start { result in
                switch result {
                case .success(let credentials):
                    self.isLoggedIn = true
                    let didStoreCredentials = credentialsManager.store(credentials: credentials)
                    print("Logged in\nStored credentials? \(didStoreCredentials)")
                case .failure(let error):
                    print("Login failed with: \(error)")
                }
            }
    }

    func logout() {
        Auth0
            .webAuth()
            .clearSession { result in
                switch result {
                case .success:
                    self.isLoggedIn = false
                    let didClearCredentials = credentialsManager.clear()
                    print("Logged out\nCleared credentials? \(didClearCredentials)")
                case .failure(let error):
                    print("Logout failed with: \(error)")
                }
            }
    }
}
