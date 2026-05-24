# Auth0 Swift setup checklist (HTTPS Universal Links)

This sample has been prepared to use `Auth0.swift` with:
- SDK version floor `2.19.0` (SPM requirement in `SwiftSample.xcodeproj`)
- `Auth0.plist` scaffold (`Sample-01/Auth0.plist`)
- HTTPS callback flow (`.useHTTPS()`) and `CredentialsManager`-based session handling

## 1) Fill `Auth0.plist`

Update:
- `ClientId` -> your Auth0 Native app client ID
- `Domain` -> your Auth0 tenant domain (for example `tenant.eu.auth0.com`)

## 2) Auth0 dashboard callback/logout URLs

Bundle ID extracted from project: `com.auth0.samples.SwiftSample`

Allowed Callback URLs:
- `https://YOUR_AUTH0_DOMAIN/ios/com.auth0.samples.SwiftSample/callback`
- `com.auth0.samples.SwiftSample://YOUR_AUTH0_DOMAIN/ios/com.auth0.samples.SwiftSample/callback`

Allowed Logout URLs:
- `https://YOUR_AUTH0_DOMAIN/ios/com.auth0.samples.SwiftSample/callback`
- `com.auth0.samples.SwiftSample://YOUR_AUTH0_DOMAIN/ios/com.auth0.samples.SwiftSample/callback`

## 3) Universal Links entitlement

The iOS entitlements file includes placeholders:
- `applinks:YOUR_AUTH0_DOMAIN`
- `webcredentials:YOUR_AUTH0_DOMAIN`

Replace `YOUR_AUTH0_DOMAIN` with your real Auth0 domain.

## 4) Device settings for Universal Links in Auth0

In Auth0 app settings, configure:
- iOS Team ID
- iOS App Bundle Identifier = `com.auth0.samples.SwiftSample`

## 5) Build command (run on macOS with Xcode)

```bash
xcodebuild build -scheme "SwiftSample (iOS)" -destination "platform=iOS Simulator,name=iPhone 16"
```
