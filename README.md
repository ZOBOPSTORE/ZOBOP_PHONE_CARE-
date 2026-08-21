# ZOBOP iPhone Care

A premium iPhone companion focused on honest, user-controlled device care.

## V1 status

The repository now contains a SwiftUI V1 source foundation with:

- Battery charge telemetry and charging-state insight
- Storage capacity insight with iOS-safe cleanup guidance
- Performance and Low Power Mode guidance
- Transparent security review guidance
- System optimization recommendations without unsupported system control
- iCloud availability detection for app-level capabilities
- iPhone customization hub for Add Widget, Customize, Edit Wallpaper, and Edit Pages
- Premium ZOBOP visual direction: glossy electric/neon blue, black, metallic silver, and a Z emblem treatment
- Responsive SwiftUI structure using iPhone 16 Pro Max as the primary test reference while supporting compatible iPhones generally

## iOS boundaries

ZOBOP iPhone Care intentionally does **not** claim to:

- delete other apps' private files
- change system performance globally or force-close other apps
- access passcodes, Face ID templates, or protected security state
- change wallpaper or Home Screen pages automatically
- manage a user's entire iCloud account

Actions outside the iOS sandbox are presented as user-controlled guidance or routes to permitted Settings areas.

## Source layout

```text
ZOBOPPhoneCare/
├── App/ZOBOPPhoneCareApp.swift
├── Models/CareModels.swift
├── Services/DeviceMonitor.swift
└── Views/
    ├── ContentView.swift
    ├── CustomizeView.swift
    └── SettingsGuideView.swift
```

## Next delivery steps

1. Add a native Xcode project wrapper and app assets.
2. Add WidgetKit extension and widget timeline.
3. Add onboarding and permissions education.
4. Add unit tests and UI tests using an iPhone 16 Pro Max simulator profile.
5. Add App Store privacy disclosures and review copy.
6. Run on-device testing before release.
