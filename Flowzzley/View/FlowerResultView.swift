import SwiftUI

struct FlowerResultView: View {
    let flower: FlowerType

    var body: some View {
        VStack(spacing: 24) {

            Image(flower.imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 220)

            Text(flower.title)
                .font(.title2)
                .fontWeight(.semibold)

            Text(flower.description)
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Spacer()
        }
        .padding()
        .navigationTitle("Result")
        .navigationBarTitleDisplayMode(.inline)
    }
}