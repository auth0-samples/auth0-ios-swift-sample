# Touch ID Authentication

Here's the scenario: You are using `webAuth` to present the HLP for the user to Login. After user authentication you want to store the user's credentials and use the `refreshToken` to renew the user's credentials without having to present the HLP. Additionally you want to utilize Touch ID to validate this renewal process.

You will to be using the [Credentials Manager](https://github.com/auth0/Auth0.swift/blob/master/Auth0/CredentialsManager.swift) utility in [Auth0.swift](https://github.com/auth0/Auth0.swift/) to streamline the management of user credentials and Touch ID.

[Touch ID Authentication Tutorial](https://auth0.com/docs/quickstart/native/ios-swift/08-touch-id-authentication)

## Additional Requirements:
- Touch ID Enrolled Device