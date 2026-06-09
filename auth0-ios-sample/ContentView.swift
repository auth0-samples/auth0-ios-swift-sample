import SwiftUI
import Auth0

struct ContentView: View {
    /* highlight-start account-setup */
    // CredentialsManager encrypts credentials (access token, ID token, refresh
    // token) in the Keychain and restores them on app restart, so users stay
    // logged in between sessions.
    private let credentialsManager = CredentialsManager(authentication: Auth0.authentication())

    @State private var profile: Profile?
    @State private var isLoading = true
    @State private var errorMessage: String?
    /* highlight-end account-setup */

    var body: some View {
        VStack(spacing: 16) {
            if isLoading {
                Text("Loading...")
            } else if let profile {
                Text("Logged in as \(profile.email ?? "unknown")")
                    .font(.title3)
                VStack(alignment: .leading, spacing: 4) {
                    Text("sub: \(profile.sub ?? "")")
                    Text("name: \(profile.name ?? "")")
                    Text("email: \(profile.email ?? "")")
                    Text("email_verified: \(profile.emailVerified.map(String.init) ?? "")")
                    Text("nickname: \(profile.nickname ?? "")")
                    Text("picture: \(profile.picture ?? "")")
                }
                .font(.footnote)
                Button("Log Out", action: logout)
            } else {
                Button("Sign Up") { login(screenHint: "signup") }
                Button("Log In") { login() }
            }
            if let errorMessage {
                Text(errorMessage).foregroundColor(.red).font(.caption)
            }
        }
        .padding(.horizontal, 16)
        /* highlight-start credentials-manager */
        // Restore the session from the Keychain on launch; refreshes the access
        // token if it has expired.
        .task {
            guard credentialsManager.hasValid() else { isLoading = false; return }
            do {
                let credentials = try await credentialsManager.credentials()
                profile = Profile(idToken: credentials.idToken)
            } catch {
                print("Failed to restore credentials: \(error)")
            }
            isLoading = false
        }
        /* highlight-end credentials-manager */
    }

    /* highlight-start login */
    private func login(screenHint: String? = nil) {
        var webAuth = Auth0
            .webAuth()
            // offline_access: requests a refresh token for session persistence
            .scope("openid profile email offline_access")
        // To use a Universal Link callback URL (iOS 17.4+, requires a paid Apple
        // Developer account and an associated domain), add: .useHTTPS()
        if let screenHint {
            webAuth = webAuth.parameters(["screen_hint": screenHint])
        }
        webAuth.start { result in
            switch result {
            case .success(let credentials):
                _ = credentialsManager.store(credentials: credentials)
                profile = Profile(idToken: credentials.idToken)
            case .failure(let error):
                errorMessage = error.localizedDescription
                print("Login failed: \(error)")
            }
        }
    }
    /* highlight-end login */

    /* highlight-start logout */
    private func logout() {
        Auth0
            .webAuth()
            .clearSession { result in
                switch result {
                case .success:
                    _ = credentialsManager.clear()
                    profile = nil
                case .failure(let error):
                    errorMessage = error.localizedDescription
                    print("Logout failed: \(error)")
                }
            }
    }
    /* highlight-end logout */
}
