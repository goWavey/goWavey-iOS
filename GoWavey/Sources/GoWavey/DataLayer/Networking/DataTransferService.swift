//
//  DataTransferService.swift
//  
//
//  Created by Nikola Matijevic on 21.12.23..
//

import Foundation
import Combine

enum DataTransferError: Error {
    case noResponse
    case parsing(Error)
    case networkFailure(NetworkError)
    case resolvedNetworkFailure(Error)
    case invalidResponse
}

protocol DataTransferService {

    func request<D: Decodable, T: ResponseRequestable>(with endpoint: T) async -> Result<D, DataTransferError> where T.Response == D
    func request<T: ResponseRequestable>(with endpoint: T) async -> Result<Void, DataTransferError> where T.Response == Void
//    func upload<D: Decodable, T: ResponseRequestable>(with endpoint: T) async -> Result<D, DataTransferError> where T.Response == D
//    func upload<T: ResponseRequestable>(with endpoint: T) async -> Result<Void, DataTransferError> where T.Response == Void
}

protocol DataTransferErrorResolver {

    func resolve(error: NetworkError) -> Error
}

protocol DataTransferErrorLogger {

    func log(error: Error)
}

class DefaultDataTransferService {

    private let networkService: NetworkService
    private let errorResolver: DataTransferErrorResolver
    private let errorLogger: DataTransferErrorLogger

    init(networkService: NetworkService,
         errorResolver: DataTransferErrorResolver = DefaultDataTransferErrorResolver(),
         errorLogger: DataTransferErrorLogger = DefaultDataTransferErrorLogger()) {

        self.networkService = networkService
        self.errorResolver = errorResolver
        self.errorLogger = errorLogger
    }
}

// MARK: DataTransferService

extension DefaultDataTransferService: DataTransferService {

    func request<D: Decodable, T: ResponseRequestable>(with endpoint: T) async -> Result<D, DataTransferError> where T.Response == D {

        let result = await networkService.requestAsync(endpoint: endpoint)

        switch result {

        case .success(let data):
            return self.decode(data: data, decoder: endpoint.responseDecoder)

        case .failure(let error):
            return .failure(self.resolve(error: error))
        }
    }

    func request<T: ResponseRequestable>(with endpoint: T) async -> Result<Void, DataTransferError> where T.Response == Void {

        let result = await networkService.requestAsync(endpoint: endpoint)

        switch result {

        case .success:
            return .success(())

        case .failure(let error):
            return .failure(self.resolve(error: error))
        }
    }

//    func upload<D: Decodable, T: ResponseRequestable>(with endpoint: T) async -> Result<D, DataTransferError> where T.Response == D {
//
//        let result = await networkService.upload(with: endpoint)
//
//        switch result {
//
//        case .success(let data):
//            return self.decode(data: data, decoder: endpoint.responseDecoder)
//
//        case .failure(let error):
//            return .failure(self.resolve(error: error))
//        }
//    }
//
//    func upload<T: ResponseRequestable>(with endpoint: T) async -> Result<Void, DataTransferError> where T.Response == Void {
//
//        let result = await networkService.upload(with: endpoint)
//
//        switch result {
//
//        case .success:
//            return .success(())
//
//        case .failure(let error):
//            return .failure(self.resolve(error: error))
//        }
//    }
}

// MARK: Private

private extension DefaultDataTransferService {

    func decode<T: Decodable>(data: Data?, decoder: ResponseDecoder) -> Result<T, DataTransferError> {

        do {

            guard let data = data else { return .failure(.noResponse) }

            let result: T = try decoder.decode(data)

            return .success(result)

        } catch let error {

            if let error = error as? DecodingError {
                var errorToReport = error.localizedDescription
                switch error {
                case .dataCorrupted(let context):
                    let details = context.underlyingError?.localizedDescription ?? context.codingPath.map { $0.stringValue }.joined(separator: ".")
                    errorToReport = "\(context.debugDescription) - (\(details))"
                case .keyNotFound(let key, let context):
                    let details = context.underlyingError?.localizedDescription ?? context.codingPath.map { $0.stringValue }.joined(separator: ".")
                    errorToReport = "\(context.debugDescription) (key: \(key), \(details))"
                case .typeMismatch(let type, let context), .valueNotFound(let type, let context):
                    let details = context.underlyingError?.localizedDescription ?? context.codingPath.map { $0.stringValue }.joined(separator: ".")
                    errorToReport = "\(context.debugDescription) (type: \(type), \(details))"
                @unknown default:
                    break
                }
                print(errorToReport)
                print("")
            }

            return .failure(.parsing(error))
        }
    }

    func resolve(error: NetworkError) -> DataTransferError {

        let resolvedError = self.errorResolver.resolve(error: error)
        return resolvedError is NetworkError ? .networkFailure(error) : .resolvedNetworkFailure(resolvedError)
    }
}

protocol Logger {

    func log(request: URLRequest)
    func log(responseData data: Data?, response: HTTPURLResponse?)
    func log(error: Error)
}

public protocol ErrorResolver {

    func resolve(error: Error) -> Error
}

protocol ResponseDecoder {

    func decode<T: Decodable>(_ data: Data) throws -> T
}

final class DefaultJSONResponseDecoder: ResponseDecoder {

    func decode<T>(_ data: Data) throws -> T where T: Decodable {

        return try JSONDecoder().decode(T.self, from: data)
    }
}

final class DefaultDataTransferErrorResolver: DataTransferErrorResolver {

    func resolve(error: NetworkError) -> Error {

        return error
    }
}

final class DefaultDataTransferErrorLogger: DataTransferErrorLogger {

    func log(error: Error) {

        printIfDebug("---------Error-------------")
        printIfDebug("\(error)")
    }
}

func printIfDebug(_ string: String) {
    #if DEBUG
    print(string)
    #endif
}
