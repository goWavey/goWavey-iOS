//
//  File.swift
//  
//
//  Created by Nikola Matijevic on 21.12.23..
//

import Foundation

enum EndpointRoute {

    case updateUserActivity

    var path: String {

        switch self {

        case .updateUserActivity:
            return "userActivity"

        }
    }
}
