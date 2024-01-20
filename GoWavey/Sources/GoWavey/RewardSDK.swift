import Foundation
import Combine

final class RewardSDK {

    private let compositionRoot: SDKCompositionRoot

    /// The API key is a unique identifier that authenticates requests associated with your project
    init(authToken: String,
         memberId: String) {
        self.compositionRoot = SDKCompositionRoot(authToken: authToken, memberId: memberId)
    }

    public func updateActivity(_ activity: Activity) async -> AnyPublisher<String, Error> {

        await compositionRoot.updateActivityUseCase.updateActivity(activity)
    }
}
