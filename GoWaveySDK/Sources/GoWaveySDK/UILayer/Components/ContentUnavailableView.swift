//
//  ContentUnavailableView.swift
//
//
//  Created by Nikola Matijevic on 20.1.24..
//

import Foundation
import SwiftUI

struct ContentUnavailableView: View {

    var body: some View {
        VStack(spacing: 20) {

            Image(systemName: "exclamationmark.triangle")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .foregroundColor(.gray)

            Text("Content Unavailable")
                .font(.title)
                .fontWeight(.bold)

            Text("The content you are looking for is currently unavailable. Please try again later.")
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
        .edgesIgnoringSafeArea(.all)
    }
}
