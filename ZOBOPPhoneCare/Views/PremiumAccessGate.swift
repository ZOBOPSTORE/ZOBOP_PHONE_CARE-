import SwiftUI

struct PremiumAccessGate<Content: View>: View {
    @EnvironmentObject private var store: SubscriptionStore
    let title: String
    let subtitle: String
    @ViewBuilder let content: () -> Content

    var body: some View {
        if store.isPremium {
            content()
        } else {
            VStack(spacing: 14) {
                Image(systemName: "lock.fill")
                    .font(.title2.weight(.bold))
                    .foregroundStyle(.cyan)

                Text(title)
                    .font(.headline)
                    .multilineTextAlignment(.center)

                Text(subtitle)
                    .font(.caption)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)

                NavigationLink {
                    PremiumView()
                } label: {
                    Label("Unlock Premium", systemImage: "crown.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(.cyan)
            }
            .padding()
            .background(ZobopTheme.panel)
            .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        }
    }
}
