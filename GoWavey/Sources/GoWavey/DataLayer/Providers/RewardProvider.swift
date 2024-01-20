//
//  RewardProvider.swift
//
//
//  Created by Nikola Matijevic on 24.12.23..
//

import Foundation
import Combine

final class RewardProvider {

    let service: DataTransferService

    init(service: DataTransferService) {
        self.service = service
    }
}

extension RewardProvider: RewardDetailsUseCase {
    func getRewardDetails(id: String) async -> AnyPublisher<Reward, Error> {

        let reward = Reward(
            id: UUID().uuidString,
            name: UUID().uuidString,
            description: UUID().uuidString,
            iconUrl: UUID().uuidString
        )

        return Just(reward)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
