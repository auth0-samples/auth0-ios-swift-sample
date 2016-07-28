// SignUpViewController.swift
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

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var retrievedCredentials: Credentials?
    
    // MARK: - IBAction
    
    @IBAction func register(sender: UIButton) {
        self.performRegister()
    }
    
    @IBAction func registerWithFacebook(sender: UIButton) {
        self.performFacebookSignUp()
    }
    
    @IBAction func textFieldEditingChanged(sender: UITextField) {
        self.validateForm()
    }
    
    @IBAction func dismissKeyboard(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }

    // MARK: - Private
    
    private func performRegister() {
        self.view.endEditing(true)
        self.spinner.startAnimating()
        Auth0
            .authentication()
            .signUp(self.emailTextField.text!,
                password: self.passwordTextField.text!,
                connection: "Username-Password-Authentication",
                userMetadata: ["first_name": self.firstNameTextField.text!,
                    "last_name": self.lastNameTextField.text!]
            )
            .start { result in
                dispatch_async(dispatch_get_main_queue()) {
                    self.spinner.stopAnimating()
                    switch result {
                    case .Success(let credentials):
                        self.retrievedCredentials = credentials
                        self.performSegueWithIdentifier("DismissSignUp", sender: nil)
                    case .Failure(let error):
                        self.showAlertForError(error)
                    }
                }
        }
    }
    
    private func performFacebookSignUp() {
        self.view.endEditing(true)
        self.spinner.startAnimating()
        Auth0
            .webAuth()
            .connection("facebook")
            .scope("openid")
            .start { result in
                dispatch_async(dispatch_get_main_queue()) {
                    self.spinner.stopAnimating()
                    switch result {
                    case .Success(let credentials):
                        self.retrievedCredentials = credentials
                        self.performSegueWithIdentifier("DismissSignUp", sender: nil)
                    case .Failure(let error):
                        self.showAlertForError(error)
                    }
                }
        }
    }
    
    private func validateForm() {
        self.signUpButton.enabled = self.formIsValid
    }
    
    private var formIsValid: Bool {
        return self.emailTextField.hasText() && self.passwordTextField.hasText()
    }
    
}

extension SignUpViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        switch textField {
        case self.emailTextField:
            self.passwordTextField.becomeFirstResponder()
        case self.passwordTextField:
            self.firstNameTextField.becomeFirstResponder()
        case self.firstNameTextField:
            self.lastNameTextField.becomeFirstResponder()
        case self.lastNameTextField where self.formIsValid:
            self.performRegister()
        default:
            break
        }
        return true
    }
    
}
