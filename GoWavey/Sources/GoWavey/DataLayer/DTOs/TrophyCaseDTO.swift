//
//  TrophyCaseDTO.swift
//
//
//  Created by Nikola Matijevic on 20.1.24..
//

import Foundation

struct TrophyCaseDTO: Codable {
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

    var entity: TrophyCase {
        
        TrophyCase(
            trophies: rewards.map { reward in
                Badge(
                    id: UUID().uuidString,
                    name: reward.name,
                    description: reward.description,
                    iconUrl: reward.badgeURL
                )
            }
        )
    }
}
