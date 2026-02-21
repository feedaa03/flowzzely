import Foundation

struct FlowerPuzzlePiece: Identifiable, Equatable {
    let id = UUID()
    let imageName: String
    let correctIndex: Int
}
enum FlowerType: CaseIterable {
    case lily
    case rose
    case tulip
    case sunflower
    case lavender
    case orchid

    var title: String {
        switch self {
        case .lily: return "Lily"
        case .rose: return "Rose"
        case .tulip: return "Tulip"
        case .sunflower: return "Sunflower"
        case .lavender: return "Lavender"
        case .orchid: return "Orchid"
        }
    }

    var pieces: [FlowerPuzzlePiece] {
        switch self {

        case .lily:
            return makePieces(prefix: "lily")

        case .rose:
            return makePieces(prefix: "rose")

        case .tulip:
            return makePieces(prefix: "tulip")

        case .sunflower:
            return makePieces(prefix: "sunflower")

        case .lavender:
            return makePieces(prefix: "lavender")

        case .orchid:
            return makePieces(prefix: "orchid")
        }
    }

    private func makePieces(prefix: String) -> [FlowerPuzzlePiece] {
        (1...4).map {
            FlowerPuzzlePiece(
                imageName: "\(prefix)\($0)",
                correctIndex: $0 - 1
            )
        }
    }
}
