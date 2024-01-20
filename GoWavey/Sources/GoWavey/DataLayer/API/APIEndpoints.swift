//
//  APIEndpoints.swift
//
//
//  Created by Nikola Matijevic on 23.12.23..
//

import Foundation

enum APIEndpoints {

    static func updateActivity(_ activity: Activity) -> Endpoint<String> {

        Endpoint(
            route: .updateUserActivity,
            method: .post,
            bodyParameters: ["activityId" : activity.id,
                             "value": activity.value]
        )
    }

    static func getTrophyCase(id: String) -> Endpoint<TrophyCaseDTO> {

        Endpoint(
            route: .trophyCase,
            method: .get,
            queryParameters: ["trophyId" : id]
        )
    }
}
