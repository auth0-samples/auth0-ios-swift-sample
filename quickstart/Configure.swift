#!/usr/bin/env swift
// Configures the sample app with your Auth0 credentials: writes Domain and
// ClientId into Auth0.plist, sets the bundle identifier in the Xcode project,
// and sets UseHTTPS (true only when an Apple Team ID is supplied, which enables
// Universal Links instead of the custom URL scheme).
//
// Run from the project root:
//   swift quickstart/Configure.swift --domain <domain> --client-id <id> --bundle-id <bundle-id> [--team-id <team-id>]

import Foundation

let plistPath = "auth0-ios-sample/Auth0.plist"
let pbxprojPath = "auth0-ios-sample.xcodeproj/project.pbxproj"

func fail(_ message: String) -> Never {
    FileHandle.standardError.write(Data("error: \(message)\n".utf8))
    exit(1)
}

// MARK: - Argument parsing

func parseArguments() -> (domain: String, clientId: String, bundleId: String, teamId: String?) {
    var values: [String: String] = [:]
    var args = Array(CommandLine.arguments.dropFirst())
    while let flag = args.first {
        guard flag.hasPrefix("--"), args.count >= 2 else {
            fail("unexpected argument \"\(flag)\"")
        }
        values[String(flag.dropFirst(2))] = args[1]
        args.removeFirst(2)
    }
    let usage = "usage: swift quickstart/Configure.swift --domain <domain> --client-id <id> --bundle-id <bundle-id> [--team-id <team-id>]"
    guard let domain = values["domain"], let clientId = values["client-id"], let bundleId = values["bundle-id"] else {
        fail(usage)
    }
    return (domain, clientId, bundleId, values["team-id"]?.isEmpty == false ? values["team-id"] : nil)
}

let (domain, clientId, bundleId, teamId) = parseArguments()
let useHTTPS = teamId != nil

// MARK: - Auth0.plist

guard let plistData = FileManager.default.contents(atPath: plistPath) else {
    fail("\(plistPath) not found — run this script from the project root")
}
guard var plist = try PropertyListSerialization.propertyList(from: plistData, format: nil) as? [String: Any] else {
    fail("\(plistPath) is not a valid property list")
}
plist["Domain"] = domain
plist["ClientId"] = clientId
plist["UseHTTPS"] = useHTTPS
let updatedPlist = try PropertyListSerialization.data(fromPropertyList: plist, format: .xml, options: 0)
try updatedPlist.write(to: URL(fileURLWithPath: plistPath))

// MARK: - project.pbxproj

guard let pbxproj = try? String(contentsOfFile: pbxprojPath, encoding: .utf8) else {
    fail("\(pbxprojPath) not found — run this script from the project root")
}
// Replace every PRODUCT_BUNDLE_IDENTIFIER occurrence (Debug + Release configs).
let pattern = "PRODUCT_BUNDLE_IDENTIFIER = [^;]*;"
let updatedPbxproj = pbxproj.replacingOccurrences(
    of: pattern,
    with: "PRODUCT_BUNDLE_IDENTIFIER = \(bundleId);",
    options: .regularExpression
)
try updatedPbxproj.write(toFile: pbxprojPath, atomically: true, encoding: .utf8)

print("""
Auth0 settings configured:
  Domain    = \(domain)
  ClientId  = \(clientId)
  BundleId  = \(bundleId)
  UseHTTPS  = \(useHTTPS)
""")

// When a Team ID is supplied, UseHTTPS is enabled so the app uses a Universal Link
// callback on iOS 17.4+ / macOS 14.4+. That requires manual signing + entitlement
// setup that this script cannot do (it lives in Xcode and the Auth0 Dashboard).
// {platform} below is ios | macos | visionos — Auth0.swift picks it per build target.
if let teamId {
    print("""

    UseHTTPS is on — the app will use a Universal Link callback on iOS 17.4+ /
    macOS 14.4+ (older versions fall back to the custom URL scheme automatically).
    To make Universal Links work you must complete these manual steps (paid Apple
    Developer account required):

      1. Open the project in Xcode:
           open \(FileManager.default.currentDirectoryPath)/auth0-ios-sample.xcodeproj
      2. Target > Signing & Capabilities: set Team to \(teamId) and keep
         "Automatically manage signing" on.
      3. Same tab: + Capability > Associated Domains, then add:
           webcredentials:\(domain)
         (added to auth0-ios-sample.entitlements.)
      4. Auth0 Dashboard > your app > Settings > Advanced > Device Settings:
         set iOS Team ID = \(teamId) and App ID = \(bundleId)
         (this serves the apple-app-site-association file).
      5. Register BOTH callback/logout URLs (the https one is used on the modern
         OS, the custom-scheme one on older versions). Replace {platform} with
         ios, macos, or visionos to match your build target:
           https://\(domain)/{platform}/\(bundleId)/callback
           \(bundleId)://\(domain)/{platform}/\(bundleId)/callback

    Without a Team ID the app uses the custom URL scheme only — no signing or
    entitlement setup needed.
    """)
}
