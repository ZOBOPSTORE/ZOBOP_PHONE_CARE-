import Foundation
import UIKit

@MainActor
enum CareAction {
    static func openAppSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(url)
    }

    static func openBatterySettings() {
        // Public iOS APIs do not guarantee a supported deep link to Battery settings.
        // Opening this app's Settings page is the safe App Store-compliant fallback.
        openAppSettings()
    }

    static func openStorageSettings() {
        openAppSettings()
    }

    static func openPrivacySettings() {
        openAppSettings()
    }

    static func openICloudSettings() {
        openAppSettings()
    }
}

struct CareRecommendation: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let detail: String
    let symbol: String
}

extension CareArea {
    var recommendations: [CareRecommendation] {
        switch self {
        case .battery:
            return [
                CareRecommendation(title: "Check charge level", detail: "Review the current charge shown by ZOBOP. Battery maximum capacity and cycle count are not exposed to third-party apps.", symbol: "battery.100percent"),
                CareRecommendation(title: "Use optimized charging", detail: "Review Battery settings and keep iOS updated for Apple-managed battery features.", symbol: "bolt.fill")
            ]
        case .storage:
            return [
                CareRecommendation(title: "Review large media", detail: "Remove downloads, duplicate media, and offline files you no longer need from their owning apps.", symbol: "photo.stack"),
                CareRecommendation(title: "Offload unused apps", detail: "Use iPhone Storage recommendations in Settings. ZOBOP cannot delete other apps or their data.", symbol: "externaldrive.fill")
            ]
        case .performance:
            return [
                CareRecommendation(title: "Close the loop on updates", detail: "Install current iOS and app updates. Third-party apps cannot provide a true system-wide CPU or RAM boost.", symbol: "speedometer"),
                CareRecommendation(title: "Review Low Power Mode", detail: "Low Power Mode trades some background activity and performance for battery life.", symbol: "leaf.fill")
            ]
        case .security:
            return [
                CareRecommendation(title: "Review app permissions", detail: "Audit Location, Photos, Camera, Microphone, Contacts, and other permissions in Settings.", symbol: "hand.raised.fill"),
                CareRecommendation(title: "Keep protection current", detail: "Use a strong device passcode, Face ID, and current iOS updates.", symbol: "lock.shield.fill")
            ]
        case .system:
            return [
                CareRecommendation(title: "Restart when appropriate", detail: "A normal restart can help clear a temporary state. ZOBOP cannot repair or tune protected iOS internals.", symbol: "power"),
                CareRecommendation(title: "Use Apple-managed settings", detail: "Review Background App Refresh, notifications, and storage recommendations directly in Settings.", symbol: "slider.horizontal.3")
            ]
        case .icloud:
            return [
                CareRecommendation(title: "Confirm backup", detail: "Review iCloud Backup and storage directly in Apple Account settings. Availability in this app only reflects whether an iCloud identity is accessible to the app.", symbol: "icloud.fill"),
                CareRecommendation(title: "Review synced apps", detail: "Keep only the apps and data you want using iCloud sync.", symbol: "arrow.triangle.2.circlepath")
            ]
        }
    }
}
