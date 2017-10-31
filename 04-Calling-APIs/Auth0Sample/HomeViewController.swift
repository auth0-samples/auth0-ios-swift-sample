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
import Auth0
import SimpleKeychain

class HomeViewController: UIViewController {

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - IBAction

    @IBAction func showLoginController(_ sender: UIButton) {
        self.checkAccessToken()
    }

    // MARK: - Private

    fileprivate func showLogin() {
        guard let clientInfo = plistValues(bundle: Bundle.main) else { return }
        
        let APIIdentifier = "https://" + clientInfo.domain + "/userinfo" // Replace with the API Identifier value you created
        Auth0
            .webAuth()
            .audience(APIIdentifier)
            .scope("openid profile")
            .start {
                switch $0 {
                case .failure(let error):
                    // Handle the error
                    print("Error: \(error)")
                case .success(let credentials):
                    guard let accessToken = credentials.accessToken, let idToken = credentials.idToken else { return }
                    SessionManager.shared.storeTokens(accessToken, idToken: idToken)
                    SessionManager.shared.retrieveProfile { error in
                        guard error == nil else {
                            return self.showLogin()
                        }
                        DispatchQueue.main.async {
                            self.performSegue(withIdentifier: "ShowProfileNonAnimated", sender: nil)
                        }
                    }
                }
        }
    }

    fileprivate func checkAccessToken() {
        let loadingAlert = UIAlertController.loadingAlert()
        loadingAlert.presentInViewController(self)
        SessionManager.shared.logout()
        SessionManager.shared.retrieveProfile { error in
            loadingAlert.dismiss(animated: true) {
                guard error == nil else {
                    return self.showLogin()
                }
                self.performSegue(withIdentifier: "ShowProfileNonAnimated", sender: nil)
            }
        }
    }
    
}
