//
//  TrophyCaseDTO.swift
//
//
//  Created by Nikola Matijevic on 20.1.24..
//

import Foundation

struct TrophyCaseDTO {
    let object: String
    let rewards: [RewardDTO]

    // MARK: - Reward
    struct RewardDTO: Codable {
        let name, description, badgeURL, animationID: String
        let isAchieved: Bool

        enum CodingKeys: String, CodingKey {
            case name, description
            case badgeURL = "badgeUrl"
            case animationID = "animationId"
            case isAchieved
        }
    }
}
