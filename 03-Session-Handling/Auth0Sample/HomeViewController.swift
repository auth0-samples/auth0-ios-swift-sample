// HomeViewController.swift
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

import UIKit
import Lock

class HomeViewController: UIViewController {
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.checkExistentSession()
    }
    
    // MARK: - IBAction
    
    @IBAction func showLoginController(sender: UIButton) {
        let controller = A0Lock.sharedLock().newLockViewController()
        controller.closable = true
        controller.onAuthenticationBlock = { maybeProfile, maybeToken in
            guard let profile = maybeProfile, token = maybeToken else {
                self.showMissingProfileOrTokenAlert()
                return
            }
            SessionManager().loginWithToken(token, profile: profile)
            self.retrievedProfile = profile
            controller.dismissViewControllerAnimated(true, completion: nil)
            self.performSegueWithIdentifier("ShowProfileAnimated", sender: nil)
        }
        A0Lock.sharedLock().presentLockController(controller, fromController: self)
    }

    // MARK: - Private
    
    private var retrievedProfile: A0UserProfile?
    
    private func showMissingProfileOrTokenAlert() {
        let alert = UIAlertController(title: "Error", message: "Could not retrieve profile or token", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    private func checkExistentSession() {
        let loadingAlert = UIAlertController.loadingAlert()
        loadingAlert.presentInViewController(self)
        SessionManager().retrieveSession { maybeSession in
            loadingAlert.dismiss()
            guard let session = maybeSession else {
                return
            }
            self.retrievedProfile = session.profile
            self.performSegueWithIdentifier("ShowProfileNonAnimated", sender: nil)
        }
    }

}
