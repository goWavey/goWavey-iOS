//
//  Badge.swift
//
//
//  Created by Nikola Matijevic on 21.12.23..
//

import Foundation

public struct Badge: Identifiable, Hashable {

    public let id: String
    let name: String
    let description: String
    let iconUrl: String
    let isAchieved: Bool
}
