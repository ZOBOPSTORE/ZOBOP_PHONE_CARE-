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
        XCTAssertEqual(score.summary, "Your iPhone looks well maintained")
    }

    func testLowBatteryAndStorageArePenalizedDeterministically() {
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
        XCTAssertEqual(score.summary, "Battery critically low")
    }

    func testLowPowerModeAndUnavailableICloudAreIncluded() {
        let snapshot = HealthSnapshot(
            batteryLevel: 50,
            batteryState: "Unplugged",
            freeStorageBytes: 100,
            totalStorageBytes: 200,
            lowPowerMode: true,
            icloudAvailable: false
        )

        let score = CareScoring.makeScore(snapshot: snapshot)
        XCTAssertEqual(score.value, 93)
        XCTAssertEqual(score.status, .good)
    }

    func testStoragePenaltyUsesFreeSpaceThresholds() {
        let snapshot = HealthSnapshot(
            batteryLevel: 80,
            batteryState: "Unplugged",
            freeStorageBytes: 30,
            totalStorageBytes: 200,
            lowPowerMode: false,
            icloudAvailable: true
        )

        XCTAssertEqual(CareScoring.makeScore(snapshot: snapshot).value, 92)
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
