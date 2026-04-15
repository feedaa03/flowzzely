//
//  PuzzleModel.swift
//  Flowzzely
//
//  Created by Feda on 23/02/2026.
//

import Foundation

// MARK: - FlowerPuzzlePiece
struct FlowerPuzzlePiece: Identifiable, Equatable {
    let id: String
    let imageName: String
    let correctIndex: Int
    
    static func == (lhs: FlowerPuzzlePiece, rhs: FlowerPuzzlePiece) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - FlowerType + Puzzle
extension FlowerType {
    
    var title: String {
        rawValue.capitalized
    }
    
    var pieces: [FlowerPuzzlePiece] {
        makePieces()
    }
    
    // MARK: - Piece Layout
    // Grid positions:
    // 0 = top-left  | 1 = top-right
    // 2 = bottom-left | 3 = bottom-right
    
    private typealias PieceLayout = (imageNumber: Int, correctIndex: Int)
    
    private var pieceLayout: [PieceLayout] {
        switch self {
        case .lily:      return [(3,0), (4,1), (1,2), (2,3)]
        case .orchid:    return [(1,0), (2,1), (4,2), (3,3)]
        case .rose:      return [(4,0), (3,1), (2,2), (1,3)]
        case .sunflower: return [(1,0), (4,1), (3,2), (2,3)]
        case .tulip:     return [(2,0), (1,1), (4,2), (3,3)]
        case .lavender:  return [(4,0), (1,1), (2,2), (3,3)]
        }
    }
    
    private func makePieces() -> [FlowerPuzzlePiece] {
        pieceLayout.map { layout in
            FlowerPuzzlePiece(
                id: "\(rawValue)\(layout.imageNumber)",
                imageName: "\(rawValue)\(layout.imageNumber)",
                correctIndex: layout.correctIndex
            )
        }
    }
}
