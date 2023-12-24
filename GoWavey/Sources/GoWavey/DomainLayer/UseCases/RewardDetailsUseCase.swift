//
//  RewardDetailsUseCase.swift
//
//
//  Created by Nikola Matijevic on 24.12.23..
//

import Foundation
import Combine

protocol RewardDetailsUseCase {

    func getRewardDetails(id: String) async -> AnyPublisher<Reward, Error>
}
