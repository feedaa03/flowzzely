import SwiftUI
import AVFoundation

struct PuzzleView: View {

    @StateObject private var viewModel: PuzzleViewModel
    @State private var goToResult = false
    @Environment(\.colorScheme) var colorScheme

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    init(flower: FlowerType) {
        _viewModel = StateObject(wrappedValue: PuzzleViewModel(flower: flower))
    }

    var body: some View {
        ZStack {
            (colorScheme == .dark ? Color(hex: "#D29C9A") : Color(hex: "#EDE0D9"))
                .ignoresSafeArea()

            VStack {
                Spacer()

                VStack(spacing: 16) {

                    Text("Solve the puzzle")
                        .font(.system(size: 16, design: .serif))
                        .foregroundStyle(colorScheme == .dark ? Color.white : Color("color"))

                    LazyVGrid(columns: columns, spacing: 8) {
                        ForEach(viewModel.pieces) { piece in
                            Image(piece.imageName)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 110, height: 110)
                                .clipped()
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(
                                            viewModel.selectedPiece == piece
                                            ? Color.pink
                                            : Color.clear,
                                            lineWidth: 3
                                        )
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .onTapGesture {
                                    let before = viewModel.selectedPiece
                                    viewModel.tapPiece(piece)
                                    if before != nil {
                                        SoundManager.shared.playSwap()
                                    }
                                }
                        }
                    }
                    .frame(width: 240, height: 240)

                    Text("Tap two pieces to swap them")
                        .font(.system(size: 12))
                        .foregroundStyle(colorScheme == .dark ? .white.opacity(0.7) : .secondary)
                }
                .padding(24)

                Spacer()
            }
            .padding()
        }
        .navigationDestination(isPresented: $goToResult) {
            FlowerResultView(flower: viewModel.flower)
        }
        .onChange(of: viewModel.isSolved) { oldValue, newValue in
            if newValue {
                DailyProgressManager.shared.markSolved(flower: viewModel.flower)
                goToResult = true
            }
        }
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r = Double((int >> 16) & 0xFF) / 255
        let g = Double((int >> 8) & 0xFF) / 255
        let b = Double(int & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}

#Preview {
    NavigationStack {
        PuzzleView(flower: .lily)
    }
}
