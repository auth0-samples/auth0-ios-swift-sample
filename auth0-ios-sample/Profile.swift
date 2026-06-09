import Foundation

/// The subset of OpenID Connect claims displayed by the sample, decoded locally
/// from the ID token. No call to `/userinfo` is needed — the ID token already
/// carries the user's profile.
struct Profile {
    let sub: String?
    let name: String?
    let email: String?
    let emailVerified: Bool?
    let nickname: String?
    let picture: String?

    init?(idToken: String?) {
        guard let claims = Profile.decodeClaims(from: idToken) else { return nil }
        sub = claims["sub"] as? String
        name = claims["name"] as? String
        email = claims["email"] as? String
        emailVerified = claims["email_verified"] as? Bool
        nickname = claims["nickname"] as? String
        picture = claims["picture"] as? String
    }

    /// Decodes the payload segment of a JWT without verifying its signature
    /// (the signature was already verified by the SDK during login).
    private static func decodeClaims(from idToken: String?) -> [String: Any]? {
        let segments = idToken?.components(separatedBy: ".") ?? []
        guard segments.count == 3 else { return nil }

        var base64 = segments[1]
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        // Restore base64 padding stripped by base64url encoding.
        let remainder = base64.count % 4
        if remainder > 0 {
            base64 += String(repeating: "=", count: 4 - remainder)
        }

        guard let data = Data(base64Encoded: base64),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            return nil
        }
        return json
    }
}
