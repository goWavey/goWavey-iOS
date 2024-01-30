//
//  TrophyCaseViewModel.swift
//
//
//  Created by Nikola Matijevic on 20.1.24..
//

import Foundation
import Combine

extension TrophyCaseView {

    final class ViewModel: ObservableObject {

        @Published var isLoading = false
        @Published var hasAttemptedFetch = false
        @Published var hasFailed = false
        @Published var trophyCase: TrophyCase?
        @Published var toast: Toast.State = .hide

        @Injected var getTrophyCaseUseCase: GetTrophyCaseUseCase

        private var subscriber: AnyCancellable?

        @MainActor
        func getTrophyCase(id: String) async {

            isLoading = true
            hasAttemptedFetch = true

            subscriber = await getTrophyCaseUseCase.getTrophyCase(id: id)
                .sink { completion in

                    if case .failure(let error) = completion {

                        self.hasFailed = true
                        self.toast = .show(.error("Something went wrong."))
                    }
                } receiveValue: { [weak self] trophyCase in

                    self?.trophyCase = trophyCase
                    self?.isLoading = false
                }
        }
    }
}


extension TrophyCase {
    static var mock: TrophyCase {
        let badge1 = Badge(id: "/gif1.gif",
                           name: "My reward #2",
                           description: "",
                           iconUrl: "https://gowavey-media-bucket.s3.amazonaws.com/default/badges/img4.png",
                           isAchieved: false,
                           animationName: "animation1")
        let badge2 = Badge(id: "/gif2.gif",
                           name: "My reward #2",
                           description: "",
                           iconUrl: "https://gowavey-media-bucket.s3.amazonaws.com/default/badges/img4.png",
                           isAchieved: false,
                           animationName: "animation2")
        let badge3 = Badge(id: "/gif3.gif",
                           name: "My reward #2",
                           description: "",
                           iconUrl: "https://gowavey-media-bucket.s3.amazonaws.com/default/badges/img4.png",
                           isAchieved: false,
                           animationName: "animation3")

        let badge4 = Badge(id: "/gif4.gif",
                           name: "My reward #1",
                           description: "",
                           iconUrl: "https://gowavey-media-bucket.s3.amazonaws.com/default/badges/img1.png",
                           isAchieved: false,
                           animationName: "animation4")

        let badge5 = Badge(id: "/gif5.gif",
                           name: "hello",
                           description: "",
                           iconUrl: "https://gowavey-media-bucket.s3.amazonaws.com/default/badges/img2.png",
                           isAchieved: false,
                           animationName: "animation5")

        let badge6 = Badge(id: "/gif6.gif",
                           name: "My reward #2",
                           description: "",
                           iconUrl: "https://gowavey-media-bucket.s3.amazonaws.com/default/badges/img4.png",
                           isAchieved: false,
                           animationName: "animation6")

        return TrophyCase(trophies: [badge1, badge2, badge3, badge4, badge5, badge6])
    }
}
