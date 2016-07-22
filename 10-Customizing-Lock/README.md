# Customizing Lock 

- [Full Tutorial](https://auth0.com/docs/quickstart/native/ios-swift/10-customizing-lock)

This sample project exposes how to customize the [Lock](https://github.com/auth0/Lock.iOS-OSX) widget, by setting your own colors, icons, fonts, and more.

#### Important Snippets

##### 1. Create, customize and register your own theme

You'll find this snippet in the `AppDelegate.swift` file:

```swift
private func customizeLockTheme() {
    let theme = A0Theme()
    theme.registerImageWithName("badge", bundle: NSBundle.mainBundle(), forKey: A0ThemeIconImageName)
    theme.registerColor(.yellowColor(), forKey: A0ThemeTitleTextColor)
    theme.registerFont(.boldSystemFontOfSize(14), forKey: A0ThemeTitleFont)
    theme.registerColor(.whiteColor(), forKey: A0ThemeSeparatorTextColor)
    theme.registerColor(.yellowColor(), forKey: A0ThemeTextFieldIconColor)
    theme.registerColor(.whiteColor(), forKey: A0ThemeTextFieldPlaceholderTextColor)
    theme.registerColor(.yellowColor(), forKey: A0ThemeTextFieldTextColor)
    theme.registerColor(.blackColor(), forKey: A0ThemePrimaryButtonNormalColor)
    theme.registerColor(.yellowColor(), forKey: A0ThemePrimaryButtonHighlightedColor)
    theme.registerFont(.boldSystemFontOfSize(20), forKey: A0ThemePrimaryButtonFont)
    theme.registerColor(.redColor(), forKey: A0ThemeSecondaryButtonBackgroundColor)
    theme.registerColor(.whiteColor(), forKey: A0ThemeSecondaryButtonTextColor)
    theme.registerColor(.orangeColor(), forKey: A0ThemeScreenBackgroundColor)
    A0Theme.sharedInstance().registerTheme(theme)
}
```

