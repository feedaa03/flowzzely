import Foundation

enum FlowerType: String, CaseIterable, Identifiable {
    case lily
    case rose
    case tulip
    case sunflower
    case lavender
    case orchid

    var id: String { rawValue }

    var pieces: [FlowerPuzzlePiece] {
        [
            FlowerPuzzlePiece(imageName: "\(rawValue)1", correctIndex: 0),
            FlowerPuzzlePiece(imageName: "\(rawValue)2", correctIndex: 1),
            FlowerPuzzlePiece(imageName: "\(rawValue)3", correctIndex: 2),
            FlowerPuzzlePiece(imageName: "\(rawValue)4", correctIndex: 3)
        ]
    }
}