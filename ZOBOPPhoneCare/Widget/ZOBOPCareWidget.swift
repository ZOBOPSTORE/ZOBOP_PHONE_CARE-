import WidgetKit
import SwiftUI

struct ZOBOPCareWidgetEntry: TimelineEntry {
    let date: Date
    let readiness: Int
    let label: String
    let batteryLevel: Int?
    let storageFreeBytes: Int64?
}

struct ZOBOPCareWidgetProvider: TimelineProvider {
    func placeholder(in context: Context) -> ZOBOPCareWidgetEntry {
        entry(from: .placeholder)
    }

    func getSnapshot(in context: Context, completion: @escaping (ZOBOPCareWidgetEntry) -> Void) {
        completion(entry(from: WidgetSnapshotStore.shared.load()))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<ZOBOPCareWidgetEntry>) -> Void) {
        let snapshot = WidgetSnapshotStore.shared.load()
        let current = entry(from: snapshot)
        let nextRefresh = max(snapshot.updatedAt.addingTimeInterval(30 * 60), .now.addingTimeInterval(30 * 60))
        completion(Timeline(entries: [current], policy: .after(nextRefresh)))
    }

    private func entry(from snapshot: WidgetCareSnapshot) -> ZOBOPCareWidgetEntry {
        ZOBOPCareWidgetEntry(
            date: snapshot.updatedAt == .distantPast ? .now : snapshot.updatedAt,
            readiness: snapshot.readiness,
            label: snapshot.label,
            batteryLevel: snapshot.batteryLevel,
            storageFreeBytes: snapshot.storageFreeBytes
        )
    }
}

struct ZOBOPCareWidgetView: View {
    let entry: ZOBOPCareWidgetEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Z").font(.headline.weight(.black))
                    .frame(width: 28, height: 28)
                    .background(.blue.gradient, in: Circle())
                Text("ZOBOP CARE").font(.caption2.weight(.bold))
                Spacer()
            }

            if entry.readiness == 0 {
                Text("Ready").font(.system(size: 34, weight: .black, design: .rounded))
            } else {
                Text("\(entry.readiness)%").font(.system(size: 34, weight: .black, design: .rounded))
            }

            Text(entry.label).font(.caption).foregroundStyle(.secondary)

            if entry.readiness > 0 {
                ProgressView(value: Double(entry.readiness), total: 100).tint(.cyan)
            }

            if let battery = entry.batteryLevel {
                Label("Battery \(battery)%", systemImage: "battery.100percent")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .widgetURL(URL(string: "zobopcare://dashboard"))
        .containerBackground(.black.gradient, for: .widget)
    }
}

struct ZOBOPCareWidget: Widget {
    let kind = "ZOBOPCareWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: ZOBOPCareWidgetProvider()) { entry in
            ZOBOPCareWidgetView(entry: entry)
        }
        .configurationDisplayName("ZOBOP Care")
        .description("A quick view of your latest ZOBOP care readiness.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

@main
struct ZOBOPCareWidgetBundle: WidgetBundle {
    var body: some Widget {
        ZOBOPCareWidget()
    }
}
