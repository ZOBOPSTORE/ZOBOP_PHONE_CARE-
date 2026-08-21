import Foundation
import WidgetKit

/// Shared model for the WidgetKit extension. Keep this file in both the app and
/// widget targets when creating the Xcode project wrapper.
struct WidgetCareSnapshot: Codable, Sendable {
    let readiness: Int
    let label: String
    let batteryLevel: Int?
    let storageFreeBytes: Int64?
    let updatedAt: Date

    static let placeholder = WidgetCareSnapshot(
        readiness: 0,
        label: "Open ZOBOP iPhone Care to refresh",
        batteryLevel: nil,
        storageFreeBytes: nil,
        updatedAt: .distantPast
    )
}

/// App Group persistence for the ZOBOP Care widget.
final class WidgetSnapshotStore {
    static let shared = WidgetSnapshotStore()

    static let appGroupIdentifier = "group.com.zobop.phonecare"
    private let snapshotKey = "zobop.widget.careSnapshot"

    private var defaults: UserDefaults {
        UserDefaults(suiteName: Self.appGroupIdentifier) ?? .standard
    }

    private init() {}

    func save(_ snapshot: WidgetCareSnapshot) {
        guard let data = try? JSONEncoder().encode(snapshot) else { return }
        defaults.set(data, forKey: snapshotKey)
        WidgetCenter.shared.reloadTimelines(ofKind: "ZOBOPCareWidget")
    }

    func load() -> WidgetCareSnapshot {
        guard let data = defaults.data(forKey: snapshotKey),
              let snapshot = try? JSONDecoder().decode(WidgetCareSnapshot.self, from: data) else {
            return .placeholder
        }
        return snapshot
    }
}
