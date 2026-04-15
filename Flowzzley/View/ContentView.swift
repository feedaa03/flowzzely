//
//  ContentView.swift
//  Flowzzely
//
//  Created by Feda on 23/02/2026.
//

import SwiftUI

struct ContentView: View {

    // MARK: - State
    @State private var goToHome = false
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    // MARK: - Body
    var body: some View {
        NavigationStack {
            ZStack {
                backgroundColor.ignoresSafeArea()

                VStack {
                    Spacer(minLength: 80)
                    appTitleText
                    Spacer(minLength: 40)
                    flowerImage
                    Spacer()
                    getStartedButton
                    Spacer(minLength: 40)
                }
            }
            .navigationDestination(isPresented: $goToHome) {
                HomepageView()
            }
        }
    }

    // MARK: - Subviews
    private var appTitleText: some View {
        Text("Flowzzley")
            .foregroundStyle(Color(red: 0.35, green: 0.25, blue: 0.22))
            .font(.system(.largeTitle, design: .serif))
            .dynamicTypeSize(...DynamicTypeSize.accessibility5)
            .minimumScaleFactor(0.7)
            .lineLimit(2)
            .multilineTextAlignment(.center)
            .kerning(1)
            .accessibilityAddTraits(.isHeader)
    }

    private var flowerImage: some View {
        Image("Flower")
            .resizable()
            .scaledToFit()
            .frame(width: dynamicTypeSize.isAccessibilitySize ? 140 : 180)
            .accessibilityHidden(true)
    }

    private var getStartedButton: some View {
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
                .background(buttonBackground)
                .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
        }
        .accessibilityLabel("Get started")
        .accessibilityHint("Opens the flower puzzle game")
    }

    private var buttonBackground: some View {
        RoundedRectangle(cornerRadius: 30)
            .fill(colorScheme == .dark ? Color.white.opacity(0.2) : Color.pink.opacity(0.2))
    }

    // MARK: - Helpers
    private var backgroundColor: Color {
        colorScheme == .dark ? Color(hex: "#D29C9A") : Color(hex: "#EDE0D9")
    }
}

#Preview {
    ContentView()
}
