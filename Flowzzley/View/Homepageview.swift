import SwiftUI

struct HomepageView: View {

    @State private var selectedFlower: FlowerType?
    @State private var showPuzzle = false
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
            ZStack {
                (colorScheme == .dark ? Color(hex: "#D29C9A") : Color(hex: "#EDE0D9"))
                    .ignoresSafeArea()

                VStack(spacing: 24) {
                    Text("Guess the flower from the picture")
                        .font(.system(size: 16, design: .serif))
                        .foregroundStyle(colorScheme == .dark ? .white : .color)

                    LazyVGrid(columns: [GridItem(), GridItem()], spacing: 16) {
                        ForEach(FlowerType.allCases, id: \.self) { flower in
                            let unlocked = DailyProgressManager.shared.isUnlocked(flower)
                            Button {
                                if unlocked {
                                    selectedFlower = flower
                                    showPuzzle = true
                                }
                            } label: {
                                ZStack {
                                    FlowerCard(imageName: "\(flower.rawValue) blur")
                                    if !unlocked {
                                        Circle()
                                            .fill(Color.black.opacity(0.35))
                                            .overlay(
                                                Image(systemName: "lock.fill")
                                                    .font(.title)
                                                    .foregroundColor(.white)
                                            )
                                    }
                                }
                            }
                            .disabled(!unlocked)
                        }
                    }
                }
                .padding()
            }
            .navigationDestination(isPresented: $showPuzzle) {
                if let selectedFlower {
                    PuzzleView(flower: selectedFlower)
                      
                }
            }
        }
    }

#Preview {
    HomepageView()
}
