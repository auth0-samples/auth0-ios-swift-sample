#!/usr/bin/env bash
# Configures the sample app with your Auth0 credentials:
#   - writes Domain and ClientId into auth0-ios-sample/Auth0.plist
#   - sets the bundle identifier in the Xcode project (used as the callback scheme)
set -euo pipefail

usage() { echo "Usage: $0 --domain <auth0-domain> --client-id <client-id> --bundle-id <bundle-id>"; exit 1; }

DOMAIN=""; CLIENT_ID=""; BUNDLE_ID=""
while [ $# -gt 0 ]; do
  case "$1" in
    --domain)    DOMAIN="$2"; shift 2;;
    --client-id) CLIENT_ID="$2"; shift 2;;
    --bundle-id) BUNDLE_ID="$2"; shift 2;;
    *) usage;;
  esac
done
[ -n "$DOMAIN" ] && [ -n "$CLIENT_ID" ] && [ -n "$BUNDLE_ID" ] || usage

PLIST="auth0-ios-sample/Auth0.plist"
PBXPROJ="auth0-ios-sample.xcodeproj/project.pbxproj"
[ -f "$PLIST" ]   || { echo "Run this script from the project root ($PLIST not found)"; exit 1; }
[ -f "$PBXPROJ" ] || { echo "Run this script from the project root ($PBXPROJ not found)"; exit 1; }

/usr/libexec/PlistBuddy -c "Set :Domain $DOMAIN" -c "Set :ClientId $CLIENT_ID" "$PLIST"

# Replace every PRODUCT_BUNDLE_IDENTIFIER occurrence (Debug + Release configs).
/usr/bin/sed -i '' "s/PRODUCT_BUNDLE_IDENTIFIER = [^;]*;/PRODUCT_BUNDLE_IDENTIFIER = $BUNDLE_ID;/g" "$PBXPROJ"

echo "Auth0 settings configured:"
echo "  Domain    = $DOMAIN"
echo "  ClientId  = $CLIENT_ID"
echo "  BundleId  = $BUNDLE_ID"
