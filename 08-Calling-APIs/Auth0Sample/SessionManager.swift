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

import Lock
import SimpleKeychain

// swiftlint:disable function_body_length

/// A class that encapsulates the process of session handling
class SessionManager {
    
    func retrieveSession(_ completion: @escaping (Session?) -> ()) {
        guard let session = self.storedSession else {
            completion(nil)
            return
        }
        let client = A0Lock.shared().apiClient()
        // Check whether the current id_token is still valid
        client.fetchUserProfile(withIdToken: session.token.idToken,
                                           success: { profile in
                                            // id_token is still valid
                                            // We update the user profile
                                            self.saveProfile(profile)
                                            completion(self.storedSession)
            }, failure: { error in
                // id_token is no longer valid
                // We will use the refresh_token to ask for a new valid id_token
                // You can perform logout at this point if your app demands so
                guard let refreshToken = session.token.refreshToken else {
                    // no refresh_token available
                    self.keychain.clearAll()
                    // Cleaning stored values since they are no longer valid
                    // At this point, you should ask the user to login again!
                    completion(nil)
                    return
                }
                client.fetchNewIdToken(withRefreshToken: refreshToken,
                    parameters: nil,
                    success: { newToken in
                        // Just got a new id_token!
                        let updatedToken = A0Token(accessToken: session.token.accessToken, idToken: newToken.idToken, tokenType: session.token.tokenType, refreshToken: session.token.refreshToken)
                        self.keychain.setData(NSKeyedArchiver.archivedData(withRootObject: updatedToken), forKey: "token")
                        // Gotta retrieve the updated profile.
                        self.retrieveSession(completion)
                    }, failure: { error in
                        // refresh_token is no longer valid
                        self.keychain.clearAll()
                        // Cleaning stored values since they are no longer valid
                        // At this point, you should ask the user to login again!
                        completion(nil)
                })
        })
        
    }
    
    func loginWithToken(_ token: A0Token, profile: A0UserProfile) {
        self.keychain.setData(NSKeyedArchiver.archivedData(withRootObject: profile), forKey: "profile")
        self.keychain.setData(NSKeyedArchiver.archivedData(withRootObject: token), forKey: "token")
    }
    
    func logout() {
        self.keychain.clearAll()
    }
    
    var storedProfile: A0UserProfile? {
        return self.storedSession?.profile
    }
    
    func saveProfile(_ profile: A0UserProfile) {
        self.keychain.setData(NSKeyedArchiver.archivedData(withRootObject: profile), forKey: "profile")
    }
    
    var storedSession: Session? {
        guard let
            tokenData = keychain.data(forKey: "token"),
            let token = NSKeyedUnarchiver.unarchiveObject(with: tokenData) as? A0Token,
            let profileData = keychain.data(forKey: "profile"),
            let profile = NSKeyedUnarchiver.unarchiveObject(with: profileData) as? A0UserProfile
            else { return nil }
        return Session(token: token, profile: profile)
    }
    
    // MARK: - Private
    
    fileprivate let keychain = A0SimpleKeychain(service: "Auth0")
    fileprivate static let TokenKey = "A0Token"
    
}
