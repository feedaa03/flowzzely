import Foundation

struct FlowerPuzzlePiece: Identifiable, Equatable {
    let id = UUID()
    let imageName: String
    let correctIndex: Int
}

extension FlowerType {
    var title: String {
        rawValue.capitalized
    }

    var pieces: [FlowerPuzzlePiece] {
        makePieces(prefix: rawValue)
    }

    fileprivate func makePieces(prefix: String) -> [FlowerPuzzlePiece] {
        (1...4).map { index in
            FlowerPuzzlePiece(
                imageName: "\(prefix)\(index)",
                correctIndex: index - 1
            )
        }
    }
}
