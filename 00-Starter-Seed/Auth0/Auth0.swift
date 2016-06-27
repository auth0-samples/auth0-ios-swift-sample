// Auth0.swift
//
// Copyright (c) 2016 Auth0 (http://auth0.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation

/**
 Auth0 Authentication API to authenticate your user using a Database, Social, Enterprise or Passwordless connections

 ```
 Auth0.authentication(clientId: clientId, domain: "samples.auth0.com")
 ```

 - parameter clientId: clientId of your Auth0 client/application
 - parameter domain:   domain of your Auth0 account. e.g.: 'samples.auth0.com'
 - parameter session:  instance of NSURLSession used for networking. By default it will use the shared NSURLSession

 - returns: Auth0 Authentication API
 */
public func authentication(clientId clientId: String, domain: String, session: NSURLSession = .sharedSession()) -> Authentication {
    return Authentication(clientId: clientId, url: .a0_url(domain), session: session)
}

/**
 Auth0 Authentication API to authenticate your user using a Database, Social, Enterprise or Passwordless connections.

 ```
 Auth0.authentication()
 ```

 Auth0 clientId & domain are loaded from the file `Auth0.plist` in your main bundle with the following content:
 
 ```
 <?xml version="1.0" encoding="UTF-8"?>
 <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
 <plist version="1.0">
 <dict>
	<key>ClientId</key>
	<string>{YOUR_CLIENT_ID}</string>
	<key>Domain</key>
	<string>{YOUR_DOMAIN}</string>
 </dict>
 </plist>
 ```

 - parameter session:  instance of NSURLSession used for networking. By default it will use the shared NSURLSession

 - returns: Auth0 Authentication API
 - important: Calling this method without a valid `Auth0.plist` will crash your application
 */
public func authentication(session: NSURLSession = .sharedSession()) -> Authentication {
    let values = plistValues()!
    return authentication(clientId: values.clientId, domain: values.domain, session: session)
}

/**
 Auth0 Management API v2 to perform CRUD operation against your Users, Clients, Connections, etc.

 ```
 Auth0.management(token: token)
 ```

 Auth0 domain is loaded from the file `Auth0.plist` in your main bundle with the following content:

 ```
 <?xml version="1.0" encoding="UTF-8"?>
 <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
 <plist version="1.0">
 <dict>
	<key>ClientId</key>
	<string>{YOUR_CLIENT_ID}</string>
	<key>Domain</key>
	<string>{YOUR_DOMAIN}</string>
 </dict>
 </plist>
 ```

 - parameter token:     token of Management API v2 with the correct allowed scopes to perform the desired action
 - parameter session:   instance of NSURLSession used for networking. By default it will use the shared NSURLSession

 - returns: Auth0 Management API v2
 - important: Auth0.swift has yet to implement all endpoints. Now you can only perform some CRUD operations against Users
 - important: Calling this method without a valid `Auth0.plist` will crash your application
 */
public func management(token token: String, session: NSURLSession = .sharedSession()) -> Management {
    let values = plistValues()!
    return management(token: token, domain: values.domain, session: session)
}

/**
 Auth0 Management API v2 to perform CRUD operation against your Users, Clients, Connections, etc.
 
 ```
 Auth0.management(token: token, domain: "samples.auth0.com")
 ```

 - parameter token:     token of Management API v2 with the correct allowed scopes to perform the desired action
 - parameter domain:    domain of your Auth0 account. e.g.: 'samples.auth0.com'
 - parameter session:   instance of NSURLSession used for networking. By default it will use the shared NSURLSession

 - returns: Auth0 Management API v2
 - important: Auth0.swift has yet to implement all endpoints. Now you can only perform some CRUD operations against Users
 */
public func management(token token: String, domain: String, session: NSURLSession = .sharedSession()) -> Management {
    return Management(token: token, url: .a0_url(domain), session: session)
}

/**
 Auth0 Management Users API v2 that allows CRUD operations with the users endpoint.

 ```
 Auth0.users(token: token)
 ```

 Currently you can only perform the following operations:

 * Get an user by id
 * Update an user, e.g. by adding `user_metadata`
 * Link users
 * Unlink users

 Auth0 domain is loaded from the file `Auth0.plist` in your main bundle with the following content:

 ```
 <?xml version="1.0" encoding="UTF-8"?>
 <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
 <plist version="1.0">
 <dict>
	<key>ClientId</key>
	<string>{YOUR_CLIENT_ID}</string>
	<key>Domain</key>
	<string>{YOUR_DOMAIN}</string>
 </dict>
 </plist>
 ```

 - parameter token:     token of Management API v2 with the correct allowed scopes to perform the desired action
 - parameter session:   instance of NSURLSession used for networking. By default it will use the shared NSURLSession

 - returns: Auth0 Management API v2
 - important: Calling this method without a valid `Auth0.plist` will crash your application
 */
public func users(token token: String, session: NSURLSession = .sharedSession()) -> Users {
    let values = plistValues()!
    return users(token: token, domain: values.domain, session: session)
}

/**
 Auth0 Management Users API v2 that allows CRUD operations with the users endpoint.
 
 ```
 Auth0.users(token: token, domain: "samples.auth0.com")
 ```

 Currently you can only perform the following operations:
 
 * Get an user by id
 * Update an user, e.g. by adding `user_metadata`
 * Link users
 * Unlink users

 - parameter token:     token of Management API v2 with the correct allowed scopes to perform the desired action
 - parameter domain:    domain of your Auth0 account. e.g.: 'samples.auth0.com'
 - parameter session:   instance of NSURLSession used for networking. By default it will use the shared NSURLSession

 - returns: Auth0 Management API v2
 */
public func users(token token: String, domain: String, session: NSURLSession = .sharedSession()) -> Users {
    return management(token: token, domain: domain, session: session).users()
}

/**
 Turn on/off Auth0.swift debug logging of HTTP requests and OAuth2 flow (iOS only).

 - parameter enabled: optional flag to turn on/off logging
 - note: By default all logging is **disabled**
 - important: Logging should be turned on/off **before** making request to Auth0 for the flag to take effect.
 */
public func enableLogging(enabled: Bool = true) {
    Auth0Logger.sharedInstance.logger = enabled ? DefaultLogger() : nil
}

func plistValues() -> (clientId: String, domain: String)? {
    let bundle = NSBundle.mainBundle()
    guard
        let path = bundle.pathForResource("Auth0", ofType: "plist"),
        let values = NSDictionary(contentsOfFile: path) as? [String: AnyObject]
        else {
            print("Missing Auth0.plist file with 'ClientId' and 'Domain' entries in main bundle!")
            return nil
        }

    guard
        let clientId = values["ClientId"] as? String,
        let domain = values["Domain"] as? String
        else {
            print("Auth0.plist file at \(path) is missing 'ClientId' and/or 'Domain' entries!")
            print("File currently has the following entries: \(values)")
            return nil
        }
    return (clientId: clientId, domain: domain)
}