//
//  SwiftUIView.swift
//  
//
//  Created by Nikola Matijevic on 26.12.23..
//

import SwiftUI

struct BadgeView: View {

    let badge: Badge

    
    var body: some View {
        ZStack {
            Color.black.opacity(0.6).edgesIgnoringSafeArea(.all)

            VStack {

                Spacer()

                Text("Received a new \(badge.name) Badge!")
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

                Text(badge.description)
                    .font(.subheadline)
                    .foregroundColor(.gray)

                Spacer()

                Button(action: {}) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                }
            }
        }
    }
}

struct BadgeView_Previews: PreviewProvider {
    static var previews: some View {
        BadgeView(badge: TrophyCase.mock.trophies[0])
    }
}
