//
//  TrophyCase.swift
//
//
//  Created by Nikola Matijevic on 21.12.23..
//

import Foundation

struct TrophyCase {
    let userId: String
    var trophies: [Badge]
    var totalPoints: Int
    var level: Int
    var nextLevelThreshold: Int
    var lastUpdated: Date
}
