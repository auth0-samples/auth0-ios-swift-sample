# Login 

- [Full Tutorial](https://auth0.com/docs/quickstart/native/ios-swift/01-login)

This sample project shows how to present a login dialog using the Lock widget interface. Once you log in, you're taken to a very basic profile screen, with some data about your user.

#### Important Snippets

##### 1. Present the login widget

In `HomeViewController.swift`:

```swift
@IBAction func showLoginController(sender: UIButton) {
    let controller = A0Lock.sharedLock().newLockViewController()
    controller.closable = true
    controller.onAuthenticationBlock = { profile, token in
        guard let userProfile = profile else {
            self.showMissingProfileAlert()
            return
        }
        self.retrievedProfile = userProfile
        controller.dismissViewControllerAnimated(true, completion: nil)
        self.performSegueWithIdentifier("ShowProfile", sender: nil)
    }
    A0Lock.sharedLock().presentLockController(controller, fromController: self)
}
```

##### 2. Pass the profile object

In this sample, the `profile` object is passed to the next screen through a variable, in the `prepareForSegue` method, as follows:

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let profileController = segue.destinationViewController as? ProfileViewController else {
            return
        }
        profileController.profile = self.retrievedProfile
    }
This is a very simple approach to do so. You'll find later on, in further sample projects, that this strategy is replaced by using a `SessionManager` class, which avoids updating inconsistencies among view controllers.

##### 3. Show basic profile data

In `ProfileViewController.swift`:

```swift
override func viewDidLoad() {
    super.viewDidLoad()
    self.welcomeLabel.text = "Welcome, \(self.profile.name)"
    NSURLSession.sharedSession().dataTaskWithURL(self.profile.picture, completionHandler: { data, response, error in
        dispatch_async(dispatch_get_main_queue()) {
            guard let data = data where error == nil else { return }
            self.avatarImageView.image = UIImage(data: data)
        }
    }).resume()
}
```

