import SwiftUI

struct FlowerCard: View {
    let imageName: String

    var body: some View {
        Image(imageName)
            .resizable()
            .scaledToFill()
            .frame(width: 140, height: 140)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color("Color card"))
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
}

struct HomepageView: View {
    var body: some View {
        ZStack {
            // Background
            Image("fb")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            VStack {
                Spacer(minLength: 80)

                // Title
                Text("Guess the flower from the picture")
                    .font(.system(size: 16, weight: .regular, design: .serif))
                    .foregroundStyle(Color .color)
                    .padding(.top, 24)

                // Cards grid
                VStack(spacing: 16) {
                    HStack(spacing: 16) {
                        FlowerCard(imageName: "lily blur")
                        FlowerCard(imageName: "orchid blur")
                    }

                    HStack(spacing: 16) {
                        FlowerCard(imageName: "rose blur")
                        FlowerCard(imageName: "sunflower blur")
                    }

                    HStack(spacing: 16) {
                        FlowerCard(imageName: "tulip blur")
                        FlowerCard(imageName: "lavender blur")
                    }
                }
                .padding()

                Spacer()
            }
        }
    }
}

#Preview {
    HomepageView()
}
