import Foundation
import Combine

public final class RewardSDK {

    private let compositionRoot: SDKCompositionRoot
    private let updateActivity = UpdateActivity()

    /// The API key is a unique identifier that authenticates requests associated with your project
    /// Member id is user's unique identifier
    public init(
        authToken: String,
        memberId: String
    ) {

        self.compositionRoot = SDKCompositionRoot(authToken: authToken, memberId: memberId)
        self.compositionRoot.createDependencies()
    }

    public func updateActivity(_ activity: Activity) async -> AnyPublisher<UpdateActivityResponse, Error> {

        await updateActivity.updateActivity(activity)
    }
}
