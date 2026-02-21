import Foundation
internal import Combine

final class PuzzleViewModel: ObservableObject {

    @Published var pieces: [FlowerPuzzlePiece] = []
    @Published var selectedPiece: FlowerPuzzlePiece?

    func loadPuzzle(flower: FlowerType) {
        selectedPiece = nil
        pieces = flower.pieces.shuffled()
    }

    func tapPiece(_ piece: FlowerPuzzlePiece) {
        guard let selected = selectedPiece else {
            selectedPiece = piece
            return
        }

        if let firstIndex = pieces.firstIndex(of: selected),
           let secondIndex = pieces.firstIndex(of: piece) {
            pieces.swapAt(firstIndex, secondIndex)
        }

        selectedPiece = nil
    }
}
