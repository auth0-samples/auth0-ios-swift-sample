// Response.swift
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

func json<T>(data: NSData?) -> T? {
    guard let data = data else { return nil }
    let object = try? NSJSONSerialization.JSONObjectWithData(data, options: [])
    return object as? T
}

func string(data: NSData?) -> String? {
    guard let data = data else { return nil }
    return String(data: data, encoding: NSUTF8StringEncoding)
}

struct Response<E: Auth0Error> {
    let data: NSData?
    let response: NSURLResponse?
    let error: NSError?

    func result() throws -> AnyObject? {
        guard error == nil else { throw error! }
        guard let response = self.response as? NSHTTPURLResponse else { throw E(string: nil, statusCode: 0) }
        guard (200...300).contains(response.statusCode) else {
            if let json: [String: AnyObject] = json(data) {
                throw E(info: json)
            }
            throw E(string: string(data), statusCode: response.statusCode)
        }
        guard let data = self.data else {
            if response.statusCode == 204 {
                return nil
            }
            throw E(string: nil, statusCode: response.statusCode)
        }
        if let json: AnyObject = json(data) {
            return json
        }
        // This piece of code is dedicated to our friends the backend devs :)
        if response.URL?.lastPathComponent == "change_password" {
            return nil
        } else {
            throw E(string: string(data), statusCode: response.statusCode)
        }
    }
}
