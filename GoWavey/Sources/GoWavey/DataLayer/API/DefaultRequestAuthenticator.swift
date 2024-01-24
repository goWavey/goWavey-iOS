//
//  DefaultRequestAuthenticator.swift
//
//
//  Created by Nikola Matijevic on 21.12.23..
//

import Foundation

/// Adds access token to the request headers alongside default headers added in dependency container
final class DefaultRequestAuthenticator: Authentication {

    let authToken: String
    let memberId: String

    init(authToken: String,
         memberId: String) {

        self.authToken = authToken
        self.memberId = memberId
    }

    func authenticate(_ request: URLRequest) async throws -> URLRequest {

        var _request = request

        _request.setValue(authToken, forHTTPHeaderField: "Authorization")
        _request.setValue(memberId, forHTTPHeaderField: "x-member-id")

        return _request
    }
}
