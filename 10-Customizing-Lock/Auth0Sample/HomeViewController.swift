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
    
    // MARK: - IBAction
    
    @IBAction func showLoginController(_ sender: UIButton) {
        let controller = A0Lock.shared().newLockViewController()
        controller?.closable = true
        controller?.onAuthenticationBlock = { profile, token in
            guard let userProfile = profile else {
                self.showMissingProfileAlert()
                return
            }
            self.retrievedProfile = userProfile
            controller?.dismiss(animated: true, completion: nil)
            self.performSegue(withIdentifier: "ShowProfile", sender: nil)
        }
        A0Lock.shared().present(controller, from: self)
    }
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let profileController = segue.destination as? ProfileViewController else {
            return
        }
        profileController.profile = self.retrievedProfile
    }
    
    // MARK: - Private
    
    fileprivate var retrievedProfile: A0UserProfile!
    
    fileprivate func showMissingProfileAlert() {
        let alert = UIAlertController(title: "Error", message: "Could not retrieve profile", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}
