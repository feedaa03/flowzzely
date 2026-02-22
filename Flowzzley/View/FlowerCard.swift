//
//  FlowerCard.swift
//  Flowzzley
//
//  Created by Feda  on 22/02/2026.
//


import SwiftUI

struct FlowerCard: View {
    let imageName: String

    var body: some View {
        Image(imageName)
            .resizable()
            .scaledToFill()
            .frame(width: 140, height: 140)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(radius: 6)
    }
}