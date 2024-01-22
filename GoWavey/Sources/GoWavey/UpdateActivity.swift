//
//  UpdateActivity.swift
//
//
//  Created by Nikola Matijevic on 22.1.24..
//

import Foundation
import Combine

public final class UpdateActivity {

    @Injected var updateActivityUseCase: UpdateActivityUseCase

    public func updateActivity(_ activity: Activity)  async -> AnyPublisher<UpdateActivityResponse, Error>  {

        await updateActivityUseCase.updateActivity(activity)
    }
}
