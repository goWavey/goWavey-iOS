//
//  NetworkSessionManager.swift
//
//
//  Created by Nikola Matijevic on 21.12.23..
//

import Foundation
import Combine

protocol NetworkSessionManager {

    func perform(request: URLRequest) -> AnyPublisher<Data?, Error>
    func perform(request: URLRequest) async throws -> (Data, URLResponse)
    func upload(request: URLRequest, from body: Data) async throws -> (Data, URLResponse)
}

class DefaultNetworkSessionManager: NetworkSessionManager {

    private var hasAlreadyFailedWith401 = false

    func perform(request: URLRequest) -> AnyPublisher<Data?, Error> {

        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, _ in data }
            .tryCatch { error -> AnyPublisher<Data?, Error> in

                return Fail(error: error).eraseToAnyPublisher()
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    func perform(request: URLRequest) async throws -> (Data, URLResponse) {

        return try await URLSession.shared.data(for: request)
    }

    func upload(request: URLRequest, from body: Data) async throws -> (Data, URLResponse) {

        return try await URLSession.shared.upload(for: request, from: body)
    }
}

enum APIError: Error, Equatable {

    case dataParseFailed
    case unauthenticated
    case unknown(reason: String)
    case canceled
    case urlGeneration
}

struct ErrorDTO: Codable {

    let message: String
}
