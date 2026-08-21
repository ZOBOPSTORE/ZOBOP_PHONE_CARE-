import Foundation

enum CareArea: String, CaseIterable, Identifiable, Hashable {
    case battery = "Battery Health"
    case storage = "Storage Cleaner"
    case performance = "Performance Boost"
    case security = "Security Check"
    case system = "System Optimizer"
    case icloud = "iCloud Manager"

    var id: String { rawValue }

    var symbol: String {
        switch self {
        case .battery: return "battery.100percent"
        case .storage: return "externaldrive.fill"
        case .performance: return "speedometer"
        case .security: return "checkmark.shield.fill"
        case .system: return "slider.horizontal.3"
        case .icloud: return "icloud.fill"
        }
    }
}

struct HealthSnapshot: Equatable {
    let batteryLevel: Int?
    let batteryState: String
    let freeStorageBytes: Int64?
    let totalStorageBytes: Int64?
    let lowPowerMode: Bool
    let icloudAvailable: Bool

    static let empty = HealthSnapshot(
        batteryLevel: nil,
        batteryState: "Unavailable",
        freeStorageBytes: nil,
        totalStorageBytes: nil,
        lowPowerMode: false,
        icloudAvailable: false
    )
}

struct CareResult: Identifiable, Equatable, Hashable {
    let id = UUID()
    let area: CareArea
    let title: String
    let detail: String
    let status: Status

    enum Status: String, Hashable {
        case good = "Good"
        case attention = "Attention"
        case unavailable = "Unavailable"
    }
}
