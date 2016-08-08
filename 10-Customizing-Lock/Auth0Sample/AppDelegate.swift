// AppDelegate.swift
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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        self.customizeLockTheme()
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    private func customizeLockTheme() {
        // Instantiate a theme
        let theme = A0Theme()
        
        // 1. Change the logo:
        theme.registerImageWithName("custom-logo", bundle: NSBundle.mainBundle(), forKey: A0ThemeIconImageName)
        
        // 2. Customize the 'Login' text appearance:
        theme.registerColor(.whiteColor(), forKey: A0ThemeTitleTextColor)
        theme.registerFont(.appFontOfSize(24), forKey: A0ThemeTitleFont)
        
        // 3. Customize the 'OR' text appearance:
        theme.registerColor(.whiteColor(), forKey: A0ThemeSeparatorTextColor)
        theme.registerFont(.appFontOfSize(18), forKey: A0ThemeSeparatorTextFont)
        
        // 4. Customize the text fields:
        theme.registerColor(.lightVioletColor(), forKey: A0ThemeTextFieldIconColor)
        theme.registerColor(.lightVioletColor(), forKey: A0ThemeTextFieldPlaceholderTextColor)
        theme.registerColor(.whiteColor(), forKey: A0ThemeTextFieldTextColor)
        theme.registerFont(.appFontOfSize(14), forKey: A0ThemeTextFieldFont)
        
        // 5. Customize the primary button (ACCESS):
        theme.registerColor(.whiteColor(), forKey: A0ThemePrimaryButtonNormalColor)
        theme.registerColor(.lightVioletColor(), forKey: A0ThemePrimaryButtonHighlightedColor)
        theme.registerColor(.darkVioletColor(), forKey: A0ThemePrimaryButtonTextColor)
        theme.registerFont(.boldSystemFontOfSize(20), forKey: A0ThemePrimaryButtonFont)
        
        // 6. Configure the secondary buttons (sign up / reset password):
        theme.registerColor(.lightVioletColor(), forKey: A0ThemeSecondaryButtonBackgroundColor)
        theme.registerColor(.whiteColor(), forKey: A0ThemeSecondaryButtonTextColor)
        
        // 7. Add a background image:
        theme.registerImageWithName("custom-background", bundle: NSBundle.mainBundle(), forKey: A0ThemeScreenBackgroundImageName)
        
        // 8. Configure the X button:
        theme.registerColor(.lightVioletColor(), forKey: A0ThemeCloseButtonTintColor)
        
        // 9. Configure the status bar:
        theme.statusBarStyle = .LightContent
        
        // Don't forget to register your theme!
        A0Theme.sharedInstance().registerTheme(theme)
    }
    
}

extension UIFont {
    
    class func appFontOfSize(size: CGFloat) -> UIFont {
        return UIFont(name: "Trebuchet MS", size: size)!
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
