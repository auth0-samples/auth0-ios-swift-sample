import SwiftUI
import Auth0

struct ContentView: View {
    /* highlight-start account-setup */
    // Stores credentials in the Keychain so the session survives app restarts.
    private let credentialsManager = CredentialsManager(authentication: Auth0.authentication())

    // The user profile is read straight from the stored ID token's claims.
    @State private var user: UserInfo?
    @State private var isLoading = true
    @State private var errorMessage: String?
    /* highlight-end account-setup */

    /* highlight-start use-universal-links */
    private static let useUniversalLinks: Bool = {
        guard let path = Bundle.main.path(forResource: "Auth0", ofType: "plist"),
              let values = NSDictionary(contentsOfFile: path) else {
            return false
        }
        return values["CallbackMode"] as? String == "universal-links"
    }()

    private func webAuth() -> WebAuth {
        let webAuth = Auth0.webAuth()
        return Self.useUniversalLinks ? webAuth.useHTTPS() : webAuth
    }
    /* highlight-end use-universal-links */

    var body: some View {
        VStack(spacing: 16) {
            if isLoading {
                Text("Loading...")
            } else if let user {
                Text("Logged in as \(user.email ?? "unknown")")
                    .font(.title)
                VStack(alignment: .leading, spacing: 4) {
                    Text("sub: \(user.sub)")
                    Text("name: \(user.name ?? "")")
                    Text("email: \(user.email ?? "")")
                    Text("email_verified: \(user.emailVerified.map(String.init) ?? "")")
                    Text("nickname: \(user.nickname ?? "")")
                    Text("picture: \(user.picture?.absoluteString ?? "")")
                }
                .font(.body)
                Button("Log Out", action: logout)
                    .font(.title3)
            } else {
                Button("Sign Up") { login(screenHint: "signup") }
                    .font(.title3)
                Button("Log In") { login() }
                    .font(.title3)
                Text(Self.useUniversalLinks
                     ? "Using HTTPS (Universal Links) for callbacks"
                     : "Using custom URL scheme for callbacks")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
            if let errorMessage {
                Text(errorMessage).foregroundColor(.red).font(.callout)
            }
        }
        .padding(.horizontal, 16)
        /* highlight-start credentials-manager */
        // Renew the session from the Keychain on launch. `credentials()` uses the
        // stored refresh token to silently renew an expired access token (and stores
        // the result), so the session survives past ID token expiry. `user` is read
        // from the returned credentials' ID token claims.
        .onAppear {
            guard credentialsManager.canRenew() else {
                isLoading = false
                return
            }
            credentialsManager.credentials { result in
                if case .success = result {
                    user = credentialsManager.user
                }
                isLoading = false
            }
        }
        /* highlight-end credentials-manager */
    }

    /* highlight-start login */
    private func login(screenHint: String? = nil) {
        errorMessage = nil
        var webAuth = webAuth()
            .scope("openid profile email offline_access")
        if let screenHint {
            webAuth = webAuth.parameters(["screen_hint": screenHint])
        }
        webAuth.start { result in
            switch result {
            case .success(let credentials):
                errorMessage = nil
                _ = credentialsManager.store(credentials: credentials)
                user = credentialsManager.user
            case .failure(let error):
                errorMessage = error.localizedDescription
                print("Login failed: \(error)")
            }
        }
    }
    /* highlight-end login */

    /* highlight-start logout */
    private func logout() {
        errorMessage = nil
        webAuth()
            .clearSession { result in
                switch result {
                case .success:
                    errorMessage = nil
                    _ = credentialsManager.clear()
                    user = nil
                case .failure(let error):
                    errorMessage = error.localizedDescription
                    print("Logout failed: \(error)")
                }
            }
    }
    /* highlight-end logout */
}
