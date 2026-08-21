import Foundation
import UIKit
import Combine

@MainActor
final class DeviceMonitor: ObservableObject {
    @Published private(set) var snapshot: HealthSnapshot = .empty
    @Published private(set) var lastUpdated: Date?
    @Published private(set) var isScanning = false

    init() {
        UIDevice.current.isBatteryMonitoringEnabled = true
        refresh()
    }

    func refresh() {
        isScanning = true
        UIDevice.current.isBatteryMonitoringEnabled = true

        let device = UIDevice.current
        let batteryLevel = device.batteryLevel >= 0 ? Int((device.batteryLevel * 100).rounded()) : nil
        let batteryState: String
        switch device.batteryState {
        case .charging: batteryState = "Charging"
        case .full: batteryState = "Fully charged"
        case .unplugged: batteryState = "On battery"
        default: batteryState = "Unavailable"
        }

        let values = try? URL(fileURLWithPath: NSHomeDirectory()).resourceValues(forKeys: [
            .volumeAvailableCapacityForImportantUsageKey,
            .volumeTotalCapacityKey
        ])
        let free = values?.volumeAvailableCapacityForImportantUsage
        let total = values?.volumeTotalCapacity
        let iCloudAvailable = FileManager.default.ubiquityIdentityToken != nil

        snapshot = HealthSnapshot(
            batteryLevel: batteryLevel,
            batteryState: batteryState,
            freeStorageBytes: free,
            totalStorageBytes: total,
            lowPowerMode: ProcessInfo.processInfo.isLowPowerModeEnabled,
            icloudAvailable: iCloudAvailable
        )
        lastUpdated = Date()
        isScanning = false
    }

    var results: [CareResult] {
        let batteryStatus: CareResult.Status = snapshot.batteryLevel == nil ? .unavailable : .good
        let batteryText = snapshot.batteryLevel.map { "Current charge: \($0)% • \(snapshot.batteryState)" } ?? "Battery telemetry is unavailable."

        let freeText: String
        let storageStatus: CareResult.Status
        if let free = snapshot.freeStorageBytes, let total = snapshot.totalStorageBytes, total > 0 {
            let usedRatio = 1 - Double(free) / Double(total)
            freeText = "\(ByteCountFormatter.string(fromByteCount: free, countStyle: .file)) available"
            storageStatus = usedRatio > 0.9 ? .attention : .good
        } else {
            freeText = "Storage telemetry is unavailable."
            storageStatus = .unavailable
        }

        return [
            CareResult(area: .battery, title: CareArea.battery.rawValue, detail: batteryText, status: batteryStatus),
            CareResult(area: .storage, title: CareArea.storage.rawValue, detail: freeText + ". iOS apps cannot delete other apps' files; this tool guides you to user-controlled cleanup.", status: storageStatus),
            CareResult(area: .performance, title: CareArea.performance.rawValue, detail: snapshot.lowPowerMode ? "Low Power Mode is enabled. Some performance is intentionally reduced." : "No system-wide boost is available to third-party apps. Guidance only.", status: .good),
            CareResult(area: .security, title: CareArea.security.rawValue, detail: "Review privacy, software updates, and app permissions in Settings. ZOBOP does not claim access to protected security state.", status: .good),
            CareResult(area: .system, title: CareArea.system.rawValue, detail: "System optimization is limited to Apple-controlled settings and safe recommendations.", status: .good),
            CareResult(area: .icloud, title: CareArea.icloud.rawValue, detail: snapshot.icloudAvailable ? "iCloud identity is available to the app." : "iCloud identity is not available to the app. Check your Apple Account and app permissions.", status: snapshot.icloudAvailable ? .good : .attention)
        ]
    }
}
