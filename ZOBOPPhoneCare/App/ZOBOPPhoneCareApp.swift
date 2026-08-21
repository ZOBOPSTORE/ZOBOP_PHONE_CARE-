import SwiftUI

@main
struct ZOBOPPhoneCareApp: App {
    @StateObject private var monitor = DeviceMonitor()
    @AppStorage("zobop.onboarding.completed") private var onboardingCompleted = false

    var body: some Scene {
        WindowGroup {
            Group {
                if onboardingCompleted {
                    ContentView()
                        .environmentObject(monitor)
                } else {
                    OnboardingView()
                }
            }
            .preferredColorScheme(.dark)
        }
    }
}
