# Auth0 iOS / Swift Sample — Login

A minimal SwiftUI app showing login, signup, session persistence, and logout with [Auth0.swift](https://github.com/auth0/Auth0.swift).

## Requirements

- Xcode 16+
- iOS 16.0+
- An Auth0 **Native** application

## Setup

1. Configure your credentials (writes `Auth0.plist` and sets the bundle identifier):

   ```bash
   ./quickstart/scripts/configure.sh \
     --domain YOUR_DOMAIN \
     --client-id YOUR_CLIENT_ID \
     --bundle-id com.example.MyApp
   ```

2. Add these to your Auth0 application's **Allowed Callback URLs** and **Allowed Logout URLs**:

   ```text
   com.example.MyApp://YOUR_DOMAIN/ios/com.example.MyApp/callback
   ```

3. Open the project and run:

   ```bash
   open auth0-ios-sample.xcodeproj
   ```

   Xcode resolves the Auth0.swift Swift Package automatically.

## Callback URL: custom scheme vs Universal Links

By default the app uses a **custom URL scheme** callback (`{bundleId}://...`), captured automatically by `ASWebAuthenticationSession`. No `Info.plist` URL scheme entry is needed and no paid Apple Developer account is required.

To use a **Universal Link** callback instead (more secure; iOS 17.4+), add `.useHTTPS()` to the login and logout calls in `ContentView.swift`, set your Team ID and bundle identifier under the application's **Advanced Settings > Device Settings**, add the **Associated Domains** capability (`webcredentials:YOUR_DOMAIN`), and use the `https://YOUR_DOMAIN/ios/.../callback` URLs. This requires a paid Apple Developer account.
