//
//  ContentView.swift
//  Flowzzley
//
//  Created by Feda  on 12/02/2026.
//

import SwiftUI

struct StartView: View {
    var body: some View {
        ZStack {
            // Background
            Image("fb") // أو Color(.systemBackground)
                .ignoresSafeArea()

            VStack {
                Spacer(minLength: 80)

                // Title
                Text("Flowzzley")
                    .foregroundStyle(.color)

                    .font(.system(size: 42, weight: .regular, design: .serif))
                    .kerning(1)

                Spacer(minLength: 40)

                // Flower
                Image("Flower")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 180)

                Spacer()

                // Button
                Button(action: {}) {
                    Text("Get started")
                        .foregroundStyle(Color.black)

                        .font(.system(size: 16))
                        .padding(.horizontal, 40)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 30)
                                .fill(Color.pink.opacity(0.2))
                        )
                        .shadow(color: .black.opacity(0.3),
                                radius: 8, x: 0, y: 4)
                }

                Spacer(minLength: 40)
            }
        }
    }
}

#Preview {
    StartView()
}

