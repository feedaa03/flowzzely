//
//  PuzzleView.swift
//  Flowzzely
//
//  Created by Feda on 23/02/2026.
//

import SwiftUI
import AVFoundation

// MARK: - PuzzleView
struct PuzzleView: View {

    // MARK: - State
    @StateObject private var viewModel: PuzzleViewModel
    @State private var goToResult = false
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss

    // MARK: - Constants
    private enum Layout {
        static let pieceSize: CGFloat = 110
        static let gridSize: CGFloat = 240
        static let gridSpacing: CGFloat = 8
        static let cornerRadius: CGFloat = 12
        static let selectionBorderWidth: CGFloat = 3
        static let contentPadding: CGFloat = 24
    }

    private let gridColumns = [GridItem(.flexible()), GridItem(.flexible())]
    private let brandColor = Color(red: 0.35, green: 0.25, blue: 0.22)

    // MARK: - Initialization
    init(flower: FlowerType) {
        _viewModel = StateObject(wrappedValue: PuzzleViewModel(flower: flower))
    }

    // MARK: - Body
    var body: some View {
        ZStack {
            backgroundColor.ignoresSafeArea()

            VStack {
                Spacer()
                puzzleContent
                Spacer()
            }
            .padding()
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: { dismiss() }) {
                    Label("Back", systemImage: "chevron.left")
                }
                .accessibilityLabel("Go back")
                .accessibilityHint("Returns to the flower selection")
            }
        }
        .navigationDestination(isPresented: $goToResult) {
            FlowerResultView(flower: viewModel.flower)
        }
        .onReceive(viewModel.$isSolved, perform: handleSolvedChange)
    }

    // MARK: - Subviews
    private var puzzleContent: some View {
        VStack(spacing: 16) {
            instructionLabel
            puzzleGrid
            hintLabel
        }
        .padding(Layout.contentPadding)
    }

    private var instructionLabel: some View {
        Text("Solve the puzzle")
            .font(.system(size: 16, design: .serif))
            .foregroundStyle(colorScheme == .dark ? Color.white : brandColor)
            .dynamicTypeSize(...DynamicTypeSize.accessibility3)
            .accessibilityAddTraits(.isHeader)
    }

    private var puzzleGrid: some View {
        LazyVGrid(columns: gridColumns, spacing: Layout.gridSpacing) {
            ForEach(viewModel.pieces) { piece in
                puzzlePiece(piece)
            }
        }
        .frame(width: Layout.gridSize, height: Layout.gridSize)
        .accessibilityLabel("Flower puzzle grid")
    }

    private func puzzlePiece(_ piece: FlowerPuzzlePiece) -> some View {
        let isSelected = viewModel.selectedPiece == piece
        let index = (viewModel.pieces.firstIndex(of: piece) ?? 0) + 1

        return Image(piece.imageName)
            .resizable()
            .scaledToFill()
            .frame(width: Layout.pieceSize, height: Layout.pieceSize)
            .clipped()
            .overlay(selectionBorder(isSelected: isSelected))
            .clipShape(RoundedRectangle(cornerRadius: Layout.cornerRadius))
            .onTapGesture { handlePieceTap(piece) }
            .accessibilityLabel(isSelected ? "Piece \(index), selected" : "Piece \(index)")
            .accessibilityHint(viewModel.selectedPiece == nil
                ? "Double tap to select this piece"
                : "Double tap to swap with the selected piece")
            .accessibilityAddTraits(.isButton)
    }

    private func selectionBorder(isSelected: Bool) -> some View {
        RoundedRectangle(cornerRadius: Layout.cornerRadius)
            .stroke(
                isSelected ? Color.pink : Color.clear,
                lineWidth: Layout.selectionBorderWidth
            )
    }

    private var hintLabel: some View {
        Text("Tap two pieces to swap them")
            .font(.system(size: 12))
            .foregroundStyle(colorScheme == .dark ? .white.opacity(0.7) : .secondary)
            .dynamicTypeSize(...DynamicTypeSize.accessibility3)
    }

    // MARK: - Helpers
    private var backgroundColor: Color {
        colorScheme == .dark ? Color(hex: "#D29C9A") : Color(hex: "#EDE0D9")
    }

    private func handlePieceTap(_ piece: FlowerPuzzlePiece) {
        let hadSelection = viewModel.selectedPiece != nil
        viewModel.tapPiece(piece)
        if hadSelection {
            SoundManager.shared.playSwap()
        }
    }

    private func handleSolvedChange(_ isSolved: Bool) {
        guard isSolved else { return }
        DailyProgressManager.shared.markSolved(flower: viewModel.flower)
        goToResult = true
    }
}

// MARK: - Color + Hex
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r = Double((int >> 16) & 0xFF) / 255
        let g = Double((int >> 8) & 0xFF) / 255
        let b = Double(int & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        PuzzleView(flower: .lily)
    }
}
