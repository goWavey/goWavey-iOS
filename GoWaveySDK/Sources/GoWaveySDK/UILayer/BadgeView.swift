//
//  SwiftUIView.swift
//
//
//  Created by Nikola Matijevic on 26.12.23..
//

import SwiftUI

public struct BadgeView: View {

    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    public let badges: [Badge]
    @State var shouldShowBadge = true
    let isNewBadge: Bool

    public init(
        badges: [Badge],
        isNewBadge: Bool = true
    ) {
        self.badges = badges
        self.isNewBadge = isNewBadge
    }

    public var body: some View {
        ZStack {
            
            Color.black.opacity(0.6).edgesIgnoringSafeArea(.all)
            
            VStack {
                if badges.count == 1 {
                    viewForBadge(badges.first!)
                } else {
                    
                    TabView {
                        ForEach(badges) { badge in
                            viewForBadge(badge)
                        }
                    }
                    .tabViewStyle(.page)
                }
                
                Spacer()

                Button(action: {
                    withAnimation {
                        presentationMode.wrappedValue.dismiss()
                    }
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                }
            }

            if shouldShowBadge && isNewBadge, let lottie = LottieAnimatingView.Lottie(rawValue: badges[0].animationName ?? "") {
                LottieAnimatingView(animation: lottie, isPresented: $shouldShowBadge)
            }

        }
    }


    @ViewBuilder
    func viewForBadge(_ badge: Badge) -> some View {

        VStack {

            Spacer()

            Text(isNewBadge ? "Received a new \(badge.name) Badge!" : "\(badge.name) Badge!")
                .font(.headline)
                .foregroundColor(.white)

            AsyncImage(url: URL(string: badge.iconUrl)) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
            } placeholder: {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
            }
            .padding()
            .opacity(badge.isAchieved ? 1 : 0.2)

            Text(badge.description)
                .font(.subheadline)
                .foregroundColor(.gray)
                .opacity(badge.isAchieved ? 1 : 0.2)

            Spacer()
        }
    }
}

struct BadgeView_Previews: PreviewProvider {
    static var previews: some View {
        BadgeView(badges: TrophyCase.mock.trophies)
    }
}
