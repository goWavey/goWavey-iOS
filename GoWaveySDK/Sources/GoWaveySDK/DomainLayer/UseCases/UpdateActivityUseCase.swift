//
//  UpdateActivityUseCase.swift
//
//
//  Created by Nikola Matijevic on 23.12.23..
//

import Foundation
import Combine

protocol UpdateActivityUseCase {

   func updateActivity(_ activity: Activity) async -> AnyPublisher<UpdateActivityResponse, Error>
}

public struct UpdateActivityResponse {
    public var message: String
    public var badges: [Badge]?
}
