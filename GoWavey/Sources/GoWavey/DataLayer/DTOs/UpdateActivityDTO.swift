//
//  UpdateActivityDTO.swift
//  
//
//  Created by Nikola Matijevic on 22.1.24..
//

import Foundation

struct UpdateActivityDTO: Codable {
    let payload: UpdateActivityDTOPayload

    enum CodingKeys: String, CodingKey {
        case payload = "Payload"
    }
}

struct UpdateActivityDTOPayload: Codable {
    let body: [UpdateActivityBadgeDTO]
}

struct UpdateActivityBadgeDTO: Codable {

    let dateCreated, status, description: String
    let attributes: Attributes
    let id, type, name: String

    enum CodingKeys: String, CodingKey {
        case dateCreated = "Date Created"
        case status = "Status"
        case description = "Description"
        case attributes = "Attributes"
        case id = "ID"
        case type = "Type"
        case name = "Name"
    }

    struct Attributes: Codable {
        let activityID, goalDefintion, animationURL, rewardTitle: String
        let trophyCase: String
        let imageURL: String

        enum CodingKeys: String, CodingKey {
            case activityID = "activityId"
            case goalDefintion
            case animationURL = "animationUrl"
            case rewardTitle, trophyCase
            case imageURL = "imageUrl"
        }
    }

    var badgeEntity: Badge {

        Badge(
            id: id,
            name: name,
            description: description,
            iconUrl: attributes.imageURL,
            isAchieved: true
        )
    }
}

