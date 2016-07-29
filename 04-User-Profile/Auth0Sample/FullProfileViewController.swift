// FullProfileViewController.swift
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
import Auth0

class FullProfileViewController: UIViewController {

    var profile: A0UserProfile!
    
    @IBOutlet weak var editBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.profile = SessionManager().storedProfile!
        self.loadTextFieldsValues()
    }

    // MARK: - IBAction
    
    @IBAction func save(sender: UIBarButtonItem) {
        self.view.endEditing(true)
        let loadingAlert = UIAlertController.loadingAlert()
        loadingAlert.presentInViewController(self)
        SessionManager().retrieveSession { session in
            Auth0
                .users(token: session!.token.idToken)
                .patch(session!.profile.userId, userMetadata:
                    ["first_name": self.firstNameTextField.text!,
                        "last_name": self.lastNameTextField.text!,
                        "country": self.countryTextField.text!])
                .start { result in
                    dispatch_async(dispatch_get_main_queue()) {
                        loadingAlert.dismiss()
                        switch result {
                        case .Success(let value):
                            // update the profile locally
                            let updatedProfile = A0UserProfile(dictionary: value)
                            SessionManager().saveProfile(updatedProfile)
                            self.profile = updatedProfile
                            let successAlert = UIAlertController.alertWithTitle(nil, message: "Successfully updated profile!")
                            successAlert.presentInViewController(self, dismissAfter: 1.0)
                        case .Failure(let error):
                            let failureAlert = UIAlertController.alertWithTitle("Error", message: String(error), includeDoneButton: true)
                            failureAlert.presentInViewController(self)
                        }
                    }
            }
        }
    }
    
    // MARK: - Private
    
    private func loadTextFieldsValues() {
        self.emailTextField.text = self.profile.email
        let metadata = self.profile.userMetadata as! [String: AnyObject]
        self.firstNameTextField.text = metadata["first_name"] as? String
        self.lastNameTextField.text = metadata["last_name"] as? String
    }

}

extension FullProfileViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        switch textField {
        case self.firstNameTextField:
            self.lastNameTextField.becomeFirstResponder()
        case self.lastNameTextField:
            self.countryTextField.becomeFirstResponder()
        default:
            self.view.endEditing(true)
        }
        return true
    }
    
}
