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
import Lock

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var welcomeLabel: UILabel!
    
    var profile: A0UserProfile!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.profile = SessionManager().storedProfile
        self.welcomeLabel.text = "Welcome, \(self.profile.name)"
        self.retrieveDataFromURL(self.profile.picture) { data, response, error in
            dispatch_async(dispatch_get_main_queue()) {
                guard let data = data where error == nil else { return }
                self.avatarImageView.image = UIImage(data: data)
            }
        }
    }
    
    @IBAction func logout(sender: UIBarButtonItem) {
        SessionManager().logout()
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let controller = segue.destinationViewController as? UserIdentitiesViewController else {
            return
        }
        controller.userId = self.profile.userId
    }
    
    // MARK: - Private
    
    private func retrieveDataFromURL(url: NSURL, completion: ((data: NSData?, response: NSURLResponse?, error: NSError? ) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: completion).resume()
    }
        
}
