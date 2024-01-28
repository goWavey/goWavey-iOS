//
//  File.swift
//  
//
//  Created by Nikola Matijevic on 21.12.23..
//

import Foundation

enum EndpointRoute {

    case updateUserActivity
    case trophyCase

    var path: String {

        switch self {

        case .updateUserActivity:
            return "activities/process"
        case .trophyCase:
            return "trophies"
        }
    }
}
