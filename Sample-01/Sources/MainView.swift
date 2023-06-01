import SwiftUI
import Auth0
import DeviceCheck

struct MainView: View {
    @State var user: User?

    var body: some View {
        if let user = self.user {
            VStack {
                ProfileView(user: user)
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
        Task {
            guard let dcToken = await deviceCheckToken()?.base64EncodedString() else {
                return print("Failed to get Device Token!")
            }
            
            print(dcToken)

            do {
                let credentials = try await Auth0.webAuth().parameters(["dc_token": dcToken]).start()
                self.user = User(from: credentials.idToken)
            } catch {
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

    func deviceCheckToken() async -> Data? {
        guard DCDevice.current.isSupported else { return nil }
        return try? await DCDevice.current.generateToken()
    }

}
