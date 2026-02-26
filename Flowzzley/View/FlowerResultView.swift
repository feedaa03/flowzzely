//
//  FlowerResultView.swift
//  Flowzzely
//
//  Created by Feda on 23/02/2026.
//

import SwiftUI

struct FlowerResultView: View {
    let flower: FlowerType
    @State private var showConfetti = false
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    @Environment(\.accessibilityReduceMotion) var reduceMotion

    private let brandColor = Color(red: 0.35, green: 0.25, blue: 0.22)

    private var isLastFlower: Bool {
        FlowerType.allCases.last == flower
    }

    var body: some View {
        ZStack {
            (colorScheme == .dark ? Color(hex: "D29C9A") : Color(hex: "#EDE0D9"))
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 0) {
                    VStack(spacing: 20) {

                        Text(flower.displayTitle)
                            .font(.system(size: 22, weight: .regular, design: .serif))
                            .foregroundStyle(brandColor)
                            .multilineTextAlignment(.center)
                            .padding(.top, 24)
                            .padding(.horizontal, 20)
                            .accessibilityAddTraits(.isHeader)

                        ZStack {
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .fill(Color.white)
                                .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 4)

                            Image(flower.imageName)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 200)
                                .padding(20)
                                .accessibilityLabel("Image of a \(flower.title)")
                        }
                        .padding(.horizontal, 20)

                        Text(flower.description)
                            .font(.system(size: 15))
                            .foregroundStyle(brandColor)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 24)
                            .accessibilityLabel(flower.description)

                        VStack(alignment: .leading, spacing: 10) {
                            Text("Occasions")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundStyle(brandColor)
                                .accessibilityAddTraits(.isHeader)

                            OccasionsWrapView(
                                occasions: flower.occasions,
                                colorScheme: colorScheme,
                                brandColor: brandColor
                            )
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 24)
                        .padding(.bottom,30)

                        if !isLastFlower {
                            Text("🌸 Come back tomorrow to solve another puzzle")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(brandColor.opacity(0.7))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 24)
                                .padding(.bottom, 16)
                                .accessibilityLabel("Come back tomorrow to solve another puzzle")
                        }
                    }
                }

                if showConfetti && !reduceMotion {
                    GeometryReader { geo in
                        ConfettiView(size: geo.size)
                    }
                    .ignoresSafeArea()
                    .allowsHitTesting(false)
                    .accessibilityHidden(true)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: { dismiss() }) {
                    Label("Back", systemImage: "chevron.left")
                        .foregroundStyle(brandColor)
                }
                .accessibilityLabel("Go back")
                .accessibilityHint("Returns to the puzzle")
            }
        }
        .toolbarBackground(
            colorScheme == .dark ? Color(hex: "D29C9A") : Color(hex: "#EDE0D9"),
            for: .navigationBar
        )
        .toolbarBackground(.visible, for: .navigationBar)
        .onAppear {
            SoundManager.shared.playSuccess()
            if !reduceMotion {
                showConfetti = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    showConfetti = false
                }
            }
        }
    }
}

// MARK: - OccasionsWrapView
private struct OccasionsWrapView: View {
    let occasions: [String]
    let colorScheme: ColorScheme
    let brandColor: Color

    var body: some View {
        var rows: [[String]] = []
        var current: [String] = []
        for (i, item) in occasions.enumerated() {
            current.append(item)
            if current.count == 2 || i == occasions.count - 1 {
                rows.append(current)
                current = []
            }
        }

        return VStack(alignment: .leading, spacing: 8) {
            ForEach(rows.indices, id: \.self) { rowIndex in
                HStack(spacing: 8) {
                    ForEach(rows[rowIndex], id: \.self) { occasion in
                        Text(occasion)
                            .font(.system(size: 14, weight: .regular))
                            .foregroundStyle(Color.primary)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 20, style: .continuous)
                                    .fill(colorScheme == .dark ? brandColor : Color.secondary.opacity(0.15))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 20, style: .continuous)
                                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
                            )
                            .accessibilityLabel(occasion)
                    }
                }
            }
        }
    }
}

// MARK: - ConfettiParticle
private struct ConfettiParticle: Identifiable {
    let id: Int
    var x: CGFloat
    var y: CGFloat
    var size: CGFloat
    var color: Color
    var opacity: Double
}

// MARK: - ConfettiView
@MainActor
private struct ConfettiView: View {
    let size: CGSize
    @State private var particles: [ConfettiParticle] = []

    var body: some View {
        ZStack {
            ForEach(particles) { p in
                Circle()
                    .fill(p.color)
                    .frame(width: p.size, height: p.size)
                    .position(x: p.x, y: p.y)
                    .opacity(p.opacity)
            }
        }
        .onAppear { generateParticles() }
    }

    private func generateParticles() {
        let colors: [Color] = [.pink, .purple, .yellow, .green, .blue, .orange, .red]
        particles = (0..<80).map { i in
            ConfettiParticle(
                id: i,
                x: CGFloat.random(in: 0...size.width),
                y: CGFloat.random(in: -100...200),
                size: CGFloat.random(in: 6...14),
                color: colors.randomElement()!,
                opacity: 1.0
            )
        }
        let updated = particles.map { p -> ConfettiParticle in
            var copy = p
            copy.y += size.height + 200
            copy.x += CGFloat.random(in: -60...60)
            copy.opacity = 0
            return copy
        }
        withAnimation(.easeIn(duration: 2.5)) {
            particles = updated
        }
    }
}

#Preview {
    NavigationStack {
        FlowerResultView(flower: .lavender)
    }
}
