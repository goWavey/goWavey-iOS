//
//  SDKCompositionRoot.swift
//
//
//  Created by Nikola Matijevic on 23.12.23..
//

import Foundation


final class SDKCompositionRoot {

    private let authToken: String

    init(authToken: String) {
        self.authToken = authToken
    }

    //MARK: Networking Config Composition
    lazy private var requestAuthenticator = DefaultRequestAuthenticator(authToken: authToken)

    lazy private var networkConfig = ApiDataNetworkConfig(baseUrl: URL(string: "www.google.com")!)

    lazy private var  networkService = DefaultNetworkService(config: networkConfig)

    lazy private var dataTransferService: DataTransferService = DefaultDataTransferService(networkService: networkService, errorResolver: DefaultErrorResolver())


    //MARK: Use Cases composition
    lazy var updateActivityUseCase: UpdateActivityUseCase = ActivityProvider(service: dataTransferService)

}
