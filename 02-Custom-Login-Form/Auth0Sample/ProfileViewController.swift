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
    
    fileprivate func retrieveProfile() {
        guard let accessToken = loginCredentials.accessToken else {
            print("Error retrieving profile")
            let _ = self.navigationController?.popViewController(animated: true)
            return
        }
        Auth0
            .authentication()
            .userInfo(token: accessToken)
            .start { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let profile):
                        self.welcomeLabel.text = "Welcome, \(profile.name)"
                        let task = URLSession.shared.dataTask(with: profile.pictureURL) { (data, response, error) in
                            guard let data = data , error == nil else { return }
                            DispatchQueue.main.async {
                                self.avatarImageView.image = UIImage(data: data)
                            }
                        }
                        task.resume()
                        self.userMetadataTextView.text = profile.userMetadata.description
                    case .failure(let error):
                        self.showAlertForError(error)
                    }
                }
        }
    }

}
