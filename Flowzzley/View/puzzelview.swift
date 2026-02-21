import SwiftUI

struct PuzzleView: View {
    @StateObject private var viewModel = PuzzleViewModel()
    @State private var selectedFlower: FlowerType = .lily

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        ZStack {
            Color(.colorCard)
                .ignoresSafeArea()

            VStack {
                Spacer()

                VStack(spacing: 16) {

                    // Title
                    Text("Solve the puzzle")
                        .font(.system(size: 16, weight: .regular, design: .serif))
                        .foregroundColor(.black.opacity(0.7))

                    // Flower selector
                    Picker("Flower", selection: $selectedFlower) {
                        Text("Lily").tag(FlowerType.lily as FlowerType)
                        Text("Rose").tag(FlowerType.rose as FlowerType)
                        Text("Tulip").tag(FlowerType.tulip as FlowerType)
                        Text("Sunflower").tag(FlowerType.sunflower as FlowerType)
                        Text("Lavender").tag(FlowerType.lavender as FlowerType)
                        Text("Orchid").tag(FlowerType.orchid as FlowerType)
                    }
                    .pickerStyle(.segmented)
                    .onChange(of: selectedFlower) { _, newValue in
                        viewModel.loadPuzzle(flower: newValue)
                    }

                    // Puzzle grid
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
                                            viewModel.selectedPiece == piece ? .pink : .clear,
                                            lineWidth: 3
                                        )
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .onTapGesture {
                                    viewModel.tapPiece(piece)
                                }
                        }
                    }
                    .frame(width: 240, height: 240)

                    Text("Tap two pieces to swap them")
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)

                    // Actions
                    HStack(spacing: 12) {
                        Button("Shuffle") {
                            viewModel.loadPuzzle(flower: selectedFlower)
                        }
                        .buttonStyle(.bordered)

                        Button("Reset") {
                            viewModel.selectedPiece = nil
                        }
                        .buttonStyle(.bordered)
                    }
                }
                .padding(.vertical, 24)
                .padding(.horizontal, 20)
                .background(
                    RoundedRectangle(cornerRadius: 28)
                        .fill(Color(.secondarySystemBackground))
                        .shadow(color: .black.opacity(0.08),
                                radius: 20, x: 0, y: 10)
                )

                Spacer()
            }
            .padding()
        }
        .onAppear {
            viewModel.loadPuzzle(flower: selectedFlower)
        }
    }
}

#Preview {
    PuzzleView()
}
