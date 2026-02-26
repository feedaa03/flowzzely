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

    var body: some View {
        ZStack {
            (colorScheme == .dark ? Color(hex: "D29C9A") : Color(hex: "#EDE0D9"))
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 0) {
                    VStack(spacing: 20) {

                        Text(flower.displayTitle)
                            .font(.system(size: 22, weight: .regular, design: .serif))
                            .foregroundStyle(Color.color)
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
                            .foregroundStyle(Color.color)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 24)
                            .accessibilityLabel(flower.description)

                        VStack(alignment: .leading, spacing: 10) {
                            Text("Occasions")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundStyle(Color.color)
                                .accessibilityAddTraits(.isHeader)

                            FlexibleChipsView(items: flower.occasions) { occasion in
                                Text(occasion)
                                    .font(.system(size: 14, weight: .regular))
                                    .foregroundStyle(Color.primary)
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 8)
                                    .background(
                                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                                            .fill(colorScheme == .dark ? Color.color : Color.secondary.opacity(0.15))
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                    )
                                    .accessibilityLabel(occasion)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 24)
                        .padding(.bottom, 16)
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
                        .foregroundStyle(Color.color)
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

    // MARK: - Confetti
    struct ConfettiView: View {
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
            .onAppear {
                generateParticles()
            }
        }

        func generateParticles() {
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
            withAnimation(.easeIn(duration: 2.5)) {
                for i in particles.indices {
                    particles[i].y += size.height + 200
                    particles[i].x += CGFloat.random(in: -60...60)
                    particles[i].opacity = 0
                }
            }
        }
    }

    struct ConfettiParticle: Identifiable {
        let id: Int
        var x: CGFloat
        var y: CGFloat
        var size: CGFloat
        var color: Color
        var opacity: Double
    }

    // MARK: - FlexibleChipsView
    @MainActor
    struct FlexibleChipsView<Data: RandomAccessCollection, Content: View>: View where Data.Element: Hashable {
        let items: Data
        let content: (Data.Element) -> Content
        @State private var totalHeight: CGFloat = .zero

        init(items: Data, @ViewBuilder content: @escaping (Data.Element) -> Content) {
            self.items = items
            self.content = content
        }

        var body: some View {
            GeometryReader { geo in
                let width = geo.size.width
                self.generateContent(availableWidth: width)
            }
            .frame(height: totalHeight)
        }

        private func generateContent(availableWidth: CGFloat) -> some View {
            var width = CGFloat.zero
            var height = CGFloat.zero
            let itemsArray = Array(items)

            return ZStack(alignment: .topLeading) {
                ForEach(itemsArray, id: \.self) { item in
                    content(item)
                        .padding(.trailing, 8)
                        .padding(.bottom, 8)
                        .alignmentGuide(.leading) { d in
                            if (abs(width - d.width) > availableWidth) {
                                width = 0
                                height -= d.height
                            }
                            let result = width
                            if item == itemsArray.last { width = 0 } else { width -= d.width }
                            return result
                        }
                        .alignmentGuide(.top) { d in
                            let result = height
                            if item == itemsArray.last { height = 0 }
                            return result
                        }
                }
            }
            .background(
                GeometryReader { innerGeo in
                    Color.clear
                        .preference(key: ChipsSizePreferenceKey.self, value: innerGeo.size.height)
                }
            )
            .onPreferenceChange(ChipsSizePreferenceKey.self) { newHeight in
                if totalHeight != newHeight { totalHeight = newHeight }
            }
        }
    }

    private struct ChipsSizePreferenceKey: PreferenceKey {
        static let defaultValue: CGFloat = 0
        static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
            value = max(value, nextValue())
        }
    }
}

#Preview {
    NavigationStack {
        FlowerResultView(flower: .lavender)
    }
}
