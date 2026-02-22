import SwiftUI

struct FlowerResultView: View {
    let flower: FlowerType
    @State private var showConfetti = false
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss

    // عشان نرجع للهوم مباشرة
    @EnvironmentObject var NavigationPath: NavigationPathManager

    var body: some View {
        ZStack {
            (colorScheme == .dark ? Color(hex: "EFD7D5") : Color(hex: "#EDE0D9"))
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 0) {
                    VStack(spacing: 20) {

                        Text(flower.displayTitle)
                            .font(.system(size: 22, weight: .regular, design: .serif))
                            .foregroundStyle(.color)
                            .multilineTextAlignment(.center)
                            .padding(.top, 24)
                            .padding(.horizontal, 20)

                        ZStack {
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .fill(Color.white)
                                .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 4)

                            Image(flower.imageName)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 200)
                                .padding(20)
                        }
                        .padding(.horizontal, 20)

                        Text(flower.description)
                            .font(.system(size: 15))
                            .foregroundStyle(.color)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 24)

                        VStack(alignment: .leading, spacing: 10) {
                            Text("Occasions")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundStyle(.color)

                            FlexibleChipsView(items: flower.occasions) { occasion in
                                Text(occasion)
                                    .font(.system(size: 14, weight: .regular))
                                    .foregroundStyle(.color)
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 8)
                                    .background(
                                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                                            .fill(colorScheme == .dark ? Color.white.opacity(0.25) : Color.color)
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                    )
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 24)
                        .padding(.bottom, 16)

                        // ✅ زر الهوم
                        Button {
                            navigationPath.path = []
                        } label: {
                            HStack(spacing: 8) {
                                Image(systemName: "house.fill")
                                Text("Back to Home")
                            }
                            .font(.system(size: 16, weight: .medium, design: .serif))
                            .foregroundColor(.color)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(
                                RoundedRectangle(cornerRadius: 20, style: .continuous)
                                    .fill(Color.white.opacity(0.6))
                            )
                        }
                        .padding(.horizontal, 24)
                        .padding(.bottom, 28)
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 28, style: .continuous)
                            .fill(colorScheme == .dark ? Color(hex: "#EFD7D5") : Color(hex: "#EDE0D9"))
                    )
                    .padding(20)
                }
            }

            if showConfetti {
                GeometryReader { geo in
                    ConfettiView(size: geo.size)
                }
                .ignoresSafeArea()
                .allowsHitTesting(false)
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            SoundManager.shared.playSuccess()
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
            self.generateContent(in: geo)
        }
        .frame(height: totalHeight)
    }

    private func generateContent(in geo: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero

        return ZStack(alignment: .topLeading) {
            ForEach(Array(items), id: \.self) { item in
                content(item)
                    .padding(.trailing, 8)
                    .padding(.bottom, 8)
                    .alignmentGuide(.leading) { d in
                        if (abs(width - d.width) > geo.size.width) {
                            width = 0
                            height -= d.height
                        }
                        let result = width
                        if item == items.last { width = 0 } else { width -= d.width }
                        return result
                    }
                    .alignmentGuide(.top) { d in
                        let result = height
                        if item == items.last { height = 0 }
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
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}

#Preview {
    FlowerResultView(flower: .lavender)
        .environmentObject(NavigationPathManager())
}
