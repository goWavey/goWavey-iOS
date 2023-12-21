//
//  Authentication.swift
//  
//
//  Created by Nikola Matijevic on 21.12.23..
//

import Foundation

protocol Authentication {

    func authenticate(_ request: URLRequest) async throws -> URLRequest
}
