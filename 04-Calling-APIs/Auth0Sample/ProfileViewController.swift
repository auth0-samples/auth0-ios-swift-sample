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
import SimpleKeychain

class ProfileViewController: UIViewController {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var welcomeLabel: UILabel!

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
    }

    @IBAction func callAPIWithoutAuthentication(_ sender: UIButton) {
        self.callAPI(authenticated: false)
    }

    @IBAction func callAPIWithAuthentication(_ sender: UIButton) {
        self.callAPI(authenticated: true)
    }

    @IBAction func logout(_ sender: UIBarButtonItem) {
        SessionManager.shared.logout()
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }

    private func callAPI(authenticated shouldAuthenticate: Bool) {
        let url = URL(string: "your api url")!
        var request = URLRequest(url: url)
        // Configure your request here (method, body, etc)
        if shouldAuthenticate {
            guard let token = A0SimpleKeychain(service: "Auth0").string(forKey: "access_token") else {
                return
            }
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            DispatchQueue.main.async {
                let title = "Results"
                let message = "Error: \(String(describing: error?.localizedDescription))\n\nData: \(data == nil ? "nil" : "(there is data)")\n\nResponse: \(String(describing: response?.description))"
                let alert = UIAlertController.alertWithTitle(title, message: message, includeDoneButton: true)
                self.present(alert, animated: true, completion: nil)

            }
        })
        task.resume()
    }
}
