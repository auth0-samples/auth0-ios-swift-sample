// SessionManager.swift
// Auth0Sample
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
import SimpleKeychain
import Auth0

enum SessionManagerError: Error {
    case noAccessToken
    case noIdToken
    case noIdentities
}

class SessionManager {
    static let shared = SessionManager()
    let keychain = A0SimpleKeychain(service: "Auth0")

    var idToken: String? {
        return self.keychain.string(forKey: "id_token")
    }
    var accessToken: String? {
        return self.keychain.string(forKey: "access_token")
    }
    var profile: UserInfo?

    private init () { }

    func storeTokens(_ accessToken: String, idToken: String) {
        self.keychain.setString(accessToken, forKey: "access_token")
        self.keychain.setString(idToken, forKey: "id_token")
    }

    func retrieveProfile(_ callback: @escaping (Error?) -> ()) {
        guard let accessToken = self.keychain.string(forKey: "access_token") else {
            return callback(SessionManagerError.noAccessToken)
        }
        Auth0.authentication()
            .userInfo(withAccessToken: accessToken)
            .start { result in
                switch(result) {
                case .success(let profile):
                    self.profile = profile
                    callback(nil)
                case .failure(let error):
                    callback(error)
                }
        }
    }


    func retrieveIdentity(_ callback: @escaping (Error?, [Identity]?) -> ()) {
        guard let accessToken  = self.keychain.string(forKey: "access_token") else {
            return callback(SessionManagerError.noAccessToken, nil)
        }
        guard let userId = profile?.sub else {
            return callback(SessionManagerError.noIdToken, nil)
        }
        Auth0
            .users(token: accessToken)
            .get(userId, fields: ["identities"], include: true)
            .start { result in
                switch result {
                case .success(let user):
                    let identityValues = user["identities"] as? [[String: Any]] ?? []
                    let identities = identityValues.flatMap { Identity(json: $0) }
                    callback(nil, identities)
                    break
                case .failure(let error):
                    callback(error, nil)
                    break
                }
        }
    }

    func logout() {
        self.keychain.clearAll()
    }
    
}

func plistValues(bundle: Bundle) -> (clientId: String, domain: String)? {
    guard
        let path = bundle.path(forResource: "Auth0", ofType: "plist"),
        let values = NSDictionary(contentsOfFile: path) as? [String: Any]
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
