//
//  APIEndpoints.swift
//
//
//  Created by Nikola Matijevic on 23.12.23..
//

import Foundation

enum APIEndpoints {

    static func updateActivity(_ activity: Activity, authentication: Authentication) -> Endpoint<UpdateActivityDTO> {

        Endpoint(
            route: .updateUserActivity,
            method: .post,
            bodyParameters: ["activityId" : activity.id,
                             "value": activity.value],
            authentication: authentication
        )
    }

    static func getTrophyCase(id: String, authentication: Authentication) -> Endpoint<TrophyCaseDTO> {

        Endpoint(
            route: .trophyCase,
            method: .get,
            queryParameters: ["trophyId" : id],
            authentication: authentication
        )
    }
}
