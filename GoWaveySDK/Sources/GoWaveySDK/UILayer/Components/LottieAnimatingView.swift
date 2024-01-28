//
//  LottieAnimatingView.swift
//
//
//  Created by Nikola Matijevic on 25.1.24..
//


import Foundation
import UIKit
import SwiftUI
import Lottie

struct LottieAnimatingView: UIViewRepresentable {
    enum Lottie: String {
        case animation1
        case animation2
        case animation3
        case animation4
        case animation5
        case animation6
    }

    let animation: Lottie
    let loopMode: LottieLoopMode = .playOnce

    init(animation: LottieAnimatingView.Lottie) {
        self.animation = animation
    }

    func makeUIView(context: UIViewRepresentableContext<LottieAnimatingView>) -> UIView {
        let view = UIView(frame: .zero)

        let animationView = LottieAnimationView()
        let animation = LottieAnimation.named(animation.rawValue, bundle: Bundle.module)
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = loopMode
        animationView.play()

        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        NSLayoutConstraint.activate([
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])

        return view
    }

    func updateUIView(_ uiView: UIViewType, context: Context) { }
}
