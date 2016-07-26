# Authorization 

The guts of this topic is actually found in the [full tutorial](https://auth0.com/docs/quickstart/native/ios-swift/07-authorization), where it's exposed how to configure a rule from the Auth0 management website.

However, this sample project does contain a snippet that might be of your interest.

#### Important Snippets

##### 1. Check the user role

Look at `ProfileViewController.swift`:

```swift
@IBAction func checkUserRole(sender: UIButton) {
    guard let roles = self.profile.appMetadata["roles"] as? [String] else {
        self.showErrorRetrievingRolesAlert()
        return
    }
    if roles.contains("admin") {
        self.showAdminPanel()
    } else {
        self.showAccessDeniedAlert()
    }
}
```
