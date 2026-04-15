//
//  PuzzleViewModel.swift
//  Flowzzely
//
//  Created by Feda on 23/02/2026.
//

import Foundation
import SwiftUI
import Combine

@MainActor
final class PuzzleViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published private(set) var pieces: [FlowerPuzzlePiece] = []
    @Published private(set) var selectedPiece: FlowerPuzzlePiece?
    @Published private(set) var isSolved: Bool = false
    
    // MARK: - Properties
    let flower: FlowerType
    
    // MARK: - Initialization
    init(flower: FlowerType) {
        self.flower = flower
        loadPuzzle()
    }
    
    // MARK: - Public Methods
    func loadPuzzle() {
        pieces = flower.pieces.shuffled()
        selectedPiece = nil
        isSolved = false
    }
    
    func tapPiece(_ piece: FlowerPuzzlePiece) {
        guard !isSolved else { return }
        
        if let selected = selectedPiece {
            swapPieces(selected, piece)
            selectedPiece = nil
            checkIfSolved()
        } else {
            selectedPiece = piece
        }
    }
    
    // MARK: - Private Methods
    private func swapPieces(_ first: FlowerPuzzlePiece, _ second: FlowerPuzzlePiece) {
        guard
            let firstIndex = pieces.firstIndex(of: first),
            let secondIndex = pieces.firstIndex(of: second)
        else { return }
        
        pieces.swapAt(firstIndex, secondIndex)
    }
    
    private func checkIfSolved() {
        isSolved = pieces.indices.allSatisfy { pieces[$0].correctIndex == $0 }
    }
}
