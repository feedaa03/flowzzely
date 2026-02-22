import SwiftUI

struct PuzzleView: View {

    @StateObject private var viewModel: PuzzleViewModel
    @State private var goToResult = false

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    init(flower: FlowerType) {
        _viewModel = StateObject(wrappedValue: PuzzleViewModel(flower: flower))
    }

    var body: some View {
        ZStack {
            Color("colorCard")
                .ignoresSafeArea()

            VStack {
                Spacer()

                VStack(spacing: 16) {

                    Text("Solve the puzzle")
                        .font(.system(size: 16, design: .serif))
                        .foregroundColor(.color)

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
                                    viewModel.tapPiece(piece)
                                }
                        }
                    }
                    .frame(width: 240, height: 240)

                    Text("Tap two pieces to swap them")
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)
                }
                .padding(24)
                .background(
                    RoundedRectangle(cornerRadius: 28)
                        .fill(Color(.secondarySystemBackground))
                )

                Spacer()
            }
            .padding()
        }
        .navigationDestination(isPresented: $goToResult) {
            FlowerResultView(flower: viewModel.flower)
        }
        .onChange(of: viewModel.isSolved) { solved in
            if solved {
                DailyProgressManager.shared.markSolved(flower: viewModel.flower)
                goToResult = true
            }
        }
    }
}

#Preview {
    PuzzleView(flower: .lily)
}
