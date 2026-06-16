# Auth0 iOS / macOS / visionOS Swift Sample — Login

A minimal SwiftUI app showing login, signup, session persistence, and logout with [Auth0.swift](https://github.com/auth0/Auth0.swift). The session is renewed on launch via a refresh token (requested with the `offline_access` scope), so it survives past ID token expiry.

The same target builds for iOS, macOS, and visionOS — the SwiftUI code is platform-agnostic. Auth0.swift derives the callback path segment from the build target at runtime (`/ios/`, `/macos/`, or `/visionos/`), so register the URLs for the platform(s) you ship.

## Requirements

- Xcode 16+
- iOS 16.0+ / macOS 11.0+ / visionOS 1.0+

## Setup

1. Configure your credentials (writes `Auth0.plist` and sets the bundle identifier):

   ```bash
   swift quickstart/Configure.swift \
     --domain YOUR_DOMAIN \
     --client-id YOUR_CLIENT_ID \
     --bundle-id com.example.MyApp
   ```

2. Add these to your Auth0 application's **Allowed Callback URLs** and **Allowed Logout URLs**. Replace `{platform}` with `ios`, `macos`, or `visionos` to match your build target (Auth0.swift picks the segment automatically per platform):

   ```text
   com.example.MyApp://YOUR_DOMAIN/{platform}/com.example.MyApp/callback
   ```

3. Open the project and run:

   ```bash
   open auth0-ios-sample.xcodeproj
   ```

   Xcode resolves the Auth0.swift Swift Package automatically.

## Callback URL: custom scheme vs Universal Links

By default the app uses a **custom URL scheme** callback (`{bundleId}://...`), captured automatically by `ASWebAuthenticationSession`. No `Info.plist` URL scheme entry is needed and no paid Apple Developer account is required.

### Why two callback URLs (when using Universal Links)?

The default setup (above) registers only the custom-scheme URL. When you enable Universal Links you must register **both** URLs — and they are **not** redundant. With `UseHTTPS` enabled, Auth0.swift picks the redirect scheme at runtime: it uses the `https://` Universal Link on iOS 17.4+ / macOS 14.4+ and **automatically falls back** to the `{bundleId}://` custom scheme on older versions. A single build can hit either, so both must be registered as Allowed Callback / Logout URLs (`{platform}` is `ios`, `macos`, or `visionos`):

```text
https://YOUR_DOMAIN/{platform}/com.example.MyApp/callback
com.example.MyApp://YOUR_DOMAIN/{platform}/com.example.MyApp/callback
```

With `UseHTTPS` off (the default), only the custom-scheme URL is ever used.

### Using Universal Links (optional, requires a paid Apple Developer account)

Universal Links are more secure than custom URL schemes but need extra setup. Run the configure command with your Apple Team ID:

```bash
swift quickstart/Configure.swift \
  --domain YOUR_DOMAIN \
  --client-id YOUR_CLIENT_ID \
  --bundle-id com.example.MyApp \
  --team-id YOUR_TEAM_ID
```

This sets `UseHTTPS=true` in `Auth0.plist`. The command then prints the remaining **manual** steps (Xcode signing, the **Associated Domains** capability `webcredentials:YOUR_DOMAIN`, and the Auth0 Dashboard **Advanced > Device Settings**), because those cannot be scripted. Universal Links require iOS 17.4+ / macOS 14.4+; older versions fall back to the custom scheme automatically.

> **macOS:** the app runs sandboxed (`auth0-ios-sample.entitlements` enables App Sandbox + the outbound network client entitlement required for the web-auth session). Keep both entitlements when shipping a macOS build.
