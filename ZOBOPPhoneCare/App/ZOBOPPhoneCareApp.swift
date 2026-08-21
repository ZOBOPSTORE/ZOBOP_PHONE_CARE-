import SwiftUI

@main
struct ZOBOPPhoneCareApp: App {
    @StateObject private var monitor = DeviceMonitor()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(monitor)
                .preferredColorScheme(.dark)
        }
    }
}
