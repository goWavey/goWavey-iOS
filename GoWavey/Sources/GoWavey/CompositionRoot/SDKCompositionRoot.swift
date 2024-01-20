//
//  SDKCompositionRoot.swift
//
//
//  Created by Nikola Matijevic on 23.12.23..
//

import Foundation


final class SDKCompositionRoot: TrophyCaseVMDependencies {

    private let authToken: String
    private let memberId: String

    init(authToken: String,
         memberId: String) {
        self.authToken = authToken
        self.memberId = memberId
    }

    //MARK: Networking Config Composition
    lazy private var requestAuthenticator = DefaultRequestAuthenticator(authToken: authToken, memberId: memberId)

    lazy private var networkConfig = ApiDataNetworkConfig(baseUrl: URL(string: "https://jjx9q27w5k.execute-api.us-east-1.amazonaws.com/stage")!)

    lazy private var  networkService = DefaultNetworkService(config: networkConfig)

    lazy private var dataTransferService: DataTransferService = DefaultDataTransferService(networkService: networkService, errorResolver: DefaultErrorResolver())

    //MARK: Use Cases composition
    lazy var updateActivityUseCase: UpdateActivityUseCase = ActivityProvider(service: dataTransferService)
    lazy var getTrophyCaseUseCase: GetTrophyCaseUseCase  = TrophyCaseProvider(service: dataTransferService)
}
