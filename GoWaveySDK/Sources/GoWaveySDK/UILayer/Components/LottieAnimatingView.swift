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
    @Binding var isPresented: Bool

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

    init(animation: LottieAnimatingView.Lottie,
         isPresented: Binding<Bool>) {
        self.animation = animation
        self._isPresented = isPresented
    }

    func makeUIView(context: UIViewRepresentableContext<LottieAnimatingView>) -> UIView {
        let view = UIView(frame: .zero)

        let animationView = LottieAnimationView()

        let animation = LottieAnimation.named(animation.rawValue, bundle:  BundleHelper.bundle)
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = loopMode
        animationView.play { completed in
            if completed {
                isPresented = false
            }
        }

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

class BundleHelper {
    static var bundle: Bundle {
//        #if SWIFT_PACKAGE
//        return Bundle.module
//        #else
        if let resourceBundleURL = Bundle(for: Self.self).url(forResource: "GoWaveySDKResources", withExtension: "bundle"),
           let resourceBundle = Bundle(url: resourceBundleURL) {
            return resourceBundle
        }
        return Bundle.main
//        #endif
    }
}
