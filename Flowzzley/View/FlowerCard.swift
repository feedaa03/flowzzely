//
//  FlowerCard.swift
//  Flowzzely
//
//  Created by Feda on 23/02/2026.
//

import SwiftUI

struct FlowerCard: View {
    
    // MARK: - Properties
    let imageName: String
    
    // MARK: - Constants
    private enum Layout {
        static let size: CGFloat = 140
        static let cornerRadius: CGFloat = 16
        static let shadowRadius: CGFloat = 6
    }
    
    // MARK: - Body
    var body: some View {
        Image(imageName)
            .resizable()
            .scaledToFill()
            .frame(width: Layout.size, height: Layout.size)
            .clipShape(RoundedRectangle(cornerRadius: Layout.cornerRadius))
            .shadow(radius: Layout.shadowRadius)
    }
}
