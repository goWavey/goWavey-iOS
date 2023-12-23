//
//  ActivityProvider.swift
//
//
//  Created by Nikola Matijevic on 23.12.23..
//

import Foundation
import Combine

final class ActivityProvider {

    let service: DataTransferService

    init(service: DataTransferService) {
        self.service = service
    }
}

extension ActivityProvider: UpdateActivityUseCase {

    func updateActivity(_ activity: Activity) async -> AnyPublisher< String, Error> {

        let endpoint = APIEndpoints.updateActivity(activity)

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
