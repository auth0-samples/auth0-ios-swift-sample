import SwiftUI
import Auth0

struct MainView: View {
    @StateObject private var auth = AuthenticationService()

    var body: some View {
        if let user = auth.user {
            VStack {
                ProfileView(user: user)
                Button("Logout") {
                    Task { await auth.logout() }
                }
            }
        } else {
            VStack {
                HeroView()
                Button("Login") {
                    Task { await auth.login() }
                }
            }
        }
    }
}

@MainActor
final class AuthenticationService: ObservableObject {
    @Published var user: User?
    private let credentialsManager = CredentialsManager(authentication: Auth0.authentication())

    init() {
        guard credentialsManager.canRenew() else { return }
        Task { await loadStoredUser() }
    }

    func login() async {
        do {
            let credentials = try await Auth0
                .webAuth()
                .useHTTPS()
                .scope("openid profile email offline_access")
                .start()
            _ = credentialsManager.store(credentials: credentials)
            user = User(from: credentials.idToken)
        } catch WebAuthError.userCancelled {
            return
        } catch {
            print("Login failed: \(error)")
        }
    }

    func logout() async {
        do {
            try await Auth0.webAuth().useHTTPS().clearSession()
        } catch {
            print("Logout failed: \(error)")
        }
        _ = credentialsManager.clear()
        user = nil
    }

    private func loadStoredUser() async {
        do {
            let credentials = try await credentialsManager.credentials()
            user = User(from: credentials.idToken)
        } catch {
            user = nil
        }
    }
}
