//
//  NetworkService.swift
//
//
//  Created by Nikola Matijevic on 21.12.23..
//

import Foundation
import Combine

// MARK: APIError

enum NetworkError: Error {

    case cancelled
    case error(statusCode: Int, data: Data?)
    case generic(Error)
    case notConnected
    case urlGeneration
    case invalidResponse
}

protocol NetworkService {

    func request(endpoint: any ResponseRequestable) -> AnyPublisher<Data?, NetworkError>
    func requestAsync(endpoint: any ResponseRequestable) async -> Result<Data?, NetworkError>
//    func upload<T: ResponseRequestable>(with endpoint: T) async -> Result<Data?, NetworkError>
}

class DefaultNetworkService {

    private enum Constants {

        static let successResponseRange = 200...299
    }

    let config: NetworkConfigurable
    let sessionManager: NetworkSessionManager
    let logger: NetworkLogger

    init(config: NetworkConfigurable,
         sessionManager: NetworkSessionManager = DefaultNetworkSessionManager(),
         logger: NetworkLogger = DefaultNetworkLogger()) {

        self.config = config
        self.sessionManager = sessionManager
        self.logger = logger
    }

    private func perform(request: URLRequest) -> AnyPublisher<Data?, NetworkError> {

        logger.log(request: request)

        return sessionManager.perform(request: request)
            .tryMap { data in

                return data
            }
            .mapError { error in

                self.logger.log(error: error)

                return self.resolve(error: error)
            }
            .eraseToAnyPublisher()
    }

    private func perform(request: URLRequest) async -> Result<Data?, NetworkError> {

        do {

            self.logger.log(request: request)

            let (data, response) = try await sessionManager.perform(request: request)

            self.logger.log(responseData: data, response: response as? HTTPURLResponse)

            return try parseReponse(data: data, response: response)

        } catch {

            self.logger.log(error: error)

            return .failure(self.resolve(error: error))
        }
    }
}

extension DefaultNetworkService: NetworkService {

    func request(endpoint: any ResponseRequestable) -> AnyPublisher<Data?, NetworkError> {

        do {

            let request = try endpoint.urlRequest(with: config)
            return perform(request: request)

        } catch {

            if let networkError = error as? NetworkError {
                switch networkError {

                case .error(_, let data):
                    return Fail(error: self.resolve(error: error, data: data)).eraseToAnyPublisher()
                default:
                    return Fail(error: self.resolve(error: error)).eraseToAnyPublisher()
                }
            }

            return Fail(error: self.resolve(error: error)).eraseToAnyPublisher()
        }
    }

    func requestAsync(endpoint: any ResponseRequestable) async -> Result<Data?, NetworkError> {

        do {

            let request = try await self.authenticate(endpoint: endpoint)

            return await perform(request: request)

        } catch {

            if let networkError = error as? NetworkError {
                switch networkError {

                case .error(_, let data):
                    return .failure(self.resolve(error: error, data: data))
                default:
                    return .failure(self.resolve(error: error))
                }
            }

            return .failure(self.resolve(error: error))
        }
    }

//    func upload<T: ResponseRequestable>(with endpoint: T) async -> Result<Data?, NetworkError> {
//
//        do {
//
//            var request = try await self.authenticate(endpoint: endpoint)
//
//            request.setValue("\(endpoint.uploadBody.count)", forHTTPHeaderField: "Content-Length")
//            request.httpBody = endpoint.uploadBody
//
//            let (data, response) = try await self.sessionManager.perform(request: request)
//
//            return try parseReponse(data: data, response: response)
//
//        } catch {
//
//            if let networkError = error as? NetworkError {
//                switch networkError {
//
//                case .error(_, let data):
//                    return .failure(self.resolve(error: error, data: data))
//                default:
//                    return .failure(self.resolve(error: error))
//                }
//            }
//
//            return .failure(self.resolve(error: error))
//        }
//    }
}

// MARK: Private

private extension DefaultNetworkService {

    func resolve(error: Error, data: Data? = nil) -> NetworkError {

        let code = URLError.Code(rawValue: (error as NSError).code)

        if let data {
            return .error(statusCode: code.rawValue, data: data)
        }

        switch code {

        case .notConnectedToInternet: return .notConnected
        case .cancelled: return .cancelled
        default: return .generic(error)
        }
    }

    func authenticate(endpoint: any Requestable) async throws -> URLRequest {

        let request = try endpoint.urlRequest(with: self.config)

        if let authentication = endpoint.authentication {

            let authenticatedRequest = try await authentication.authenticate(request)

            return authenticatedRequest
        }

        return request
    }

    func parseReponse(data: Data?,
                      response: URLResponse) throws -> Result<Data?, NetworkError> {

        guard let validResponse = response as? HTTPURLResponse else { throw NetworkError.invalidResponse }

        if Constants.successResponseRange ~= validResponse.statusCode {

            return .success(data)

        } else {

            throw NetworkError.error(statusCode: validResponse.statusCode, data: data)
        }
    }
}

class DefaultNetworkLogger: NetworkLogger {

    func log(request: URLRequest) {

        print("\n----------------------\n")
        print("Request: \(request.url)")
        print("Headers: \(request.allHTTPHeaderFields)")
        print("Http method: \(request.httpMethod)")

        if let httpBody = request.httpBody {

            if let result = ((try? JSONSerialization.jsonObject(with: httpBody, options: []) as? [String: AnyObject]) as [String: AnyObject]??) {

                printIfDebug("body: \(String(describing: result))")

            } else if let result = String(data: httpBody, encoding: .utf8) {

                printIfDebug("body: \(String(describing: result)) ")
            }
        }
    }

    func log(responseData data: Data?, response: HTTPURLResponse?) {

        guard let data else { return }

        if let dataDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {

            printIfDebug("Response data: \(String(describing: dataDict))")
        }
    }

    func log(error: Error) {

        print("\n - - - - - - - - - - ERROR - - - - - - - - - - \n")
        printIfDebug("\(error)")
    }
}

private extension URLRequest {

    mutating func setAuthorization(_ token: String) {

        self.setValue("Bearer \(token)", forHTTPHeaderField: "Token")
    }
}

protocol NetworkLogger {

    func log(request: URLRequest)
    func log(responseData data: Data?, response: HTTPURLResponse?)
    func log(error: Error)
}
