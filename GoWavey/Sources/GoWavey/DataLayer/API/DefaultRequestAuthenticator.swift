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

    init(authToken: String) {

        self.authToken = authToken
    }

    func authenticate(_ request: URLRequest) async throws -> URLRequest {

        var _request = request

        _request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")

        return _request
    }
}
