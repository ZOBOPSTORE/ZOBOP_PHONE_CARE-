import SwiftUI
import UIKit

struct CustomizeView: View {
    @State private var message = ""

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    ZStack(alignment: .bottomLeading) {
                        RoundedRectangle(cornerRadius: 30).fill(LinearGradient(colors: [.blue.opacity(0.75), .black, .cyan.opacity(0.25)], startPoint: .topLeading, endPoint: .bottomTrailing))
                        VStack(alignment: .leading, spacing: 6) {
                            Text("MAKE IT YOURS").font(.caption.weight(.bold)).foregroundStyle(.cyan)
                            Text("iPhone customization").font(.largeTitle.bold())
                            Text("ZOBOP gives you quick, user-controlled routes. iOS protects Home Screen, wallpaper, and page editing from third-party automation.").font(.caption).foregroundStyle(.white.opacity(0.72))
                        }.padding(22)
                    }.frame(height: 220)

                    CustomizationAction(icon: "square.grid.2x2.fill", title: "Add Widget", subtitle: "Learn how to add the ZOBOP widget from your Home Screen.") { message = "Touch and hold the Home Screen → Edit → Add Widget → choose ZOBOP iPhone Care (when the widget extension is installed)." }
                    CustomizationAction(icon: "paintbrush.fill", title: "Customize", subtitle: "Open app settings and control ZOBOP preferences.") { openAppSettings() }
                    CustomizationAction(icon: "photo.on.rectangle.angled", title: "Edit Wallpaper", subtitle: "Open Apple Photos to choose an image; wallpaper changes remain user-controlled in iOS.") { openURL(URL(string: "photos-redirect://")!) }
                    CustomizationAction(icon: "rectangle.3.group.fill", title: "Edit Pages", subtitle: "Learn the safe iOS method for showing, hiding, and organizing Home Screen pages.") { message = "Touch and hold the Home Screen → Edit → Edit Pages. Select pages to show or hide, then tap Done." }

                    if !message.isEmpty {
                        Text(message).font(.subheadline).padding(16).frame(maxWidth: .infinity, alignment: .leading).background(.cyan.opacity(0.12)).clipShape(RoundedRectangle(cornerRadius: 18))
                    }
                }.padding()
            }
            .background(ZobopTheme.background.ignoresSafeArea())
            .navigationTitle("Customize")
        }
    }

    private func openAppSettings() {
        openURL(URL(string: UIApplication.openSettingsURLString)!)
    }

    private func openURL(_ url: URL) {
        UIApplication.shared.open(url)
    }
}

private struct CustomizationAction: View {
    let icon: String
    let title: String
    let subtitle: String
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                Image(systemName: icon).font(.title3).frame(width: 42, height: 42).background(.cyan.opacity(0.14)).clipShape(RoundedRectangle(cornerRadius: 14))
                VStack(alignment: .leading, spacing: 3) { Text(title).font(.headline); Text(subtitle).font(.caption).foregroundStyle(.secondary).multilineTextAlignment(.leading) }
                Spacer(); Image(systemName: "chevron.right").foregroundStyle(.secondary)
            }.padding(14)
        }
        .buttonStyle(.plain)
        .background(ZobopTheme.panel)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}
