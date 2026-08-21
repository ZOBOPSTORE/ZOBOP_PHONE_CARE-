import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            DashboardView()
                .tabItem { Label("Care", systemImage: "cross.case.fill") }
                .tag(0)
            CustomizeView()
                .tabItem { Label("Customize", systemImage: "paintbrush.pointed.fill") }
                .tag(1)
            SettingsGuideView()
                .tabItem { Label("Guide", systemImage: "gearshape.fill") }
                .tag(2)
        }
        .tint(.cyan)
    }
}

private struct DashboardView: View {
    @EnvironmentObject private var monitor: DeviceMonitor

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 18) {
                    HeaderView(lastUpdated: monitor.lastUpdated)
                    ReadinessCard(score: monitor.careScore, scanning: monitor.isScanning) {
                        monitor.refresh()
                    }
                    LazyVStack(spacing: 12) {
                        ForEach(monitor.results) { result in
                            NavigationLink(value: result) {
                                CareCard(result: result)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding()
            }
            .background(ZobopTheme.background.ignoresSafeArea())
            .navigationTitle("ZOBOP iPhone Care")
            .navigationDestination(for: CareResult.self) { result in
                CareDetailView(result: result)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button { monitor.refresh() } label: { Image(systemName: "arrow.clockwise") }
                        .accessibilityLabel("Refresh device check")
                }
            }
        }
    }
}

private struct HeaderView: View {
    let lastUpdated: Date?

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle().fill(LinearGradient(colors: [.cyan, .blue, .indigo], startPoint: .topLeading, endPoint: .bottomTrailing))
                Text("Z").font(.system(size: 34, weight: .black, design: .rounded)).foregroundStyle(.white)
            }
            .frame(width: 68, height: 68)
            VStack(alignment: .leading, spacing: 4) {
                Text("PREMIUM DEVICE CARE").font(.caption2.weight(.bold)).foregroundStyle(.cyan)
                Text("Ready when you are").font(.title3.bold())
                Text(lastUpdated.map { "Updated \($0.formatted(date: .omitted, time: .shortened))" } ?? "Preparing device check")
                    .font(.caption).foregroundStyle(.secondary)
            }
            Spacer()
        }
        .padding(16)
        .background(ZobopTheme.panel)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
    }
}

private struct ReadinessCard: View {
    let score: CareScore
    let scanning: Bool
    let refresh: () -> Void

    private var accent: Color {
        score.status == .good ? .cyan : .yellow
    }

    private var scoreLabel: String {
        switch score.value {
        case 90...: return "Looking good"
        case 70..<90: return "Needs attention"
        default: return "Check recommended"
        }
    }

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text("CARE READINESS").font(.caption.weight(.bold)).foregroundStyle(accent)
                    Text("\(score.value)%").font(.system(size: 54, weight: .black, design: .rounded))
                    Text(scoreLabel).font(.caption.weight(.semibold)).foregroundStyle(accent)
                    Text(score.summary).font(.caption).foregroundStyle(.secondary).fixedSize(horizontal: false, vertical: true)
                }
                Spacer()
                ZStack {
                    Circle().stroke(.white.opacity(0.12), lineWidth: 12)
                    Circle().trim(from: 0, to: Double(score.value) / 100).stroke(accent, style: StrokeStyle(lineWidth: 12, lineCap: .round)).rotationEffect(.degrees(-90))
                    Image(systemName: score.status == .good ? "checkmark.shield.fill" : "exclamationmark.shield.fill")
                        .font(.title)
                        .foregroundStyle(.white)
                }
                .frame(width: 110, height: 110)
                .accessibilityElement(children: .ignore)
                .accessibilityLabel("Care readiness \(score.value) percent, \(scoreLabel)")
            }
            Button(action: refresh) {
                Label(scanning ? "Scanning…" : "Run safe check", systemImage: scanning ? "hourglass" : "checkmark.shield.fill")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(.cyan)
            .disabled(scanning)
        }
        .padding(20)
        .background(LinearGradient(colors: [.blue.opacity(0.36), .black.opacity(0.9)], startPoint: .topLeading, endPoint: .bottomTrailing))
        .overlay(RoundedRectangle(cornerRadius: 28).stroke(.white.opacity(0.14)))
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
    }
}

private struct CareCard: View {
    let result: CareResult

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: result.area.symbol)
                .font(.title3.bold())
                .foregroundStyle(.cyan)
                .frame(width: 44, height: 44)
                .background(.white.opacity(0.07))
                .clipShape(RoundedRectangle(cornerRadius: 14))
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(result.title).font(.headline)
                    Spacer()
                    Text(result.status.rawValue)
                        .font(.caption.weight(.bold))
                        .foregroundStyle(result.status == .attention ? .yellow : result.status == .unavailable ? .secondary : .cyan)
                }
                Text(result.detail).font(.caption).foregroundStyle(.secondary).fixedSize(horizontal: false, vertical: true)
            }
            Image(systemName: "chevron.right")
                .font(.caption.weight(.bold))
                .foregroundStyle(.tertiary)
        }
        .padding(14)
        .background(ZobopTheme.panel)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}

enum ZobopTheme {
    static let background = Color(red: 0.015, green: 0.02, blue: 0.035)
    static let panel = Color.white.opacity(0.065)
}
