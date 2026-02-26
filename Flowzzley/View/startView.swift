//
//  StartView.swift
//  Flowzzely
//
//  Created by Feda on 23/02/2026.
//

import SwiftUI

struct StartView: View {

    @State private var goToHome = false
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    var body: some View {
        NavigationStack {
            ZStack {
                (colorScheme == .dark ? Color(hex: "#D29C9A") : Color(hex: "#EDE0D9"))
                    .ignoresSafeArea()

                VStack {
                    Spacer(minLength: 80)

                    Text("Flowzzley")
                        .foregroundStyle(.color)
                        .font(.system(.largeTitle, design: .serif))
                        .dynamicTypeSize(...DynamicTypeSize.accessibility5)
                        .minimumScaleFactor(0.7)
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                        .kerning(1)
                        .accessibilityAddTraits(.isHeader)

                    Spacer(minLength: 40)

                    Image("Flower")
                        .resizable()
                        .scaledToFit()
                        .frame(width: dynamicTypeSize.isAccessibilitySize ? 140 : 180)
                        .accessibilityLabel("Decorative flower illustration")
                        .accessibilityHidden(true)

                    Spacer()

                    Button {
                        goToHome = true
                    } label: {
                        Text("Get started")
                            .foregroundStyle(colorScheme == .dark ? Color.white : Color.black)
                            .font(.body)
                            .dynamicTypeSize(...DynamicTypeSize.accessibility5)
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)
                            .padding(.horizontal, dynamicTypeSize.isAccessibilitySize ? 28 : 40)
                            .padding(.vertical, dynamicTypeSize.isAccessibilitySize ? 16 : 12)
                            .background(
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(colorScheme == .dark ? Color.white.opacity(0.2) : Color.pink.opacity(0.2))
                            )
                            .contentShape(RoundedRectangle(cornerRadius: 30))
                            .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
                    }
                    .accessibilityLabel("Get started")
                    .accessibilityHint("Opens the flower puzzle game")

                    Spacer(minLength: 40)
                }
            }
            .navigationDestination(isPresented: $goToHome) {
                HomepageView()
            }
        }
    }
}

#Preview {
    StartView()
}
