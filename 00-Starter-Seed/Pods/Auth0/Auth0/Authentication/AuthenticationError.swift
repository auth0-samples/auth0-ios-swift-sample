// AuthenticationError.swift
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

import Foundation

/**
 *  Represents an error during a request to Auth0 Authentication API
 */
public class AuthenticationError: NSObject, Auth0Error {

    /**
     Additional information about the error
     - seeAlso: `code` & `description` properties
     */
    public let info: [String: AnyObject]

    /**
     Creates a Auth0 Auth API error when the request's response is not JSON

     - parameter string:     string representation of the response (or nil)
     - parameter statusCode: response status code

     - returns: a newly created AuthenticationError
     */
    public required init(string: String? = nil, statusCode: Int = 0) {
        self.info = [
            "code": string != nil ? NonJSONError : EmptyBodyError,
            "description": string ?? "Empty response body",
            "statusCode": statusCode
        ]
    }

    /**
     Creates a Auth0 Auth API error from a JSON response

     - parameter info: JSON response from Auth0

     - returns: a newly created AuthenticationError
     */
    public required init(info: [String: AnyObject]) {
        self.info = info
    }

    /**
     Auth0 error code if the server returned one or an internal library code (e.g.: when the server could not be reached)
     */
    public var code: String {
        let code = self.info["error"] ?? self.info["code"]
        return code as? String ?? UnknownError
    }

    /**
     Description of the error
     - important: You should avoid displaying description to the user, it's meant for debugging only.
     */
    public override var description: String {
        let description = self.info["description"] ?? self.info["error_description"]
        if let string = description as? String {
            return string
        }

        guard self.code == UnknownError else { return "Received error with code \(self.code)" }

        return "Failed with unknown error \(self.info)"
    }

    /// When MFA code is required to authenticate
    public var isMultifactorRequired: Bool {
        return self.code == "a0.mfa_required"
    }

    /// When MFA is required and the user is not enrolled
    public var isMultifactorEnrollRequired: Bool {
        return self.code == "a0.mfa_registration_required"
    }

    /// When MFA code sent is invalid or expired
    public var isMultifactorCodeInvalid: Bool {
        return self.code == "a0.mfa_invalid_code"
    }

    /// When password used for SignUp does not match connection's strength requirements. More info will be available in `info`
    public var isPasswordNotStrongEnough: Bool {
        return self.code == "invalid_password" &&  self.value("name") == "PasswordStrengthError"
    }

    /// When password used for SignUp was already used before (Reported when password history feature is enabled). More info will be available in `info`
    public var isPasswordAlreadyUsed: Bool {
        return self.code == "invalid_password" &&  self.value("name") == "PasswordHistoryError"
    }

    /// When Auth0 rule returns an error. The message returned by the rull will be in `description`
    public var isRuleError: Bool {
        return self.code == "unauthorized"
    }

    /// When username and/or password used for authentication are invalid
    public var isInvalidCredentials: Bool {
        return self.code == "invalid_user_password"
    }

    /// When authenticating with web-based authentication and the resource server denied access per OAuth2 spec
    public var isAccessDenied: Bool {
        return self.code == "access_denied"
    }

    /**
     Returns a value from error `info` dictionary

     - parameter key: key of the value to return

     - returns: the value of key or nil if cannot be found or is of the wrong type.
     */
    public func value<T>(key: String) -> T? { return self.info[key] as? T }
}

extension AuthenticationError: FoundationErrorConvertible {
    @nonobjc static let FoundationDomain = "com.auth0.authentication"
    @nonobjc static let FoundationUserInfoKey = "com.auth0.authentication.error.info"
    
    public func newFoundationError() -> NSError {
        return NSError(domain: AuthenticationError.FoundationDomain, code: 1, userInfo: [
            NSLocalizedDescriptionKey: self.description,
            AuthenticationError.FoundationUserInfoKey: self,
            ])
    }
}