import SwiftUI

struct StartView: View {

    @State private var goToHome = false
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        NavigationStack {
            ZStack {
                (colorScheme == .dark ? Color(hex: "#D29C9A") : Color(hex: "#EDE0D9"))
                    .ignoresSafeArea()

                VStack {
                    Spacer(minLength: 80)

                    Text("Flowzzley")
                        .foregroundStyle(.color)
                        .font(.system(size: 42, weight: .regular, design: .serif))
                        .kerning(1)

                    Spacer(minLength: 40)

                    Image("Flower")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 180)

                    Spacer()

                    Button {
                        goToHome = true
                    } label: {
                        Text("Get started")
                            .foregroundStyle(colorScheme == .dark ? Color.white : Color.black)
                            .font(.system(size: 16))
                            .padding(.horizontal, 40)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(colorScheme == .dark ? Color.white.opacity(0.2) : Color.pink.opacity(0.2))
                            )
                            .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
                    }

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
