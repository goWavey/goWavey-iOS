//
//  SwiftUIView.swift
//  
//
//  Created by Nikola Matijevic on 3.1.24..
//

import SwiftUI

import SwiftUI

struct TrophyCaseView: View {
    // Define the columns for the grid
    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    // Your data source, which you would populate with actual data
    let badges = [
        "Duolingo Wildfire",
        "Duolingo Sage",
        "Duolingo Scholar",
        "Duolingo Regal",
        "Duolingo Champion",
        "Chess.com Level 1",
        "7 Workouts",
        "Move Goal 300%",
        "Cycling Workout",
        "Rowing Workout",
        "Running Workout",
        "Longest Move Streak"
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("Trophy Case")
                    .font(.title)
                    .padding()

                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(badges, id: \.self) { badge in
                        TrophyCaseBadgeView(badgeName: badge)
                    }
                }
                .padding()
            }
        }
    }
}

// View for each badge
struct TrophyCaseBadgeView: View {
    var badgeName: String

    var body: some View {
        VStack {
            // Replace with actual image and text from your data
            Image(systemName: "star.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .padding()
            Text(badgeName)
                .font(.caption)
                .multilineTextAlignment(.center)
                .lineLimit(1)
                .padding(.horizontal)

            Spacer()
        }
        .fixedSize(horizontal: false, vertical: true) // This ensures the height is the same for all, while allowing the width to be flexible
        .frame(width: UIScreen.main.bounds.width/4, height: 120)
        .cornerRadius(10)
    }
}


#Preview {
    TrophyCaseView()
}
