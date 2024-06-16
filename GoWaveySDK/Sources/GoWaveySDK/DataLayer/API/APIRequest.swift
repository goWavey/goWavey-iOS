//
//  File.swift
//  
//
//  Created by Nikola Matijevic on 21.12.23..
//

import Foundation

enum HttpMethod: String {

    case post = "POST"
    case get = "GET"
    case put = "PUT"
}

struct BodyParameter: Equatable {

    let key: String
    let value: AnyHashable
}

protocol Requestable {

    associatedtype Response

    var route: EndpointRoute { get }
    var method: HttpMethod { get }
    var headers: [String: String] { get }
    var queryParameters: [String: Any]? { get }
    var queryParametersEncodable: Encodable? { get }
    var bodyParameters: [String: Any]? { get }
    var bodyParametersEncodable: Encodable? { get }
    var bodyEncoding: BodyEncoding { get }
    var authentication: Authentication? { get }

    func urlRequest(with config: NetworkConfigurable) throws -> URLRequest
}

protocol ResponseRequestable: Requestable {

    associatedtype Response

    var responseDecoder: ResponseDecoder { get }
}

extension Requestable {

    private func url(with config: NetworkConfigurable) throws -> URL {

        let baseUrl = config.baseUrl.absoluteString.last != "/" ? config.baseUrl.absoluteString + "/" : config.baseUrl.absoluteString
        let route = baseUrl.appending(route.path)

        guard var urlComponents = URLComponents(string: route) else { throw APIRequestError.urlMalformed }
        var urlQueryItems = [URLQueryItem]()

        if let queryParameters = try? queryParametersEncodable?.toDictionary() ?? queryParameters {

            queryParameters.forEach { urlQueryItems.append(URLQueryItem(name: $0.key, value: "\($0.value)")) }
        }

        config.queryParameters.forEach { urlQueryItems.append(URLQueryItem(name: $0.key, value: $0.value)) }

        urlComponents.queryItems = !urlQueryItems.isEmpty ? urlQueryItems : nil
        guard let url = urlComponents.url else { throw APIRequestError.urlMalformed }

        return url
    }

    func urlRequest(with config: NetworkConfigurable) throws -> URLRequest {

        let url = try self.url(with: config)
        var urlRequest = URLRequest(url: url)
        var allHeaders: [String: String] = config.headers

        headers.forEach { allHeaders.updateValue($1, forKey: $0) }

        if let bodyParametersEncodable = try? bodyParametersEncodable?.toDictionary() ?? bodyParameters {

            let body = try? JSONSerialization.data(withJSONObject: bodyParametersEncodable)
            urlRequest.httpBody = body
        }

        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = allHeaders

        return urlRequest
    }
}

//extension APIRequest: ResponseRequestable {}

enum APIRequestError: Error {
    case urlMalformed
    case bodyDataMalformed
}

extension Array where Element == BodyParameter {

    func toDictionary() -> [String: AnyHashable] {

        var dict = [String: AnyHashable]()

        self.forEach {
            dict[$0.key] = $0.value
        }

        return dict
    }
}

private extension Encodable {

    func toDictionary() throws -> [String: Any]? {

        let data = try JSONEncoder().encode(self)
        let josnData = try JSONSerialization.jsonObject(with: data)

        return josnData as? [String: Any]
    }
}
