import SwiftUI
import Auth0

@main
struct SwiftSampleApp: App {
    var body: some Scene {
        WindowGroup {
            MainView(isLoggedIn: false)
            #if os(iOS)
                .buttonStyle(PrimaryButtonStyle())
            #else
                .padding(.bottom, 32)
                .frame(maxWidth: 400, maxHeight: 300)
            #endif
        }
    }
}
