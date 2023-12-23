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
            bodyParametersEncodable: ActivityDTO(activity)
        )
    }
}
