# Customizing Lock 

- [Full Tutorial](https://auth0.com/docs/quickstart/native/ios-swift/10-customizing-lock)

This sample project exposes how to customize the [Lock](https://github.com/auth0/Lock.iOS-OSX) widget, by setting your own colors, icons, fonts, and more.

#### Important Snippets

##### 1. Create, customize and register your own theme

You'll find this snippet in the `AppDelegate.swift` file:

```swift
private func customizeLockTheme() {
    // Instantiate a theme
    let theme = A0Theme()
    
    // 1. Change the logo:
    theme.registerImageWithName("custom-logo", bundle: NSBundle.mainBundle(), forKey: A0ThemeIconImageName)
    
    // 2. Customize the 'Login' text appearance:
    theme.registerColor(.whiteColor(), forKey: A0ThemeTitleTextColor)
    theme.registerFont(.systemFontOfSize(24, weight: UIFontWeightThin), forKey: A0ThemeTitleFont)
    
    // 3. Customize the 'OR' text appearance:
    theme.registerColor(.whiteColor(), forKey: A0ThemeSeparatorTextColor)
    theme.registerFont(.systemFontOfSize(12, weight: UIFontWeightSemibold), forKey: A0ThemeSeparatorTextFont)
    
    // 4. Customize the text fields:
    theme.registerColor(.lightVioletColor(), forKey: A0ThemeTextFieldIconColor)
    theme.registerColor(.lightVioletColor(), forKey: A0ThemeTextFieldPlaceholderTextColor)
    theme.registerColor(.whiteColor(), forKey: A0ThemeTextFieldTextColor)
    theme.registerFont(.systemFontOfSize(14, weight: UIFontWeightRegular), forKey: A0ThemeTextFieldFont)
    
    // 5. Customize the primary button (ACCESS):
    theme.registerColor(.whiteColor(), forKey: A0ThemePrimaryButtonNormalColor)
    theme.registerColor(.lightVioletColor(), forKey: A0ThemePrimaryButtonHighlightedColor)
    theme.registerColor(.darkVioletColor(), forKey: A0ThemePrimaryButtonTextColor)
    theme.registerFont(.systemFontOfSize(20, weight: UIFontWeightBold), forKey: A0ThemePrimaryButtonFont)
    
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
```

