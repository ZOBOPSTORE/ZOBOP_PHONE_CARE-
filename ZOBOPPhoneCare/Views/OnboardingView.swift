import SwiftUI

struct OnboardingView: View {
    @AppStorage("zobop.onboarding.completed") private var completed = false
    @State private var page = 0

    private let pages: [(String, String, String)] = [
        ("ZOBOP iPhone Care", "Premium care, honest guidance.", "Z"),
        ("Understand your iPhone", "Review battery, storage, performance, security and iCloud using information the app can safely access.", "waveform.path.ecg"),
        ("Stay in control", "ZOBOP never claims to clean other apps, change protected settings, or control your iPhone outside Apple's permissions.", "hand.raised.fill"),
        ("Make it yours", "Get guided help for Add Widget, Customize, Edit Wallpaper and Edit Pages where iOS permits.", "square.grid.2x2.fill")
    ]

    var body: some View {
        ZStack {
            LinearGradient(colors: [.black, Color.blue.opacity(0.32), .black], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()

            VStack(spacing: 24) {
                Spacer()
                Image(systemName: pages[page].2 == "Z" ? "bolt.circle.fill" : pages[page].2)
                    .font(.system(size: 72, weight: .bold))
                    .foregroundStyle(.cyan, .white)
                    .shadow(radius: 18)

                Text(pages[page].0)
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .multilineTextAlignment(.center)

                Text(pages[page].1)
                    .font(.title3)
                    .foregroundStyle(.white.opacity(0.72))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 28)

                HStack(spacing: 8) {
                    ForEach(pages.indices, id: \.self) { index in
                        Capsule().fill(index == page ? Color.cyan : Color.white.opacity(0.22))
                            .frame(width: index == page ? 28 : 8, height: 8)
                    }
                }
                .animation(.easeInOut, value: page)

                Spacer()

                Button {
                    if page == pages.count - 1 { completed = true } else { page += 1 }
                } label: {
                    Text(page == pages.count - 1 ? "Start ZOBOP Care" : "Continue")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.cyan.opacity(0.92), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
                        .foregroundStyle(.black)
                }
                .padding(.horizontal, 24)

                if page < pages.count - 1 {
                    Button("Skip") { completed = true }
                        .foregroundStyle(.white.opacity(0.65))
                }
            }
            .padding(.vertical, 36)
        }
    }
}
