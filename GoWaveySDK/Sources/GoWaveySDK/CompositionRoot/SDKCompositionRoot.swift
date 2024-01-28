//
//  SDKCompositionRoot.swift
//
//
//  Created by Nikola Matijevic on 23.12.23..
//

import Foundation


final class SDKCompositionRoot {

    private let authToken: String
    private let memberId: String

    enum Constants {

        static let acceptedTypes = "*/*"
        static let contentType = "application/json"
    }


    private lazy var headers = ["Accept": Constants.acceptedTypes,
                                "Content-type": Constants.contentType]


    private static var cache: [String: Any] = [:]
    private static var factories: [String: () -> Any] = [:]

    init(
        authToken: String,
         memberId: String
    ) {
        self.authToken = authToken
        self.memberId = memberId
    }
}

extension SDKCompositionRoot {

    func createDependencies() {
        let requestAuthenticator = DefaultRequestAuthenticator(authToken: authToken, memberId: memberId)

        let networkConfig = ApiDataNetworkConfig(baseUrl: URL(string: "https://jjx9q27w5k.execute-api.us-east-1.amazonaws.com/stage")!)

        lazy var  networkService = DefaultNetworkService(config: networkConfig)

        lazy var dataTransferService: DataTransferService = DefaultDataTransferService(networkService: networkService, errorResolver: DefaultErrorResolver())

        lazy var updateActivityUseCase: UpdateActivityUseCase = ActivityProvider(service: dataTransferService, authentication: requestAuthenticator)
        lazy var trophyCaseProvider = TrophyCaseProvider(service: dataTransferService, authentication: requestAuthenticator)

        Self.register(type: GetTrophyCaseUseCase.self, trophyCaseProvider)
    }
}

extension SDKCompositionRoot {

    static func register<T>(type: T.Type, as dependencyType: DependencyType = .automatic, _ factory: @autoclosure @escaping () -> T) {

        factories[String(describing: type.self)] = factory

        if dependencyType == .singleton {
            cache[String(describing: type.self)] = factory()
        }
    }

    static func resolve<T>(dependencyType: DependencyType = .automatic, _ type: T.Type) -> T? {

        let key = String(describing: type.self)

        switch dependencyType {

        case .singleton:
            guard let cachedInstance = cache[key] as? T else {

                fatalError("\(key) is not registered as a Singleton")
            }

            return cachedInstance

        case .automatic:
            if let cachedInstance = cache[key] as? T {
                return cachedInstance
            }

            fallthrough

        case .newInstance:
            if let instance = factories[key]?() as? T {

                cache[key] = instance

                return instance

            } else {

                return nil
            }
        }
    }
}
