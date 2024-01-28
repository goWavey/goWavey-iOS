//
//  File.swift
//  
//
//  Created by Nikola Matijevic on 24.12.23..
//

import Foundation
import Combine

protocol BadgeDetailsUseCase {

    func getBadgeDetails(id: String) async -> AnyPublisher<Badge, Error>
}
