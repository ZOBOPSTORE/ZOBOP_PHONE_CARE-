import SwiftUI

struct CareDetailView: View {
    let result: CareResult

    private var actionTitle: String {
        switch result.area {
        case .battery: return "Open app settings"
        case .storage: return "Open app settings"
        case .performance: return "Open app settings"
        case .security: return "Open app settings"
        case .system: return "Open app settings"
        case .icloud: return "Open app settings"
        }
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

                VStack(spacing: 12) {
                    ForEach(result.area.recommendations) { item in
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

                Button(action: CareAction.openAppSettings) {
                    Label(actionTitle, systemImage: "gearshape.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(.cyan)

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
