# User Profile 

- [Full Tutorial](https://auth0.com/docs/quickstart/native/ios-swift/04-user-profile)

This sample demonstrates how to retrieve an Auth0 user's profile and how to update it using the [Auth0.swift](https://github.com/auth0/Auth0.swift) toolkit. Session management strategies implemented in this project are explained in the [session handling sample project](/03-Session-Handling).

Not to be confused, there are two different profile screens in this project: One is `ProfileViewController`, which is the same screen we've been using in previous samples, that only contains basic profile data; whereas the other one is `FullProfileViewController`, which is a more advanced screen containing extra data that's added to the user profile and can be modified and updated.

The idea of this sample is to show how to modify and update that additional data, which corresponds to the `userMetadata` dictionary in the `A0UserProfile` class.

#### Important Snippets

##### 1. Retrieve the user profile

Check out the [two ways of getting it](/03-Session-Handling/).

##### 2. Update the user metadata

In `FullProfileViewController.swift`:

```swift
@IBAction func save(sender: UIBarButtonItem) {
    self.view.endEditing(true)
    let loadingAlert = UIAlertController.loadingAlert()
    loadingAlert.presentInViewController(self)
    SessionManager().retrieveSession { session in
        Auth0
            .users(token: session!.token.idToken)
            .patch(session!.profile.userId, userMetadata:
                ["first_name": self.firstNameTextField.text!,
                    "last_name": self.lastNameTextField.text!,
                    "country": self.countryTextField.text!])
            .start { result in
                dispatch_async(dispatch_get_main_queue()) {
                    loadingAlert.dismiss()
                    switch result {
                    case .Success(let value):
                        // update the profile locally
                        let updatedProfile = A0UserProfile(dictionary: value)
                        SessionManager().saveProfile(updatedProfile)
                        self.profile = updatedProfile
                        let successAlert = UIAlertController.alertWithTitle(nil, message: "Successfully updated profile!")
                        successAlert.presentInViewController(self, dismissAfter: 1.0)
                    case .Failure(let error):
                        let failureAlert = UIAlertController.alertWithTitle("Error", message: String(error), includeDoneButton: true)
                        failureAlert.presentInViewController(self)
                    }
                }
        }
    }
}
```

Notice the comment `// update the profile locally`. 

Once the profile is updated, the function callback returns its corresponding data (up-to-date) through the variable named `value` within the `.Success` case. That data can be easily turned into a `A0UserProfile` instance by using it's initializer with `dictionary`. In order to display the latest profile version, we:

- Create a `A0UserProfile` instance based on that data held in `value`.
- Save that created profile into the `SessionManager` class, so that it keeps cached, through its `saveProfile` method.
- Update the `self.profile` instance variable with the latest version.