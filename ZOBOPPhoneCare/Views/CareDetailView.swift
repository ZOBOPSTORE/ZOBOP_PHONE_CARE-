import SwiftUI

struct CareDetailView: View {
    let result: CareResult

    private var freeRecommendations: [CareRecommendation] {
        Array(result.area.recommendations.prefix(2))
    }

    private var premiumRecommendations: [CareRecommendation] {
        Array(result.area.recommendations.dropFirst(2))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                ZStack {
                    Circle()
                        .fill(LinearGradient(colors: [.cyan, .blue, .indigo], startPoint: .topLeading, endPoint: .bottomTrailing))
                    Image(systemName: result.area.symbol)
                        .font(.system(size: 38, weight: .bold))
                        .foregroundStyle(.white)
                }
                .frame(width: 92, height: 92)

                Text(result.title)
                    .font(.largeTitle.bold())

                Text(result.detail)
                    .foregroundStyle(.secondary)

                Divider().overlay(.white.opacity(0.15))

                Text("SAFE RECOMMENDATIONS")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.cyan)

                RecommendationList(items: freeRecommendations)

                if !premiumRecommendations.isEmpty {
                    PremiumAccessGate(
                        title: "Unlock the complete care plan",
                        subtitle: "Premium adds the remaining recommendations and deeper guidance for this area."
                    ) {
                        VStack(alignment: .leading, spacing: 12) {
                            Label("PREMIUM RECOMMENDATIONS", systemImage: "crown.fill")
                                .font(.caption.weight(.bold))
                                .foregroundStyle(.cyan)
                            RecommendationList(items: premiumRecommendations)
                        }
                    }
                }

                Text("ZOBOP opens only supported public iOS destinations. It does not bypass permissions or control protected system settings.")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
            }
            .padding()
        }
        .background(ZobopTheme.background.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct RecommendationList: View {
    let items: [CareRecommendation]

    var body: some View {
        VStack(spacing: 12) {
            ForEach(items) { item in
                HStack(alignment: .top, spacing: 14) {
                    Image(systemName: item.symbol)
                        .foregroundStyle(.cyan)
                        .frame(width: 24)
                    VStack(alignment: .leading, spacing: 4) {
                        Text(item.title).font(.headline)
                        Text(item.detail).font(.caption).foregroundStyle(.secondary)
                    }
                    Spacer(minLength: 0)
                }
                .padding(14)
                .background(ZobopTheme.panel)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            }
        }
    }
}
