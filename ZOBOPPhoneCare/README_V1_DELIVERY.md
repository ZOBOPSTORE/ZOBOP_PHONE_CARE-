# ZOBOP Phone Care — V1 delivery notes

## Product scope
- General iPhone support; primary layout reference: iPhone 16 Pro Max.
- Battery level and charging-state telemetry when iOS exposes it.
- Storage availability analysis.
- Care Score and recommended actions.
- Performance, security and system guidance within the iOS sandbox.
- iCloud identity availability for this app.
- ZOBOP WidgetKit snapshot/widget.
- Requested customization flows: Add Widget, Customize, Edit Wallpaper, Edit Pages.

## Important iOS boundaries
ZOBOP Phone Care must not claim that it can silently:
- read Apple's protected Battery Health / Maximum Capacity value;
- delete another app's data or perform a device-wide junk clean;
- boost RAM, CPU or system performance globally;
- inspect protected device security state;
- change system wallpaper without user action;
- rearrange Home Screen pages programmatically.

## Xcode integration checklist
1. Create the iOS app target and add the `ZOBOPPhoneCare` source folder.
2. Add the WidgetKit extension and a shared App Group used by `WidgetSnapshotStore`.
3. Add StoreKit product identifiers only after they are created in App Store Connect.
4. Set deployment target to the minimum iOS version supported by the SwiftUI APIs in use.
5. Add required privacy usage descriptions only for APIs that are actually enabled.
6. Test on an iPhone 16 Pro Max and at least one additional supported iPhone size.
7. Run the XCTest suite before TestFlight.

## Visual identity
Use glossy electric/neon blue, black and metallic silver. Keep the Z emblem prominent but avoid Apple trade dress or system UI imitation.
