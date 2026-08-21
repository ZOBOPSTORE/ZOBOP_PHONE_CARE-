import XCTest
@testable import ZOBOPPhoneCare

final class CapabilityModelsTests: XCTestCase {
    func testEveryRequestedFeatureHasCapabilityEntry() {
        let ids = Set(CapabilityItem.all.map(\.id))
        [
            "battery-health", "storage-cleanup", "performance", "security", "system", "icloud",
            "widget", "customize", "wallpaper", "pages"
        ].forEach { XCTAssertTrue(ids.contains($0), "Missing capability entry: \($0)") }
    }

    func testAutomaticCapabilitiesDoNotPromiseProtectedSystemControl() {
        let automaticTitles = CapabilityItem.all
            .filter { $0.access == .automatic }
            .map(\.summary)
            .joined(separator: " ")
            .lowercased()

        XCTAssertFalse(automaticTitles.contains("delete other apps"))
        XCTAssertFalse(automaticTitles.contains("system-wide ram"))
    }

    func testCapabilityIDsAreUnique() {
        XCTAssertEqual(Set(CapabilityItem.all.map(\.id)).count, CapabilityItem.all.count)
    }
}
