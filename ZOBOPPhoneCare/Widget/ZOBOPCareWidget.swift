import WidgetKit
import SwiftUI

struct ZOBOPCareWidgetEntry: TimelineEntry {
    let date: Date
    let readiness: Int
    let label: String
}

struct ZOBOPCareWidgetProvider: TimelineProvider {
    func placeholder(in context: Context) -> ZOBOPCareWidgetEntry {
        ZOBOPCareWidgetEntry(date: .now, readiness: 92, label: "Looking good")
    }

    func getSnapshot(in context: Context, completion: @escaping (ZOBOPCareWidgetEntry) -> Void) {
        completion(placeholder(in: context))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<ZOBOPCareWidgetEntry>) -> Void) {
        let entry = ZOBOPCareWidgetEntry(date: .now, readiness: 92, label: "Open ZOBOP Care")
        completion(Timeline(entries: [entry], policy: .after(.now.addingTimeInterval(60 * 30))))
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
            Text("\(entry.readiness)%").font(.system(size: 34, weight: .black, design: .rounded))
            Text(entry.label).font(.caption).foregroundStyle(.secondary)
            ProgressView(value: Double(entry.readiness), total: 100).tint(.cyan)
        }
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
