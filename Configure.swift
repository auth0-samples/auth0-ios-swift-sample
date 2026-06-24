#!/usr/bin/env swift
// Configures the sample app with your Auth0 credentials: writes Domain and
// ClientId into Auth0.plist, sets the bundle identifier in the Xcode project,
// and sets UseHTTPS (true only when an Apple Team ID is supplied, which enables
// Universal Links instead of the custom URL scheme).
//
// When a Team ID is supplied it also wires up everything Universal Links needs
// that lives in files: the DEVELOPMENT_TEAM build setting and the
// webcredentials:<domain> entry in the Associated Domains entitlement. The only
// remaining step is to build in Xcode, which provisions the capability with
// Apple via automatic signing.
//
// Run from the project root:
//   swift Configure.swift --domain <domain> --client-id <id> --bundle-id <bundle-id> [--team-id <team-id>]

import Foundation

let plistPath = "auth0-ios-sample/Auth0.plist"
let pbxprojPath = "auth0-ios-sample.xcodeproj/project.pbxproj"
let entitlementsPath = "auth0-ios-sample/auth0-ios-sample.entitlements"

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
    let usage = "usage: swift Configure.swift --domain <domain> --client-id <id> --bundle-id <bundle-id> [--team-id <team-id>]"
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
var updatedPbxproj = pbxproj.replacingOccurrences(
    of: "PRODUCT_BUNDLE_IDENTIFIER = [^;]*;",
    with: "PRODUCT_BUNDLE_IDENTIFIER = \(bundleId);",
    options: .regularExpression
)
// Set (or clear) DEVELOPMENT_TEAM in both build configs. Automatic signing reads
// it to provision the app and its Associated Domains capability at build time.
let teamPattern = "DEVELOPMENT_TEAM = [^;]*;\n\\s*"
updatedPbxproj = updatedPbxproj.replacingOccurrences(
    of: teamPattern, with: "", options: .regularExpression
)
if let teamId {
    // Inject right before CODE_SIGN_ENTITLEMENTS, present once per config.
    updatedPbxproj = updatedPbxproj.replacingOccurrences(
        of: "CODE_SIGN_ENTITLEMENTS = ",
        with: "DEVELOPMENT_TEAM = \(teamId);\n\t\t\t\tCODE_SIGN_ENTITLEMENTS = "
    )
}
try updatedPbxproj.write(toFile: pbxprojPath, atomically: true, encoding: .utf8)

// MARK: - Associated Domains entitlement

guard let entitlementsData = FileManager.default.contents(atPath: entitlementsPath) else {
    fail("\(entitlementsPath) not found — run this script from the project root")
}
guard var entitlements = try PropertyListSerialization.propertyList(from: entitlementsData, format: nil) as? [String: Any] else {
    fail("\(entitlementsPath) is not a valid property list")
}
// Universal Links (teamId present) need the webcredentials domain; the custom
// scheme (no teamId) needs no Associated Domain, so clear any stale entry.
let associatedDomainsKey = "com.apple.developer.associated-domains"
if teamId != nil {
    entitlements[associatedDomainsKey] = ["webcredentials:\(domain)"]
} else {
    entitlements.removeValue(forKey: associatedDomainsKey)
}
let updatedEntitlements = try PropertyListSerialization.data(fromPropertyList: entitlements, format: .xml, options: 0)
try updatedEntitlements.write(to: URL(fileURLWithPath: entitlementsPath))

print("""
Auth0 settings configured:
  Domain    = \(domain)
  ClientId  = \(clientId)
  BundleId  = \(bundleId)
  UseHTTPS  = \(useHTTPS)
""")

// With a Team ID, everything that lives in files is now wired (DEVELOPMENT_TEAM +
// the webcredentials Associated Domain). Only the build step is left — automatic
// signing provisions the capability with Apple at that point.
// {platform} below is ios | macos | visionos — Auth0.swift picks it per build target.
if let teamId {
    print("""

    UseHTTPS is on — the app uses a Universal Link callback on iOS 17.4+ / macOS
    14.4+ (older versions fall back to the custom URL scheme automatically).

    Team ID \(teamId) and Associated Domain webcredentials:\(domain) are written.
    One step is left (paid Apple Developer account required): open the project and
    build, so automatic signing provisions the Associated Domains capability.
           open \(FileManager.default.currentDirectoryPath)/auth0-ios-sample.xcodeproj

    The Auth0 Dashboard quickstart registers the callback/logout URLs and Device
    Settings (Team ID + App ID). If you are configuring the app outside that flow,
    register both URLs yourself — Auth0.swift uses the https one on the modern OS
    and the custom scheme on older versions ({platform} is ios/macos/visionos):
           https://\(domain)/{platform}/\(bundleId)/callback
           \(bundleId)://\(domain)/{platform}/\(bundleId)/callback

    Without a Team ID the app uses the custom URL scheme only — no signing or
    entitlement setup needed.
    """)
}
