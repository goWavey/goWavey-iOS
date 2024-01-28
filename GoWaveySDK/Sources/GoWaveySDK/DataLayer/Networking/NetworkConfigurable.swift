//
//  NetworkConfigurable.swift
//  
//
//  Created by Nikola Matijevic on 21.12.23..
//

import Foundation

protocol NetworkConfigurable {

    var baseUrl: URL { get }
    var headers: [String: String] { get }
    var queryParameters: [String: String] { get }
}

struct ApiDataNetworkConfig: NetworkConfigurable {

    let baseUrl: URL
    let headers: [String: String]
    let queryParameters: [String: String]

    init(baseUrl: URL,
         headers: [String: String] = [:],
         queryParameters: [String: String] = [:]) {

        self.baseUrl = baseUrl
        self.headers = headers
        self.queryParameters = queryParameters
    }
}
