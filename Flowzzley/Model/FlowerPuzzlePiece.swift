import Foundation

struct FlowerPuzzlePiece: Identifiable, Equatable {
    let id = UUID()
    let imageName: String
    let correctIndex: Int
}