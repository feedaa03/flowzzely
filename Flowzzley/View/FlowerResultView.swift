import SwiftUI

struct FlowerResultView: View {
    let flower: FlowerType

    var body: some View {
        ZStack {
            // Soft blush background
            Color(.colorCard)
                .ignoresSafeArea()
            ScrollView {
                VStack(spacing: 0) {
                    // Main card — full blush-pink card matching Figma
                    VStack(spacing: 20) {

                        // Title
                        Text(flower.displayTitle)
                            .font(.system(size: 22, weight: .regular, design: .serif))
                            .foregroundStyle(.color)
                            .multilineTextAlignment(.center)
                            .padding(.top, 24)
                            .padding(.horizontal, 20)

                        // White image card
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

                        // Description
                        Text(flower.description)
                            .font(.system(size: 15))
                            .foregroundStyle(.color)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 24)

                        // Occasions section
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Occasions")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundStyle(Color.color)

                            FlexibleChipsView(items: flower.occasions) { occasion in
                                Text(occasion)
                                    .font(.system(size: 14, weight: .regular))
                                    .foregroundStyle(.primary)
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 8)
                                    .background(
                                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                                            .fill(Color.white)
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                                            .stroke(Color.black.opacity(0.08), lineWidth: 1)
                                    )
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 24)
                        .padding(.bottom, 28)
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 28, style: .continuous)
                            .fill(Color.ww)
                    )
                    .padding(20)
                }
            }
        }
    }
}

// A lightweight flexible chips layout that wraps items onto multiple lines.
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
                        if item == items.last {
                            width = 0
                        } else {
                            width -= d.width
                        }
                        return result
                    }
                    .alignmentGuide(.top) { d in
                        let result = height
                        if item == items.last {
                            height = 0
                        }
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
            if totalHeight != newHeight {
                totalHeight = newHeight
            }
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
        .onAppear {
            withAnimation(.easeInOut(duration: 0.4)) {}
        }
}
