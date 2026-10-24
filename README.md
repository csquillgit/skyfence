# SkyFence 🛸🛡️

> **Offline Airspace Advisor & Drone Legal Ceiling Checker**  
> Built for drone pilots (FAA Part 107 & recreational TRUST). Instantly answers *"Can I fly here right now, and how high can I legally go?"* with zero cell connection.

---

## ⚡ Features

* **Instant Airspace Advisory**: Real-time evaluation of Class B, Class C, Class D, National Parks, and Heliport boundaries.
* **Legal Drone Ceiling Gauge**: Dynamic HUD gauge displaying maximum legal altitude: **400 FT AGL**, **200 FT**, **100 FT**, or **0 FT (GROUNDED)**.
* **Pre-Flight Telemetry**: Live civil sunset countdown (FAA daylight rule), GPS precision indicator, and distance to the nearest airspace boundary.
* **Airspace Directory**: Searchable offline database of airports, military MOAs, national parks (NPS 36 CFR 1.5 ban), and trauma hospital helipads.
* **Pre-Flight Safety Checklist**: 7-point interactive checklist for props, batteries, RTH altitude, sensors, and airspace clearance.
* **Offline Flight Logbook**: Record flights, drone model, duration, and max altitude directly on device.
* **Tactical Design System**: Dark tactical aesthetic (`#0B0F19`), neon emerald/cyan HUD accents, and high-contrast typography.

---

## 🚀 Getting Started

```bash
git clone https://github.com/csquillgit/skyfence.git
cd skyfence
flutter pub get
flutter run --release
```

---

## 🛠️ Architecture
```
lib/
├── main.dart
├── models/
│   ├── airspace_zone.dart
│   ├── flight_assessment.dart
│   └── flight_log.dart
├── services/
│   ├── airspace_engine.dart
│   └── flight_log_service.dart
├── screens/
│   ├── airspaces_screen.dart
│   ├── checklist_screen.dart
│   ├── guide_screen.dart
│   ├── home_screen.dart
│   └── radar_screen.dart
└── widgets/
    ├── airspace_card.dart
    ├── ceiling_gauge.dart
    └── status_banner.dart
```

---

## 📄 License
MIT License. Airspace data based on FAA Aeronautical Information Services.
