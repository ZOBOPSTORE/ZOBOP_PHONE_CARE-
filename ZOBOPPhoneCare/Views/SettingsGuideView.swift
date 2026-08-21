import SwiftUI

struct SettingsGuideView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("What ZOBOP can safely do") {
                    GuideRow(title: "Battery monitoring", detail: "Read current charge when iOS provides it. Battery maximum capacity and cycle count require Apple-approved APIs or user-provided diagnostics.")
                    GuideRow(title: "Storage insight", detail: "Read app-accessible volume capacity and explain user-controlled cleanup. The app cannot erase other apps' private files.")
                    GuideRow(title: "Performance guidance", detail: "Explain Low Power Mode and safe settings. A third-party app cannot overclock, force-close other apps, or boost iOS globally.")
                    GuideRow(title: "Security review", detail: "Provide checklists and privacy guidance without claiming access to passcodes, Face ID data, or protected device security state.")
                    GuideRow(title: "System optimizer", detail: "Offer recommendations only. Apple retains control over system processes and maintenance.")
                    GuideRow(title: "iCloud manager", detail: "Detect app-level iCloud identity availability and manage only data inside ZOBOP's approved containers.")
                }
                Section("Primary test reference") {
                    Text("iPhone 16 Pro Max is the primary layout and performance reference. The app should support other compatible iPhones with responsive SwiftUI layouts.")
                        .font(.subheadline)
                }
                Section("App Store truthfulness") {
                    Text("Every optimization claim must match an action the app can actually perform. System changes that require Apple Settings remain user-controlled and are labeled clearly.")
                        .font(.subheadline)
                }
            }
            .scrollContentBackground(.hidden)
            .background(ZobopTheme.background)
            .navigationTitle("Care Guide")
        }
    }
}

private struct GuideRow: View {
    let title: String
    let detail: String
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title).font(.headline)
            Text(detail).font(.caption).foregroundStyle(.secondary)
        }.padding(.vertical, 4)
    }
}
