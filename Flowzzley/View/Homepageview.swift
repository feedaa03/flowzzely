//
//  HomepageView.swift
//  Flowzzely
//
//  Created by Feda on 23/02/2026.
//

import SwiftUI

struct HomepageView: View {

    @State private var selectedFlower: FlowerType?
    @State private var showPuzzle = false
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        ZStack {
            (colorScheme == .dark ? Color(hex: "#D29C9A") : Color(hex: "#EDE0D9"))
                .ignoresSafeArea()

            VStack(spacing: 24) {
                let allUnlocked = FlowerType.allCases.allSatisfy { DailyProgressManager.shared.isUnlocked($0) }

                Text(allUnlocked ? "You unlocked all the flowers!" : "Guess the flower from the picture")
                    .font(.system(size: 16, design: .serif))
                    .foregroundStyle(colorScheme == .dark ? Color.white : Color(red: 0.35, green: 0.25, blue: 0.22))
                    .dynamicTypeSize(...DynamicTypeSize.accessibility3)
                    .accessibilityLabel(allUnlocked ? "You unlocked all the flowers!" : "Guess the flower from the picture")

                LazyVGrid(columns: [GridItem(), GridItem()], spacing: 16) {
                    ForEach(FlowerType.allCases, id: \.self) { flower in
                        let unlocked = DailyProgressManager.shared.isUnlocked(flower)
                        Button {
                            if unlocked {
                                selectedFlower = flower
                                showPuzzle = true
                            }
                        } label: {
                            ZStack {
                                FlowerCard(imageName: unlocked ? "\(flower.rawValue)" : "\(flower.rawValue) blur")
                                if !unlocked {
                                    Circle()
                                        .fill(Color.black.opacity(0.35))
                                        .overlay(
                                            Image(systemName: "lock.fill")
                                                .font(.title)
                                                .foregroundColor(.white)
                                        )
                                }
                            }
                        }
                        .disabled(!unlocked)
                        .accessibilityLabel(unlocked ? "\(flower.rawValue.capitalized) puzzle" : "\(flower.rawValue.capitalized), locked")
                        .accessibilityHint(unlocked ? "Double tap to start the puzzle" : "Complete the previous flower to unlock")
                        .accessibilityAddTraits(unlocked ? .isButton : [.isButton, .isStaticText])
                    }
                }
            }
            .padding()
        }
        .navigationDestination(isPresented: $showPuzzle) {
            if let selectedFlower {
                PuzzleView(flower: selectedFlower)
            }
        }
    }
}

#Preview {
    HomepageView()
}
