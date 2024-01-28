//
//  ActivityDTO.swift
//
//
//  Created by Nikola Matijevic on 23.12.23..
//

import Foundation

struct ActivityDTO: Codable {
    let id: String
    let value: Int

    init(_ activity: Activity) {

        self.id = activity.id
        self.value = activity.value
    }
}
