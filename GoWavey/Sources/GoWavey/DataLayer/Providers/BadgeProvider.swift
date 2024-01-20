//
//  BadgeProvider.swift
//
//
//  Created by Nikola Matijevic on 24.12.23..
//

import Foundation
import Combine

final class BadgeProvider {

    let service: DataTransferService

    init(service: DataTransferService) {
        self.service = service
    }
}

extension BadgeProvider: BadgeDetailsUseCase {

    func getBadgeDetails(id: String) async -> AnyPublisher<Badge, Error> {

        let badge = Badge(
            id: UUID().uuidString,
            name: String(UUID().uuidString.prefix(5)),
            description: UUID().uuidString,
            iconUrl: ""
        )

        return Just(badge)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
