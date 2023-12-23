//
//  UpdateActivityUseCase.swift
//
//
//  Created by Nikola Matijevic on 23.12.23..
//

import Foundation
import Combine

protocol UpdateActivityUseCase {

   func updateActivity(_ activity: Activity) async -> AnyPublisher< String, Error>
}
