// LoginViewController.swift
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

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var twitterButton: UIButton!
    @IBOutlet weak var spinner: UIActivityIndicatorView!

    @IBOutlet var actionButtons: [UIButton]!
    @IBOutlet var textFields: [UITextField]!

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.actionButtons.forEach { $0.roundLaterals() }
        self.textFields.forEach { $0.setPlaceholderTextColor(.lightVioletColor()) }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    // MARK: - IBAction
    
    @IBAction func login(sender: UIButton) {
        self.performLogin()
    }
    
    @IBAction func loginWithFacebook(sender: UIButton) {
        self.performFacebookAuthentication()
    }
    
    @IBAction func loginWithTwitter(sender: UIButton) {
        self.performTwitterAuthentication()
    }
    
    @IBAction func textFieldEditingChanged(sender: UITextField) {
        self.validateForm()
    }
    
    @IBAction func unwindToLogin(segue: UIStoryboardSegueWithCompletion) {
        guard let
        controller = segue.sourceViewController as? SignUpViewController,
        credentials = controller.retrievedCredentials
        else { return  }
        segue.completion = {
            self.loginWithCredentials(credentials)
        }
    }
    
    // MARK: - Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let profileViewController = segue.destinationViewController as? ProfileViewController else {
            return
        }
        profileViewController.loginCredentials = self.retrievedCredentials!
    }
    
    // MARK: - Private
    
    private var retrievedCredentials: Credentials?
    
    private var loading: Bool = false {
        didSet {
            dispatch_async(dispatch_get_main_queue()) {
                if self.loading {
                    self.spinner.startAnimating()
                    self.actionButtons.forEach { $0.enabled = false }
                } else {
                    self.spinner.stopAnimating()
                    self.actionButtons.forEach { $0.enabled = true }
                }
            }
        }
    }
    
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
    
    private func performFacebookAuthentication() {
        self.view.endEditing(true)
        self.loading = true
        Auth0
            .webAuth()
            .connection("facebook")
            .scope("openid")
            .start { result in
                dispatch_async(dispatch_get_main_queue()) {
                    self.spinner.stopAnimating()
                    switch result {
                    case .Success(let credentials):
                        self.loginWithCredentials(credentials)
                    case .Failure(let error):
                        self.showAlertForError(error)
                    }
                }
        }
    }
    
    private func performTwitterAuthentication() {
        self.view.endEditing(true)
        self.spinner.startAnimating()
        Auth0
            .webAuth()
            .connection("twitter")
            .scope("openid")
            .start { result in
                dispatch_async(dispatch_get_main_queue()) {
                    self.spinner.stopAnimating()
                    switch result {
                    case .Success(let credentials):
                        self.loginWithCredentials(credentials)
                    case .Failure(let error):
                        self.showAlertForError(error)
                    }
                }
        }
    }
    
    private func loginWithCredentials(credentials: Credentials) {
        self.retrievedCredentials = credentials
        self.performSegueWithIdentifier("ShowProfile", sender: nil)
    }
    
    private func validateForm() {
        self.loginButton.enabled = self.formIsValid
    }
    
    private var formIsValid: Bool {
        return self.emailTextField.hasText() && self.passwordTextField.hasText()
    }
    
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        switch textField {
        case self.emailTextField:
            self.passwordTextField.becomeFirstResponder()
        case self.passwordTextField where self.formIsValid:
            self.performLogin()
        default:
            break
        }
        return true
    }
    
}
