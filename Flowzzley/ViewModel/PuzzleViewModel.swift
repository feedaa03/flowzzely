import Foundation
import SwiftUI
internal import Combine

@MainActor
class PuzzleViewModel: ObservableObject {

    @Published var pieces: [FlowerPuzzlePiece] = []
    @Published var selectedPiece: FlowerPuzzlePiece?
    @Published var isSolved: Bool = false

    let flower: FlowerType

    init(flower: FlowerType) {
        self.flower = flower
        loadPuzzle()
    }

    func loadPuzzle() {
        selectedPiece = nil
        isSolved = false
        pieces = flower.pieces.shuffled()
    }

    func tapPiece(_ piece: FlowerPuzzlePiece) {
        guard !isSolved else { return }

        if let selected = selectedPiece {
            swap(selected, piece)
            selectedPiece = nil
            checkIfSolved()
        } else {
            selectedPiece = piece
        }
    }

    private func swap(_ first: FlowerPuzzlePiece, _ second: FlowerPuzzlePiece) {
        guard
            let firstIndex = pieces.firstIndex(of: first),
            let secondIndex = pieces.firstIndex(of: second)
        else {
            print("❌ swap فشل - ما لقى القطع")
            return
        }
        print("✅ swap نجح: \(firstIndex) <-> \(secondIndex)")
        pieces.swapAt(firstIndex, secondIndex)
    }

    func checkIfSolved() {
        print("--- checkIfSolved ---")
        for index in pieces.indices {
            print("Position \(index): \(pieces[index].imageName) | correctIndex: \(pieces[index].correctIndex)")
            if pieces[index].correctIndex != index {
                print("❌ غلط في position \(index)")
                return
            }
        }
        print("✅ SOLVED!")
        isSolved = true
    }
}
