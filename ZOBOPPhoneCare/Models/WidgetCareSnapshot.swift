import Foundation

/// Lightweight snapshot shared between the main app and the WidgetKit extension.
/// Values intentionally contain only telemetry already available to ZOBOP Phone Care.
struct WidgetCareSnapshot: Codable, Equatable {
    let readiness: Int
    let label: String
    let batteryLevel: Int?
    let storageFreeBytes: Int64?
    let updatedAt: Date

    static let placeholder = WidgetCareSnapshot(
        readiness: 0,
        label: "Run a safe check",
        batteryLevel: nil,
        storageFreeBytes: nil,
        updatedAt: .distantPast
    )
}
