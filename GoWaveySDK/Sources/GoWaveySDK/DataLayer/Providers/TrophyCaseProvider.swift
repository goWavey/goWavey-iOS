//
//  TrophyCaseProvider.swift
//  
//
//  Created by Nikola Matijevic on 20.1.24..
//

import Foundation
import Combine

final class TrophyCaseProvider {

    let service: DataTransferService
    let authentication: Authentication

    init(service: DataTransferService, authentication: Authentication) {
        self.service = service
        self.authentication = authentication
    }
}

extension TrophyCaseProvider: GetTrophyCaseUseCase {

    func getTrophyCase(id: String) async -> AnyPublisher<TrophyCase, Error> {

        let endpoint = APIEndpoints.getTrophyCase(id: id, authentication: authentication)

        let response = await service.request(with: endpoint)

        switch response {
        case .success(let success):
            return Just(success.entity)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        case .failure(let error):
            return Fail(error: error)
                .eraseToAnyPublisher()
        }
    }
}
