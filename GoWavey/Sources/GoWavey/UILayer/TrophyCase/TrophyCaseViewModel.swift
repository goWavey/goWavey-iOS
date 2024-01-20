//
//  TrophyCaseViewModel.swift
//
//
//  Created by Nikola Matijevic on 20.1.24..
//

import Foundation
import Combine

protocol TrophyCaseVMDependencies {
    var getTrophyCaseUseCase: GetTrophyCaseUseCase { get }
}

extension TrophyCaseView {

    final class ViewModel: ObservableObject {

        @Published var isLoading = false
        @Published var hasAttemptedFetch = false
        @Published var hasFailed = false
        @Published var trophyCase: TrophyCase?
        private var subscriber: AnyCancellable?

        let dependencies: TrophyCaseVMDependencies

        init(dependencies: TrophyCaseVMDependencies) {

            self.dependencies = dependencies
        }

        @MainActor
        func getTrophyCase(id: String) async {

            isLoading = true
            hasAttemptedFetch = true

            subscriber = await dependencies.getTrophyCaseUseCase.getTrophyCase(id: id)
                .sink { completion in

                    if case .failure(let error) = completion {

                        self.hasFailed = true
                    }
                } receiveValue: { [weak self] trophyCase in

                    self?.trophyCase = trophyCase
                    self?.isLoading = false
                }
        }
    }
}
