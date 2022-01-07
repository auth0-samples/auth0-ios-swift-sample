# Swift Sample Application

This sample application demonstrates the integration of the [Auth0.swift](https://github.com/auth0/Auth0.swift/tree/beta) SDK into a Swift iOS / macOS application. The sample is a companion to the [Auth0 Swift Quickstart](https://auth0.com/docs/quickstart/native/ios-swift/00-login).

## Requirements

- iOS 12+ / macOS 10.15+
- Xcode 13.x

## Configuration

### Configure Bundle Identifier

Open `SwiftSample.xcodeproj` in Xcode and go to the settings of the application target you want to run. Change the default bundle identifier from `com.auth0.samples.SwiftSample` to another value of your choosing.

There are two application targets available: **SwiftSample (iOS)** for the iOS sample and **SwiftSample (macOS)** for the macOS sample. 

### Configure Auth0 Application

Go to the settings page of your [Auth0 application](https://manage.auth0.com/#/applications/) and add the following value to **Allowed Callback URLs** and **Allowed Logout URLs**, according to the platform of your application.

#### iOS

```text
YOUR_BUNDLE_IDENTIFIER://YOUR_AUTH0_DOMAIN/ios/YOUR_BUNDLE_IDENTIFIER/callback
```

#### macOS

```text
YOUR_BUNDLE_IDENTIFIER://YOUR_AUTH0_DOMAIN/macos/YOUR_BUNDLE_IDENTIFIER/callback
```

E.g. if your iOS bundle identifier was `com.company.myapp` and your Auth0 Domain was `company.us.auth0.com`, then this value would be:

```text
com.company.myapp://company.us.auth0.com/ios/com.company.myapp/callback
```

> ⚠️ Make sure that the [application type](https://auth0.com/docs/configure/applications) of the Auth0 application is **Native**. If you don’t have a Native Auth0 application, [create one](https://auth0.com/docs/get-started/create-apps/native-apps) before continuing.

### Configure Auth0.swift

Back in Xcode, rename the `Auth0.plist.example` file to `Auth0.plist`, and replace the placeholder `{CLIENT_ID}` and `{DOMAIN}` values with the Client ID and Domain of your Auth0 application. If you are using a [Custom Domain](https://auth0.com/docs/brand-and-customize/custom-domains), use the value of your Custom Domain instead of the value from the settings page.

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

## What is Auth0?

Auth0 helps you to:

* Add authentication with [multiple sources](https://auth0.com/docs/connections), either social identity providers such as **Google, Facebook, Microsoft Account, LinkedIn, GitHub, Twitter, Box, Salesforce** (amongst others), or enterprise identity systems like **Windows Azure AD, Google Apps, Active Directory, ADFS, or any SAML Identity Provider**.
* Add authentication through more traditional **[username/password databases](https://auth0.com/docs/connections/database/custom-db)**.
* Add support for **[linking different user accounts](https://auth0.com/docs/users/user-account-linking)** with the same user.
* Support for generating signed [JSON Web Tokens](https://auth0.com/docs/security/tokens/json-web-tokens) to call your APIs and **flow the user identity** securely.
* Analytics of how, when, and where users are logging in.
* Pull data from other sources and add it to the user profile through [JavaScript actions](https://auth0.com/docs/actions).

**Why Auth0?** Because you should save time, be happy, and focus on what really matters: building your product.

## License

This project is licensed under the MIT license. See the [LICENSE](../LICENSE) file for more information.
