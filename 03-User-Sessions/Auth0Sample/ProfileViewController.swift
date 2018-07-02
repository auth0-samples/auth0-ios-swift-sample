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

    @IBOutlet weak var extend: UIButton!
    @IBOutlet weak var patch: UIButton!
    
    var profile: UserInfo!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profile = SessionManager.shared.profile
        self.welcomeLabel.text = "Welcome, \(self.profile.name ?? "no  name")"
        guard let pictureURL = self.profile.picture else { return }
        let task = URLSession.shared.dataTask(with: pictureURL) { (data, response, error) in
            guard let data = data , error == nil else { return }
            DispatchQueue.main.async {
                self.avatarImageView.image = UIImage(data: data)
            }
        }
        task.resume()

        if !SessionManager.shared.patchMode {
            self.extend.isEnabled = false
            self.patch.isEnabled = false
        }
    }

    @IBAction func addMetaData() {
        guard let accessToken = SessionManager.shared.credentials?.accessToken else {
            return print("Failed to retrieve access token")
        }
        Auth0
            .users(token: accessToken)
            .patch(self.profile.sub, userMetadata: ["country": "United Kingdom"])
            .start { result in
                switch(result) {
                case .success(_):
                    self.extendedProfile()
                case .failure(let error):
                    print("Failed to retrieve profile: \(String(describing: error))")
                }
        }
    }

    @IBAction func extendedProfile() {
        guard let accessToken = SessionManager.shared.credentials?.accessToken else {
            return print("Failed to retrieve access token")
        }
        Auth0
            .users(token: accessToken)
            .get(self.profile.sub, fields: ["user_metadata"])
            .start { result in
                switch(result) {
                case .success(let profile):
                    let extend = UIAlertController.alertWithTitle("Extended Profile", message: "\(profile)", includeDoneButton: true)
                    self.present(extend, animated: true, completion: nil)
                case .failure(let error):
                    print("Failed to retrieve profile: \(String(describing: error))")
                }
        }
    }

    @IBAction func logout(_ sender: UIBarButtonItem) {
        _ = SessionManager.shared.logout()
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
