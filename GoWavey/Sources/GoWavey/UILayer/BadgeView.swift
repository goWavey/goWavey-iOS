//
//  SwiftUIView.swift
//  
//
//  Created by Nikola Matijevic on 26.12.23..
//

import SwiftUI

struct BadgeView: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.7).edgesIgnoringSafeArea(.all)

            VStack {

                Spacer()

                Text("Received a new Gym Badge!")
                    .font(.headline)
                    .foregroundColor(.white)

                AsyncImage(url: URL(string: "https://demo-sdk-26-12-2023.s3.amazonaws.com/Ellipse+51.png")) { image in
                    image.resizable()
                         .aspectRatio(contentMode: .fit)
                         .frame(width: 200, height: 200)
                } placeholder: {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                }
                .padding()



                Text("Level it up for more rewards!")
                    .font(.subheadline)
                    .foregroundColor(.gray)

                Spacer()

                Button(action: {}) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.largeTitle)
                        .foregroundColor(.blue.opacity(0.5))
                }
            }
        }
    }
}

struct BadgeView_Previews: PreviewProvider {
    static var previews: some View {
        BadgeView()
    }
}
