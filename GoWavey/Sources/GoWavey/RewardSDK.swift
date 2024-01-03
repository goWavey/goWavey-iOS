import Foundation
import Combine

final class RewardSDK {

    private let compositionRoot: SDKCompositionRoot

    /// The API key is a unique identifier that authenticates requests associated with your project
    init(authToken: String) {
        self.compositionRoot = SDKCompositionRoot(authToken: authToken)
    }

    public func updateActivity(_ activity: Activity) async -> AnyPublisher<String, Error> {

        await compositionRoot.updateActivityUseCase.updateActivity(activity)
    }
}
