# Calling APIs 

- [Full Tutorial](https://auth0.com/docs/quickstart/native/ios-swift/08-calling-apis)

The idea of this project is to perform authenticated requests by attaching the `idToken`, obtained upon login, into an authorization header.

This sample can be seen as a template where you'll have to set your own stuff in order to get it working. Pay attention to the snippets where you have to do that.

Also, you will need a server that accepts authenticated APIs with an endpoint capable of checking whether or not a request has been properly authenticated. You can use your own or [this nodeJS one](https://github.com/auth0-samples/auth0-angularjs2-systemjs-sample/tree/master/Server), whose setup is quite simple.

#### Important Snippets

##### 1. Call your API

The only important snippet you need to be aware of: making up an authenticathed request for your API!

Look at `ProfileViewController.swift`:

```swift
private func callAPI(authenticated shouldAuthenticate: Bool) {
    let url = NSURL(string: "your api url")!
    let request = NSMutableURLRequest(URL: url)
    // Configure your request here (method, body, etc)
    if shouldAuthenticate {
        let token = SessionManager().storedSession!.token.idToken
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    }
    let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
        dispatch_async(dispatch_get_main_queue()) {
            let title = "Results"
            let message = "Error: \(String(error))\n\nData: \(data == nil ? "nil" : "(there is data)")\n\nResponse: \(String(response))"
            let alert = UIAlertController.alertWithTitle(title, message: message, includeDoneButton: true)
            self.presentViewController(alert, animated: true, completion: nil)
            
        }
    }
    task.resume()
}
```

These are the specific lines of code that you have to configure:

First, set your API url here:

```swift
let url = NSURL(string: "your api url")!
```

Then, add any extra configuration that your API might require for your requests:

```swift
// Configure your request here (method, body, etc)
```

Then, pay attention to how the header is made up:

```swift
request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
```

That string interpolation might vary depending on the standards that your API follows. The one showed in the sample corresponds to OAuth2 standards.

Also, this line is important:

```swift
let token = SessionManager().storedSession!.token.idToken
```

That specifies that the `idToken` is the token that you're using for authentication. You might want to choose using a different one (for example, the `accessToken`), it depends on how your API checks the authentication against Auth0.

> For further information on the authentication process, check out [the full documentation](https://auth0.com/docs/api/authentication).