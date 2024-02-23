# Swift Sample Application

This sample application demonstrates the integration of the [Auth0.swift](https://github.com/auth0/Auth0.swift) SDK into a Swift iOS / macOS application. The sample is a companion to the [Auth0 Swift Quickstart](https://auth0.com/docs/quickstart/native/ios-swift).

## Requirements

- iOS 15+ / macOS 11+
- Xcode 14.x / 15.x

> [!NOTE]
> On iOS 17.4+ and macOS 14.4+ it is possible to use Universal Links as callback and logout URLs. Auth0.swift will fall back to using a custom URL scheme on older iOS / macOS versions.
>
> **This feature requires Xcode 15.3+ and a paid Apple Developer account**.
>
> If you do not have a paid Apple Developer account, skip steps **2.2** and **3**, and comment out the two `useHTTPS()` calls in `MainView.swift`.

## Configuration

### 1. Configure code signing

Open `SwiftSample.xcodeproj` in Xcode and go to the settings of the app target you want to run. There are two app targets available: **SwiftSample (iOS)** and **SwiftSample (macOS)**. In the **General** tab, change the default bundle identifier from `com.auth0.samples.SwiftSample` to another value of your choosing.

Then, ensure the **Automatically manage signing** box is checked, and that your Apple Team is selected.

### 2. Configure the Auth0 Application

> [!IMPORTANT]
> Make sure that the Auth0 application type is **Native**. Otherwise, you might run into errors due to the different configuration of other application types.

#### 2.1. Configure the callback and logout URLs

Go to the settings page of your [Auth0 application](https://manage.auth0.com/#/applications/) and add the corresponding URLs to **Allowed Callback URLs** and **Allowed Logout URLs**, according to the application target you want to run. If you have a [custom domain](https://auth0.com/docs/customize/custom-domains), replace `YOUR_AUTH0_DOMAIN` with your custom domain instead of the value from the settings page.

##### SwiftSample (iOS)

```text
https://YOUR_AUTH0_DOMAIN/ios/YOUR_BUNDLE_IDENTIFIER/callback,
YOUR_BUNDLE_IDENTIFIER://YOUR_AUTH0_DOMAIN/ios/YOUR_BUNDLE_IDENTIFIER/callback
```

##### SwiftSample (macOS)

```text
https://YOUR_AUTH0_DOMAIN/macos/YOUR_BUNDLE_IDENTIFIER/callback,
YOUR_BUNDLE_IDENTIFIER://YOUR_AUTH0_DOMAIN/macos/YOUR_BUNDLE_IDENTIFIER/callback
```

<details>
  <summary>Example</summary>

If your iOS bundle identifier were `com.example.MyApp` and your Auth0 Domain were `example.us.auth0.com`, then this value would be:

```text
https://example.us.auth0.com/ios/com.example.MyApp/callback,
com.example.MyApp://example.us.auth0.com/ios/com.example.MyApp/callback
```
</details>

#### 2.2. Configure the Team ID and bundle identifier

Scroll to the end of the settings page of your Auth0 application and open **Advanced Settings > Device Settings**. In the **iOS** section, set **Team ID** to your [Apple Team ID](https://developer.apple.com/help/account/manage-your-team/locate-your-team-id/), and **App ID** to the app's bundle identifier.

![Screenshot of the iOS section inside the Auth0 application settings page](https://github.com/auth0/Auth0.swift/assets/5055789/7eb5f6a2-7cc7-4c70-acf3-633fd72dc506)

This will add the app to your Auth0 tenant's `apple-app-site-association` file.

### 3. Configure the associated domain

In Xcode, go to the **Signing and Capabilities** tab of the app's target settings. Under **Associated Domains**, find the following entry:

```text
webcredentials:{YOUR_AUTH0_DOMAIN}
```

Replace the placeholder `{YOUR_AUTH0_DOMAIN}` value with the domain of your Auth0 application.

<details>
  <summary>Example</summary>

If your Auth0 Domain were `example.us.auth0.com`, then this value would be:

```text
webcredentials:example.us.auth0.com
```
</details>

If you have a [custom domain](https://auth0.com/docs/customize/custom-domains), replace `{YOUR_AUTH0_DOMAIN}` with your custom domain instead of the value from the settings page.

> [!NOTE]
> For the associated domain to work, the app must be signed with your team certificate **even when building for the iOS simulator**. Make sure you are using the Apple Team whose Team ID is configured in the settings page of your Auth0 application.

### 4. Configure Auth0.swift

Rename the `Auth0.plist.example` file to `Auth0.plist`, and replace the placeholder `{CLIENT_ID}` and `{DOMAIN}` values with the Client ID and domain of your Auth0 application. If you have a [custom domain](https://auth0.com/docs/customize/custom-domains), use it instead of the value from the settings page.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>ClientId</key>
    <string>{CLIENT_ID}</string>
    <key>Domain</key>
    <string>{DOMAIN}</string>
</dict>
</plist>
```

## Issue Reporting

For general support or usage questions, use the [Auth0 Community](https://community.auth0.com/tags/c/sdks/5/swift) forums or raise a [support ticket](https://support.auth0.com/). Only [raise an issue](https://github.com/auth0-samples/auth0-ios-swift-sample/issues) if you have found a bug or want to request a feature.

**Do not report security vulnerabilities on the public GitHub issue tracker.** The [Responsible Disclosure Program](https://auth0.com/responsible-disclosure-policy) details the procedure for disclosing security issues.

---

<p align="center">
  <picture>
    <source media="(prefers-color-scheme: light)" srcset="https://cdn.auth0.com/website/sdks/logos/auth0_light_mode.png" width="150">
    <source media="(prefers-color-scheme: dark)" srcset="https://cdn.auth0.com/website/sdks/logos/auth0_dark_mode.png" width="150">
    <img alt="Auth0 Logo" src="https://cdn.auth0.com/website/sdks/logos/auth0_light_mode.png" width="150">
  </picture>
</p>

<p align="center">Auth0 is an easy-to-implement, adaptable authentication and authorization platform. To learn more check out <a href="https://auth0.com/why-auth0">Why Auth0?</a></p>

<p align="center">This project is licensed under the MIT license. See the <a href="../LICENSE"> LICENSE</a> file for more info.</p>
