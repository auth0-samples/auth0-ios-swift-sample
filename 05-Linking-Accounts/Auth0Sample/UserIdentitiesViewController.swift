// UserIdentitiesViewController.swift
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

class UserIdentitiesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addAccountBarButtonItem: UIBarButtonItem!
    var userId: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateIdentities()
    }
    
    @IBAction func switchEditingMode(sender:
        UIBarButtonItem) {
        let editing = !self.tableView.editing
        self.tableView.setEditing(editing, animated: true)
        sender.title = editing ? "Done" : "Edit"
        self.addAccountBarButtonItem.enabled = editing
    }
    
    @IBAction func linkAnotherAccount(sender: UIBarButtonItem) {
        self.showLinkAccountDialog()
    }
    
    // MARK: - Private
    
    private var identities: [A0UserIdentity]!

    private func showLinkAccountDialog() {
        let controller = A0Lock.sharedLock().newLockViewController()
        controller.closable = true
        controller.onAuthenticationBlock = { profile, token in
            guard let idToken = token?.idToken else {
                self.showMissingProfileOrTokenAlert()
                return
            }
            controller.dismissViewControllerAnimated(true) {
                self.linkAccountWithIDToken(idToken)
            }
        }
        A0Lock.sharedLock().presentLockController(controller, fromController: self)
    }
    
    private func showMissingProfileOrTokenAlert() {
        let alert = UIAlertController(title: "Error", message: "Could not retrieve token", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    private func linkAccountWithIDToken(otherUserToken: String) {
        let loadingAlert = UIAlertController.loadingAlert()
        loadingAlert.presentInViewController(self)
        SessionManager().retrieveSession { session in
            Auth0
                .users(token: session!.token.idToken)
                .link(self.userId, withOtherUserToken: otherUserToken)
                .start { result in
                        loadingAlert.dismiss() {
                            switch result {
                            case .Success:
                                let successAlert = UIAlertController.alertWithTitle(nil, message: "Successfully linked account!")
                                successAlert.presentInViewController(self, dismissAfter: 1.0) { completion in
                                    self.updateIdentities()
                                }
                            case .Failure(let error):
                                let failureAlert = UIAlertController.alertWithTitle("Error", message: String(error), includeDoneButton: true)
                                failureAlert.presentInViewController(self)
                            }
                    }
            }
        }
    }
    
    private func updateIdentities() {
        let loadingAlert = UIAlertController.loadingAlert()
        loadingAlert.presentInViewController(self)
        SessionManager().retrieveSession { session in
            loadingAlert.dismiss() {
                self.identities = session!.profile.identities as! [A0UserIdentity]
                self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Automatic)
            }
        }
    }
    
    private func unlinkIdentity(identity: A0UserIdentity) {
        let loadingAlert = UIAlertController.loadingAlert()
        loadingAlert.presentInViewController(self)
        SessionManager().retrieveSession { session in
            Auth0
                .users(token: session!.token.idToken)
                .unlink(identityId: identity.userId, provider: identity.provider, fromUserId: self.userId)
                .start { result in
                    loadingAlert.dismiss() {
                        switch result {
                        case .Success:
                            let successAlert = UIAlertController.alertWithTitle(nil, message: "Account unlinked")
                            successAlert.presentInViewController(self, dismissAfter: 1.0) { completion in
                                self.updateIdentities()
                            }
                        case .Failure(let error):
                            let failureAlert = UIAlertController.alertWithTitle("Error", message: String(error), includeDoneButton: true)
                            failureAlert.presentInViewController(self)
                        }
                    }
            }
        }
    }
    
    private func identityAtIndexPath(indexPath: NSIndexPath) -> A0UserIdentity {
        return self.identities[indexPath.row]
    }
}

extension UserIdentitiesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.identities?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UserIdentityCell") as! UserIdentityCell
        cell.identity = self.identities[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return !self.userId.hasSuffix(self.identityAtIndexPath(indexPath).userId)
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        guard case .Delete = editingStyle else {
            return
        }
        let identityToUnlink = self.identityAtIndexPath(indexPath)
        self.unlinkIdentity(identityToUnlink)
    }
    
    func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String? {
        return "Unlink"
    }
}
