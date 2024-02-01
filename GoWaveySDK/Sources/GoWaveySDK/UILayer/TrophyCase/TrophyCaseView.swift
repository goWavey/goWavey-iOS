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
    let onBadgeTap: ((Badge) -> Void)?

    var backgroundColor: Color {

        switch viewModel.trophyCase?.backgroundColor.lowercased() {

        case "black":
            return .black
        case "gray":
            return .gray
        case "white":
            return .white
        default:
            return .black
        }
    }

    var titleColor: Color {
        switch backgroundColor {

        case .black:
            return .white
        default:
            return .black
        }
    }

    public init(

        id: String,
        onBadgeTap: ((Badge) -> Void)? = nil
    ) {

        self.id = id
        self.onBadgeTap = onBadgeTap
    }

    // Define the columns for the grid
    var columns: [GridItem] {
        var temp = [GridItem]()

        for _ in 0..<(viewModel.trophyCase?.countInRow ?? 4) {
            temp.append(GridItem(.flexible()))
        }

        return temp
    }

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
                    ZStack {
                        backgroundColor
                            .edgesIgnoringSafeArea(.all)
                        presentationView
                    }
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
                    .foregroundStyle(titleColor)

                LazyVGrid(columns: columns, spacing: 5) {
                    ForEach(viewModel.trophyCase?.trophies ?? [], id: \.self) { trophy in
                        TrophyCaseBadgeView(trophy: trophy, titleColor: titleColor)
                            .onTapGesture {
                                if let onBadgeTap {
                                    onBadgeTap(trophy)
                                }
                            }
                    }
                }
                .padding()
            }
        }
        .background(backgroundColor)
    }
}

// View for each badge
struct TrophyCaseBadgeView: View {
    let trophy: Badge
    let titleColor: Color

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
                .foregroundStyle(titleColor)

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
