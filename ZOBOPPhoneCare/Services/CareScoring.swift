import Foundation

struct CareScore: Equatable {
    let value: Int
    let status: CareResult.Status
    let summary: String
}

enum CareScoring {
    static func makeScore(snapshot: HealthSnapshot) -> CareScore {
        var score = 100
        var penalties: [String] = []

        if let battery = snapshot.batteryLevel {
            if battery <= 10 { score -= 28; penalties.append("Battery critically low") }
            else if battery <= 20 { score -= 15; penalties.append("Battery is low") }
        }

        if snapshot.lowPowerMode {
            score -= 3
        }

        if let free = snapshot.freeStorageBytes, let total = snapshot.totalStorageBytes, total > 0 {
            let freeRatio = Double(free) / Double(total)
            if freeRatio < 0.05 { score -= 30; penalties.append("Storage is nearly full") }
            else if freeRatio < 0.10 { score -= 18; penalties.append("Storage is running low") }
            else if freeRatio < 0.20 { score -= 8 }
        }

        if !snapshot.icloudAvailable {
            score -= 4
        }

        score = min(100, max(0, score))
        let status: CareResult.Status = score >= 85 ? .good : (score >= 60 ? .attention : .attention)
        let summary = penalties.first ?? (score >= 85 ? "Your iPhone looks well maintained" : "A few areas could use attention")
        return CareScore(value: score, status: status, summary: summary)
    }
}
