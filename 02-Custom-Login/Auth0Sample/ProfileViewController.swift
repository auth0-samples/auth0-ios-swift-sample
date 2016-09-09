// ProfileViewController.swift
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

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var userMetadataTextView: UITextView!
    
    var loginCredentials: Credentials!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.welcomeLabel.text = ""
        self.userMetadataTextView.text = ""
        self.retrieveProfile()
    }
    
    // MARK: - Private
    
    private func retrieveProfile() {
        guard let idToken = loginCredentials.idToken else {
            self.showErrorRetrievingProfileAlert()
            self.navigationController?.popViewControllerAnimated(true)
            return
        }
        Auth0
            .authentication()
            .tokenInfo(token: idToken)
            .start { result in
                dispatch_async(dispatch_get_main_queue()) {
                    switch result {
                    case .Success(let profile):
                        
                        self.welcomeLabel.text = "Welcome, \(profile.name)"
                        self.retrieveDataFromURL(profile.pictureURL) { data, response, error in
                            dispatch_async(dispatch_get_main_queue()) {
                                guard let data = data where error == nil else { return }
                                self.avatarImageView.image = UIImage(data: data)
                            }
                        }
                        self.userMetadataTextView.text = String(profile.userMetadata)
                    case .Failure(let error):
                        self.showAlertForError(error)
                    }
                }
        }
    }
    
    private func retrieveDataFromURL(url:NSURL, completion: ((data: NSData?, response: NSURLResponse?, error: NSError? ) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: completion).resume()
    }
    
    private func showErrorRetrievingProfileAlert() {
        print("Error retrieving profile")
    }

}
