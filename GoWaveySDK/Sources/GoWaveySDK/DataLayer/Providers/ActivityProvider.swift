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
    let authentication: Authentication

    init(service: DataTransferService, authentication: Authentication) {
        self.service = service
        self.authentication = authentication
    }
}

extension ActivityProvider: UpdateActivityUseCase {

    func updateActivity(_ activity: Activity) async -> AnyPublisher<UpdateActivityResponse, Error> {

        let endpoint = APIEndpoints.updateActivity(activity, authentication: authentication)

        let response = await service.request(with: endpoint)

        switch response {
        case .success(let success):

            let badges = success.payload.body.map(\.badgeEntity)

            let response = UpdateActivityResponse(message: "Successfully updated the activity", badges: badges)

            return Just(response)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        case .failure(let error):
            return Fail(error: error)
                .eraseToAnyPublisher()
        }
    }
}
