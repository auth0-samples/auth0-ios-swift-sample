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
    
    @IBAction func switchEditingMode(_ sender: UIBarButtonItem) {
        let editing = !self.tableView.isEditing
        self.tableView.setEditing(editing, animated: true)
        sender.title = editing ? "Done" : "Edit"
        self.addAccountBarButtonItem.isEnabled = editing
    }
    
    @IBAction func linkAnotherAccount(_ sender: UIBarButtonItem) {
        self.showLinkAccountDialog()
    }
    
    // MARK: - Private
    
    fileprivate var identities: [A0UserIdentity]!

    fileprivate func showLinkAccountDialog() {
        let controller = A0Lock.shared().newLockViewController()
        controller?.closable = true
        controller?.onAuthenticationBlock = { profile, token in
            guard let idToken = token?.idToken else {
                self.showMissingProfileOrTokenAlert()
                return
            }
            controller?.dismiss(animated: true) {
                self.linkAccountWithIDToken(idToken)
            }
        }
        A0Lock.shared().present(controller, from: self)
    }
    
    fileprivate func showMissingProfileOrTokenAlert() {
        let alert = UIAlertController(title: "Error", message: "Could not retrieve token", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    fileprivate func linkAccountWithIDToken(_ otherUserToken: String) {
        let loadingAlert = UIAlertController.loadingAlert()
        loadingAlert.presentInViewController(self)
        SessionManager().retrieveSession { session in
            Auth0
                .users(token: session!.token.idToken)
                .link(self.userId, withOtherUserToken: otherUserToken)
                .start { result in
                        loadingAlert.dismiss() {
                            switch result {
                            case .success:
                                let successAlert = UIAlertController.alertWithTitle(nil, message: "Successfully linked account!")
                                successAlert.presentInViewController(self, dismissAfter: 1.0) { completion in
                                    self.updateIdentities()
                                }
                            case .failure(let error):
                                let failureAlert = UIAlertController.alertWithTitle("Error", message: error.localizedDescription, includeDoneButton: true)
                                failureAlert.presentInViewController(self)
                            }
                    }
            }
        }
    }
    
    fileprivate func updateIdentities() {
        let loadingAlert = UIAlertController.loadingAlert()
        loadingAlert.presentInViewController(self)
        SessionManager().retrieveSession { session in
            loadingAlert.dismiss() {
                self.identities = session!.profile.identities as! [A0UserIdentity]
                self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
            }
        }
    }
    
    fileprivate func unlinkIdentity(_ identity: A0UserIdentity) {
        let loadingAlert = UIAlertController.loadingAlert()
        loadingAlert.presentInViewController(self)
        SessionManager().retrieveSession { session in
            Auth0
                .users(token: session!.token.idToken)
                .unlink(identityId: identity.userId, provider: identity.provider, fromUserId: self.userId)
                .start { result in
                    loadingAlert.dismiss() {
                        switch result {
                        case .success:
                            let successAlert = UIAlertController.alertWithTitle(nil, message: "Account unlinked")
                            successAlert.presentInViewController(self, dismissAfter: 1.0) { completion in
                                self.updateIdentities()
                            }
                        case .failure(let error):
                            let failureAlert = UIAlertController.alertWithTitle("Error", message: error.localizedDescription, includeDoneButton: true)
                            failureAlert.presentInViewController(self)
                        }
                    }
            }
        }
    }
    
    fileprivate func identityAtIndexPath(_ indexPath: IndexPath) -> A0UserIdentity {
        return self.identities[indexPath.row]
    }
}

extension UserIdentitiesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.identities?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserIdentityCell") as! UserIdentityCell
        cell.identity = self.identities[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return !self.userId.hasSuffix(self.identityAtIndexPath(indexPath).userId)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard case .delete = editingStyle else {
            return
        }
        let identityToUnlink = self.identityAtIndexPath(indexPath)
        self.unlinkIdentity(identityToUnlink)
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Unlink"
    }
}
