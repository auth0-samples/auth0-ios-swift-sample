# Custom Login 

- [Full Tutorial](https://auth0.com/docs/quickstart/native/ios-swift/02-custom-login)

This sample project shows how to make up a login and a sign up dialog by your own, by connecting to Auth0 services through the [Auth0.swift](https://github.com/auth0/Auth0.swift) toolkit.

You'll find two important view controllers here: The `LoginViewController` and the `SignUpViewController`, which contain text fields and buttons which are linked to actions that are described below.

#### Important Snippets

##### 1. Perform a Login

In `LoginViewController.swift`:

```swift
private func performLogin() {
    self.view.endEditing(true)
    self.loading = true
    Auth0
        .authentication()
        .login(
            usernameOrEmail: self.emailTextField.text!,
            password: self.passwordTextField.text!,
            connection: "Username-Password-Authentication"
        )
        .start { result in
            dispatch_async(dispatch_get_main_queue()) {
                self.loading = true
                switch result {
                case .Success(let credentials):
                    self.loginWithCredentials(credentials)
                case .Failure(let error):
                    self.showAlertForError(error)
            }
        }
    }
}
```

##### 2. Pass the credentials object

The `credentials` instance is used to retrieve the profile in the next screen, that is to say, in the `ProfileViewController`.

So, in `LoginViewController.swift`...

First, the segue is performed, saving the credentials to an instance variable:

```swift
private func loginWithCredentials(credentials: Credentials) {
    self.retrievedCredentials = credentials
    self.performSegueWithIdentifier("ShowProfile", sender: nil)
}
```
Then, the retrieved credentials are passed to the `ProfileViewController`: 

```swift
override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    guard let profileViewController = segue.destinationViewController as? ProfileViewController else {
        return
    }
    profileViewController.loginCredentials = self.retrievedCredentials!
}
```

##### 3. Retrieve the user profile with his credentials

In `ProfileViewController.swift`, once it's got the credentials:

```swift
private func retrieveProfile() {
    guard let idToken = loginCredentials.idToken else {
        self.showErrorRetrievingProfileAlert()
        self.navigationController?.popViewControllerAnimated(true)
        return
    }
    Auth0
        .authentication()
        .tokenInfo(token: idToken)
        .start { result in
            switch result {
            case .Success(let profile):
                self.welcomeLabel.text = "Welcome, \(profile.name)"
                self.retrieveDataFromURL(profile.pictureURL) { data, response, error in
                    dispatch_async(dispatch_get_main_queue()) {
                        guard let data = data where error == nil else { return }
                        self.avatarImageView.image = UIImage(data: data)
                    }
                }
            case .Failure(let error):
                self.showAlertForError(error)
            }
    }
}
```

##### 4. Perform a Sign Up

In `SignUpViewController.swift`:

```swift
private func performRegister() {
    self.view.endEditing(true)
    self.loading = true
    Auth0
        .authentication()
        .signUp(
            email: self.emailTextField.text!,
            password: self.passwordTextField.text!,
            connection: "Username-Password-Authentication",
            userMetadata: ["first_name": self.firstNameTextField.text!,
                "last_name": self.lastNameTextField.text!]
        )
        .start { result in
            dispatch_async(dispatch_get_main_queue()) {
                self.loading = false
                switch result {
                case .Success(let credentials):
                    self.retrievedCredentials = credentials
                    self.performSegueWithIdentifier("DismissSignUp", sender: nil)
                case .Failure(let error):
                    self.showAlertForError(error)
                }
            }
    }
}
```

Notice that the credentials are stored in the `retrievedCredentials` instance variable.

##### 5. Hook up Login and Sign Up navigation

Once someone has signed up, the `SignUpViewController` is dismissed, and the `LoginViewController` takes the control. Through an [unwind segue](https://www.youtube.com/watch?v=akmPXZ4hDuU), the `LoginViewController` automatically logs the user in with the credentials he's just got upon registering.

In `LoginViewController.swift`:

```swift
@IBAction func unwindToLogin(segue: UIStoryboardSegueWithCompletion) {
    guard let
    controller = segue.sourceViewController as? SignUpViewController,
    credentials = controller.retrievedCredentials
    else { return  }
    segue.completion = {
        self.loginWithCredentials(credentials)
    }
}
```

Notice how the `retrievedCredentials` mentioned in the step 4 are used here.

##### 6. Perform Social Authentication using webauth

In order to get credentials from a social provider, whether it's for sign in or sign up purposes, you present the user a webauth social authentication dialog by just using this snippet, which you can get from `LoginViewController.swift`:

```swift
private func performFacebookAuthentication() {
    self.view.endEditing(true)
    self.loading = true
    Auth0
        .webAuth()
        .connection("facebook")
        .scope("openid")
        .start { result in
            dispatch_async(dispatch_get_main_queue()) {
                self.loading = false
                switch result {
                case .Success(let credentials):
                    self.loginWithCredentials(credentials)
                case .Failure(let error):
                    self.showAlertForError(error)
                }
            }
    }
}
```

Replace `"facebook"` with any social provider that you need (as long as it appears in [Auth0 identity providers](https://auth0.com/docs/identityproviders)).





