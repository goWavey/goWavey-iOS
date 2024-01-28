//
//  GetTrophyCaseUseCase.swift
//
//
//  Created by Nikola Matijevic on 20.1.24..
//

import Foundation
import Combine

protocol GetTrophyCaseUseCase {

    func getTrophyCase(id: String) async -> AnyPublisher<TrophyCase, Error>
}
