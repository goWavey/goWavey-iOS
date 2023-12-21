//
//  File.swift
//  
//
//  Created by Nikola Matijevic on 21.12.23..
//

import Foundation

enum EndpointRoute {

    case currentUserInfo
    case feedbackChoices
    case finishABreak
    case giveFeedback
    case login
    case logout
    case refresh
    case requestABreak
    case runningLate
    case status
    case submitComment
    case submitShiftComment
    case getIncidentCategories
    case createIncidentReport
    case getAllIncidents

    var path: String {

        switch self {

        case .login:
            return "auth/login"
        case .logout:
            return "logout"
        case .currentUserInfo:
            return "me"
        case .refresh:
            return "refresh"
        case .feedbackChoices:
            return "feedback-choices"
        case .giveFeedback:
            return "feedback"
        case .runningLate:
            return "running-late"
        case .requestABreak:
            return "request-break"
        case .finishABreak:
            return "finish-break"
        case .status:
            return "status"
        case .submitComment:
            return "form_data"
        case .submitShiftComment:
            return ""
        case .getIncidentCategories:
            return "incident-categories"
        case .createIncidentReport:
            return "add-incident"
        case .getAllIncidents:
            return "incidents"
        }
    }
}
