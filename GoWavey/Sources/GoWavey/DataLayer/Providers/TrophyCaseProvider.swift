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

    init(service: DataTransferService) {
        self.service = service
    }
}

extension TrophyCaseProvider {

    func getTrophyCase(id: String) async -> AnyPublisher<String, Error> {
        
        let endpoint = APIEndpoints.getTrophyCase(id: id)

        let response = await service.request(with: endpoint)

        switch response {
        case .success(let success):
            return Just("")
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        case .failure(let error):
            return Fail(error: error)
                .eraseToAnyPublisher()
        }
    }
}
