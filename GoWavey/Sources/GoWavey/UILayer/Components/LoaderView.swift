//
//  LoaderView.swift
//
//
//  Created by Nikola Matijevic on 20.1.24..
//

import Foundation
import SwiftUI

struct LoaderView: View {

    var body: some View {
        ZStack {
            Color(.systemBackground)
                .edgesIgnoringSafeArea(.all)

            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .scaleEffect(CGSize(width: 1.5, height: 1.5))
        }
    }
}

#Preview {

    LoaderView()
}
