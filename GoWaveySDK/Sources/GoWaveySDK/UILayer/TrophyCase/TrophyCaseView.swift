//
//  TrophyCaseView.swift
//  
//
//  Created by Nikola Matijevic on 3.1.24..
//

import SwiftUI

public struct TrophyCaseView: View {

    /// Trophy case id
    private let id: String
    @StateObject var viewModel = ViewModel()

    public init(id: String) {

        self.id = id
    }

    // Define the columns for the grid
    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    public var body: some View {
        Group {
            
            if !viewModel.hasAttemptedFetch || viewModel.isLoading {

                LoaderView()
                    .onAppear {
                        if !viewModel.hasAttemptedFetch {
                            Task {
                                await viewModel.getTrophyCase(id: id)
                            }
                        }
                    }
            } else {

                if viewModel.hasFailed {
                    ContentUnavailableView()
                        .toast($viewModel.toast)
                } else {
                    presentationView
                }
            }
        }
    }

    var presentationView: some View {

        ScrollView {
            VStack(alignment: .leading) {
                Text("Trophy Case")
                    .font(.title)
                    .padding()

                LazyVGrid(columns: columns, spacing: 5) {
                    ForEach(viewModel.trophyCase?.trophies ?? [], id: \.self) { trophy in
                        TrophyCaseBadgeView(trophy: trophy)
                    }
                }
                .padding()
            }
        }
    }
}

// View for each badge
struct TrophyCaseBadgeView: View {
    let trophy: Badge

    var body: some View {
        VStack {
            // Replace with actual image and text from your data
            ZStack {
                AsyncImage(url: URL(string: trophy.iconUrl)) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                } placeholder: {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                }
                .padding()
                .opacity(trophy.isAchieved ? 1 : 0.2)

            }

            Text(trophy.name)
                .font(.caption)
                .multilineTextAlignment(.center)
                .lineLimit(1)
                .padding(.horizontal)
                .opacity(trophy.isAchieved ? 1 : 0.2)

            Spacer()
        }
        .fixedSize(horizontal: false, vertical: true) // This ensures the height is the same for all, while allowing the width to be flexible
        .frame(width: UIScreen.main.bounds.width/3, height: 120)
        .cornerRadius(10)
    }
}


#Preview {
    TrophyCaseView(id: "")
}