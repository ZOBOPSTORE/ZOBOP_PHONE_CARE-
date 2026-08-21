import XCTest
@testable import ZOBOPPhoneCare

final class CareScoringTests: XCTestCase {
    func testHealthySnapshotGetsExcellentScore() {
        let snapshot = HealthSnapshot(
            batteryLevel: 82,
            batteryState: "Unplugged",
            freeStorageBytes: 120,
            totalStorageBytes: 200,
            lowPowerMode: false,
            icloudAvailable: true
        )

        let score = CareScoring.makeScore(snapshot: snapshot)
        XCTAssertEqual(score.value, 100)
        XCTAssertEqual(score.status, .good)
    }

    func testCriticalBatteryAndStorageArePenalized() {
        let snapshot = HealthSnapshot(
            batteryLevel: 8,
            batteryState: "Unplugged",
            freeStorageBytes: 8,
            totalStorageBytes: 200,
            lowPowerMode: false,
            icloudAvailable: true
        )

        let score = CareScoring.makeScore(snapshot: snapshot)
        XCTAssertEqual(score.value, 42)
        XCTAssertEqual(score.status, .attention)
    }

    func testScoreNeverDropsBelowZero() {
        let snapshot = HealthSnapshot(
            batteryLevel: 0,
            batteryState: "Unknown",
            freeStorageBytes: 0,
            totalStorageBytes: 100,
            lowPowerMode: true,
            icloudAvailable: false
        )

        XCTAssertEqual(CareScoring.makeScore(snapshot: snapshot).value, 35)
    }
}
