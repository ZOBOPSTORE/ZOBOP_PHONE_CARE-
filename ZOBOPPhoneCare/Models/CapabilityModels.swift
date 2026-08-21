import Foundation

/// Describes what ZOBOP Phone Care can actually do on stock iOS.
/// Keeping these boundaries explicit prevents unsupported "cleaner" or "booster" claims.
enum CapabilityAccess: String, Codable, Hashable {
    case automatic = "Automatic"
    case userGuided = "User-guided"
    case unavailable = "Unavailable"
}

struct CapabilityItem: Identifiable, Hashable {
    let id: String
    let title: String
    let access: CapabilityAccess
    let summary: String
    let actionLabel: String

    static let all: [CapabilityItem] = [
        CapabilityItem(id: "battery-level", title: "Current battery level", access: .automatic, summary: "Read the current battery charge when iOS provides it.", actionLabel: "Refresh"),
        CapabilityItem(id: "battery-health", title: "Battery health guidance", access: .userGuided, summary: "Open Battery settings to review Apple-provided battery health information.", actionLabel: "Open Settings"),
        CapabilityItem(id: "storage", title: "Storage analysis", access: .automatic, summary: "Read available device volume capacity exposed to the app.", actionLabel: "Refresh"),
        CapabilityItem(id: "storage-cleanup", title: "Storage cleanup", access: .userGuided, summary: "Guide the user to review photos, downloads and app storage. ZOBOP cannot delete other apps' files.", actionLabel: "Review"),
        CapabilityItem(id: "performance", title: "Performance check", access: .userGuided, summary: "Explain Low Power Mode and safe actions. iOS does not permit a third-party system-wide RAM or CPU boost.", actionLabel: "Review"),
        CapabilityItem(id: "security", title: "Security check", access: .userGuided, summary: "Guide software update and privacy reviews without claiming access to protected device security state.", actionLabel: "Review"),
        CapabilityItem(id: "system", title: "System optimizer", access: .userGuided, summary: "Provide safe recommendations; protected system settings remain under user and Apple control.", actionLabel: "Review"),
        CapabilityItem(id: "icloud", title: "iCloud availability", access: .automatic, summary: "Detect whether an iCloud identity is available to this app.", actionLabel: "Refresh"),
        CapabilityItem(id: "widget", title: "Add Widget", access: .userGuided, summary: "Provide a WidgetKit widget that the user adds from the iPhone Home Screen.", actionLabel: "Show Guide"),
        CapabilityItem(id: "customize", title: "Customize", access: .userGuided, summary: "Offer ZOBOP theme and personalization options inside the app.", actionLabel: "Customize"),
        CapabilityItem(id: "wallpaper", title: "Edit Wallpaper", access: .userGuided, summary: "Prepare wallpaper artwork for the user to save and set; ZOBOP cannot silently replace the system wallpaper.", actionLabel: "Choose Wallpaper"),
        CapabilityItem(id: "pages", title: "Edit Pages", access: .userGuided, summary: "Explain how to edit Home Screen pages; iOS does not let a third-party app reorder them automatically.", actionLabel: "Show Guide")
    ]
}
