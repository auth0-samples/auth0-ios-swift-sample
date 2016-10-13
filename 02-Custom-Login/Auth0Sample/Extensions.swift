// Extensions.swift
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

extension UIViewController {
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @IBAction func dismissNavigation(_ sender: AnyObject) {
        self.navigationController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
}

extension String {
    
    func attributedWithColor(_ color: UIColor) -> NSAttributedString {
        return NSAttributedString(string: self, attributes: [NSForegroundColorAttributeName: color])
    }
    
}

extension UIButton {
    
    func roundLaterals() {
        self.layer.cornerRadius = self.frame.size.height / 2
    }
    
}

extension UITextField {
    
    func setPlaceholderTextColor(_ color: UIColor) {
        guard let placeholder = self.placeholder else { return }
        self.attributedPlaceholder = placeholder.attributedWithColor(color)
    }
    
}

extension UIColor {
    
    class func lightVioletColor() -> UIColor {
        return UIColor(red: 173 / 255, green: 137 / 255, blue: 188 / 255, alpha: 1)
    }
    
    class func darkVioletColor() -> UIColor {
        return UIColor(red: 49 / 255, green: 49 / 255, blue: 80 / 255, alpha: 1)
    }
    
}

extension UIAlertController {
    
    static func loadingAlert() -> UIAlertController {
        return self.alertWithTitle("Loading", message: "Please, wait...")
    }
    
    static func alertWithTitle(_ title: String? = nil, message: String? = nil, includeDoneButton: Bool = false) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if includeDoneButton {
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        }
        return alert
    }
    
    func presentInViewController(_ viewController: UIViewController, dismissAfter possibleDelay: TimeInterval? = nil, completion: (() -> ())? = nil) {
        viewController.present(self, animated: false, completion: nil)
        guard let delay = possibleDelay else {
            return
        }
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
                self.dismiss(completion)
        }
    }
    
    func dismiss(_ completion: (()->())? = nil) {
        DispatchQueue.main.async {
            self.dismiss(animated: false, completion: completion)
        }
    }
    
}
