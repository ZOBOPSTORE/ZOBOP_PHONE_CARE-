import Foundation

enum CareActionPlan {
    static func actions(for snapshot: HealthSnapshot, score: CareScore) -> [CareAction] {
        var actions: [CareAction] = []

        if let battery = snapshot.batteryLevel, battery <= 15 {
            actions.append(CareAction(title: "Charge your iPhone", detail: "Current charge is \(battery)%. Connect to power and let iOS manage charging safely.", symbol: "battery.25percent", priority: .urgent))
        }

        if let free = snapshot.freeStorageBytes, let total = snapshot.totalStorageBytes, total > 0 {
            let freeRatio = Double(free) / Double(total)
            if freeRatio < 0.10 {
                actions.append(CareAction(title: "Free up storage", detail: "Only \(ByteCountFormatter.string(fromByteCount: free, countStyle: .file)) is available. Review large photos, downloads, and unused apps in Settings.", symbol: "internaldrive", priority: .urgent))
            } else if freeRatio < 0.20 {
                actions.append(CareAction(title: "Review storage", detail: "\(ByteCountFormatter.string(fromByteCount: free, countStyle: .file)) is available. Consider removing unused downloads or offloading apps.", symbol: "externaldrive.badge.exclamationmark", priority: .recommended))
            }
        }

        if snapshot.lowPowerMode {
            actions.append(CareAction(title: "Low Power Mode is on", detail: "This is not an error. Some background activity and performance are intentionally reduced by iOS to extend battery life.", symbol: "leaf.fill", priority: .info))
        }

        if !snapshot.icloudAvailable {
            actions.append(CareAction(title: "Check iCloud availability", detail: "ZOBOP cannot access an app-level iCloud identity right now. Review your Apple Account and the app's iCloud permissions.", symbol: "icloud.slash", priority: .recommended))
        }

        if actions.isEmpty {
            actions.append(CareAction(title: score.summary, detail: "No urgent issue was detected from the information iOS makes available to ZOBOP. Run another scan after major usage or charging changes.", symbol: "checkmark.seal.fill", priority: .info))
        }

        return actions
    }
}

struct CareAction: Identifiable, Hashable {
    enum Priority: Int, Hashable {
        case urgent
        case recommended
        case info

        var label: String {
            switch self {
            case .urgent: return "URGENT"
            case .recommended: return "RECOMMENDED"
            case .info: return "INFO"
            }
        }
    }

    let id = UUID()
    let title: String
    let detail: String
    let symbol: String
    let priority: Priority
}
