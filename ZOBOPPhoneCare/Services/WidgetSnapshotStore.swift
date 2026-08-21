import Foundation
#if canImport(WidgetKit)
import WidgetKit
#endif

/// Persists the latest safe care summary for the WidgetKit extension.
/// The app group identifier must be enabled for both targets in Xcode.
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
        #if canImport(WidgetKit)
        WidgetCenter.shared.reloadTimelines(ofKind: "ZOBOPCareWidget")
        #endif
    }

    func load() -> WidgetCareSnapshot {
        guard let data = defaults.data(forKey: snapshotKey),
              let snapshot = try? JSONDecoder().decode(WidgetCareSnapshot.self, from: data) else {
            return .placeholder
        }
        return snapshot
    }
}
