import SwiftUI
import Auth0

struct ContentView: View {
    @State var profile = Profile.empty
    @State var loggedIn = false

    var body: some View {
        if loggedIn {
            VStack(spacing: 32) {
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
