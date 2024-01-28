//
//  File.swift
//  
//
//  Created by Nikola Matijevic on 21.12.23..
//

import Foundation

public enum BodyEncoding {

    case jsonSerializationData
    case stringEncodingAscii
}

class Endpoint<R>: ResponseRequestable {
    

    typealias Response = R

    let route: EndpointRoute
    let method: HttpMethod
    let headers: [String: String]
    let queryParameters: [String: Any]?
    let queryParametersEncodable: Encodable?
    let bodyParameters: [String: Any]?
    let bodyParametersEncodable: Encodable?
    let bodyEncoding: BodyEncoding
    let responseDecoder: ResponseDecoder
    let authentication: Authentication?
    let boundary: String

    init(route: EndpointRoute,
         method: HttpMethod,
         headers: [String: String] = [:],
         queryParameters: [String: Any]? = nil,
         queryParametersEncodable: Encodable? = nil,
         bodyParameters: [String: Any]? = nil,
         bodyParametersEncodable: Encodable? = nil,
         bodyEncoding: BodyEncoding = .jsonSerializationData,
         responseDecoder: ResponseDecoder = DefaultJSONResponseDecoder(),
         authentication: Authentication? = nil,
         boundary: String = UUID().uuidString) {

        self.route = route
        self.method = method
        self.headers = headers
        self.queryParameters = queryParameters
        self.queryParametersEncodable = queryParametersEncodable
        self.bodyParameters = bodyParameters
        self.bodyParametersEncodable = bodyParametersEncodable
        self.bodyEncoding = bodyEncoding
        self.responseDecoder = responseDecoder
        self.authentication = authentication
        self.boundary = boundary
    }
}
