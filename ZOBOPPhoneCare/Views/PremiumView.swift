import SwiftUI
import StoreKit

struct PremiumView: View {
    @EnvironmentObject private var store: SubscriptionStore

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 18) {
                    VStack(spacing: 10) {
                        Image(systemName: "crown.fill")
                            .font(.system(size: 42, weight: .bold))
                            .foregroundStyle(.cyan)
                        Text("ZOBOP Care Premium")
                            .font(.title.bold())
                        Text("Unlock deeper insights, premium widgets, history and advanced care guidance.")
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.top, 24)

                    VStack(alignment: .leading, spacing: 12) {
                        PremiumFeature(icon: "chart.line.uptrend.xyaxis", text: "Extended Care Score insights and history")
                        PremiumFeature(icon: "sparkles", text: "Advanced recommendations and priority guidance")
                        PremiumFeature(icon: "rectangle.grid.2x2.fill", text: "Premium widget experiences")
                        PremiumFeature(icon: "paintbrush.fill", text: "Enhanced customization guidance")
                    }
                    .padding()
                    .background(ZobopTheme.panel)
                    .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))

                    if store.isPremium {
                        Label("Premium is active", systemImage: "checkmark.seal.fill")
                            .font(.headline)
                            .foregroundStyle(.cyan)
                    } else if store.isLoading && store.products.isEmpty {
                        ProgressView("Loading plans…")
                            .tint(.cyan)
                    } else if store.products.isEmpty {
                        Text("Plans will appear after the App Store products are configured.")
                            .font(.footnote)
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(store.products, id: \.id) { product in
                            Button {
                                Task { await store.purchase(product) }
                            } label: {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(product.displayName).font(.headline)
                                        Text(product.description).font(.caption).foregroundStyle(.secondary)
                                    }
                                    Spacer()
                                    Text(product.displayPrice).font(.headline)
                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.cyan)
                        }
                    }

                    Button("Restore Purchases") {
                        Task { await store.restore() }
                    }
                    .buttonStyle(.bordered)

                    Text("Payment is charged by Apple. Plans renew automatically until cancelled in your Apple Account settings. Availability and pricing are finalized in App Store Connect.")
                        .font(.caption2)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.secondary)
                        .padding(.top, 4)
                }
                .padding()
            }
            .background(ZobopTheme.background.ignoresSafeArea())
            .navigationTitle("Premium")
            .task { await store.load() }
            .alert("ZOBOP Care Premium", isPresented: Binding(get: { store.errorMessage != nil }, set: { if !$0 { store.errorMessage = nil } })) {
                Button("OK", role: .cancel) { store.errorMessage = nil }
            } message: {
                Text(store.errorMessage ?? "")
            }
        }
    }
}

private struct PremiumFeature: View {
    let icon: String
    let text: String
    var body: some View {
        Label(text, systemImage: icon)
            .foregroundStyle(.primary)
            .font(.subheadline.weight(.medium))
    }
}
