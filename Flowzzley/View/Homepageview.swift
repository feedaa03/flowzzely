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
    @ObservedObject private var progress = DailyProgressManager.shared

    private let brandColor = Color(red: 0.35, green: 0.25, blue: 0.22)

    var body: some View {
        ZStack {
            (colorScheme == .dark ? Color(hex: "#D29C9A") : Color(hex: "#EDE0D9"))
                .ignoresSafeArea()

            VStack {
                Spacer()
                VStack(spacing: 24) {
                    let allUnlocked = FlowerType.allCases.allSatisfy { progress.isUnlocked($0) }

                    Text(allUnlocked ? "You unlocked all the flowers!" : "Guess the flower from the picture")
                        .font(.system(size: 16, design: .serif))
                        .foregroundStyle(colorScheme == .dark ? Color.white : brandColor)
                        .dynamicTypeSize(...DynamicTypeSize.accessibility3)
                        .accessibilityLabel(allUnlocked ? "You unlocked all the flowers!" : "Guess the flower from the picture")

                    LazyVGrid(columns: [GridItem(), GridItem()], spacing: 16) {
                        ForEach(FlowerType.allCases, id: \.self) { flower in
                            let unlocked = progress.isUnlocked(flower)
                            let reason = progress.lockReason(for: flower)

                            Button {
                                if unlocked {
                                    selectedFlower = flower
                                    showPuzzle = true
                                }
                            } label: {
                                ZStack(alignment: .bottom) {
                                    FlowerCard(imageName: unlocked ? flower.rawValue : "\(flower.rawValue) blur")

                                    if !unlocked {
                                        // ✅ شكل القفل مستطيل يطابق الكارد
                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(Color.black.opacity(0.35))
                                            .overlay(
                                                VStack(spacing: 6) {
                                                    Image(systemName: "lock.fill")
                                                        .font(.title2)
                                                        .foregroundColor(.white)
                                                    // ✅ يوضح سبب القفل
                                                    if reason == .waitingForMidnight {
                                                        Text("Unlocks at midnight")
                                                            .font(.system(size: 10, weight: .medium))
                                                            .foregroundColor(.white.opacity(0.9))
                                                            .multilineTextAlignment(.center)
                                                            .padding(.horizontal, 8)
                                                    }
                                                }
                                            )
                                    }
                                }
                            }
                            .disabled(!unlocked)
                            .accessibilityLabel(unlocked ? "\(flower.rawValue.capitalized) puzzle" : "\(flower.rawValue.capitalized), locked")
                            .accessibilityHint({
                                if unlocked { return "Double tap to start the puzzle" }
                                if reason == .waitingForMidnight { return "Unlocks tonight at midnight" }
                                return "Solve the previous flower to unlock"
                            }())
                            .accessibilityAddTraits(unlocked ? .isButton : [.isButton, .isStaticText])
                        }
                    }
                }
                .padding()
                Spacer()
            }
        }
        .navigationDestination(isPresented: $showPuzzle) {
            if let selectedFlower {
                PuzzleView(flower: selectedFlower, showPuzzle: $showPuzzle)
            }
        }
    }
}

#Preview {
    HomepageView()
}
