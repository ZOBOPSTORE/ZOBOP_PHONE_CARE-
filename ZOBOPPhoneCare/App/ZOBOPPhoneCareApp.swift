import SwiftUI

@main
struct ZOBOPPhoneCareApp: App {
    @StateObject private var monitor = DeviceMonitor()
    @StateObject private var subscriptionStore = SubscriptionStore()
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
            .environmentObject(subscriptionStore)
            .preferredColorScheme(.dark)
            .task { await subscriptionStore.start() }
        }
    }
}
