<p align="right"><b>English</b> | <a href="./README_RU.md">Русский</a></p>

# <img src="Assets/Logo.png" width="40" height="40" alt="Network Scanner Logo"> Network Scanner

<p align="left">
  <img src="https://img.shields.io/badge/iOS-15%2B-000000?logo=apple&logoColor=white" alt="iOS 15+"/>
  <img src="https://img.shields.io/badge/SwiftUI-0A84FF?logo=swift&logoColor=white" alt="SwiftUI"/>
  <img src="https://img.shields.io/badge/CoreData-5856D6?logo=apple&logoColor=white" alt="CoreData"/>
  <img src="https://img.shields.io/badge/CocoaPods-EE3322?logo=cocoapods&logoColor=white" alt="CocoaPods"/>
  <img src="https://img.shields.io/badge/SPM-F05138?logo=swift&logoColor=white" alt="Swift Package Manager"/>
  <img src="https://img.shields.io/badge/CoreBluetooth-007AFF?logo=bluetooth&logoColor=white" alt="CoreBluetooth"/>
  <img src="https://img.shields.io/badge/MMLanScan-4BC51D?logo=github&logoColor=white" alt="MMLanScan"/>
  <img src="https://img.shields.io/badge/Lottie-00DDB3?logo=lottiefiles&logoColor=white" alt="Lottie"/>
  <img src="https://img.shields.io/badge/MVVM-Architecture-orange?logo=swift&logoColor=white" alt="MVVM Architecture"/>
</p>

A powerful network scanning utility for iOS, built with **SwiftUI** and **MVVM** architecture. The application provides comprehensive tools for discovering devices on your Local Area Network (LAN) using **MMLanScan** and detecting nearby Bluetooth peripherals with **CoreBluetooth**. It features a modern interface with **Lottie** animations and robust data persistence using **CoreData**.

## ⚠️ Important

**MAC addresses and device brands are not available on iOS 11+** due to Apple's privacy restrictions. This is a system-level limitation affecting all network scanning applications.

## ✨ Features

- **📡 LAN Scanner:** Quickly detect all devices connected to your Wi-Fi network using the robust **MMLanScan** library.
- **🔵 Bluetooth Scanner:** Discover nearby Bluetooth devices, view their signal strength (RSSI), connection status, and explore advertised services using **CoreBluetooth**.
- **💾 History & Persistence:** Automatically save your scan sessions to a local **CoreData** database. Filter results by time and device name for easy access.
- **📱 Device Details:** View detailed technical information about every discovered device.
- **🎨 Modern UI:** A clean, responsive interface enhanced with smooth **Lottie** animations, including a dedicated Launch Screen.
- **👆 Gestures & Refresh:** Manage data intuitively with swipe-to-delete gestures and pull-to-refresh functionality.
- **⚡️ Fast Search:** Super fast search capability powered directly by the database.
- **🛡️ Robust Error Handling:** Comprehensive error handling to ensure a smooth user experience.

## 🖼️ Preview

| Permissions (iOS 26.1) | Bluetooth Scanning (iOS 26.1) | Bluetooth Error (iOS 26.1) |
|:---:|:---:|:---:|
| <img src="Assets/Persmissions.gif" alt="Permissions" width="250"/> | <img src="Assets/Bluetooth.gif" alt="Bluetooth Scanning" width="250"/> | <img src="Assets/BluetoothError.gif" alt="Bluetooth Error" width="250"/> |

| LAN Scanning (iOS 17.5) | LAN Error (iOS 26.1) | History (iOS 17.5) |
|:---:|:---:|:---:|
| <img src="Assets/Lan.gif" alt="LAN Scanning" width="250"/> | <img src="Assets/LanError.gif" alt="LAN Error" width="250"/> | <img src="Assets/History.gif" alt="History" width="250"/> |

## 🛠️ Technologies & Architecture

The project is built using the **MVVM (Model-View-ViewModel)** architectural pattern to ensure separation of concerns and testability.

- **SwiftUI:** For building a declarative and responsive user interface.
- **CoreData:** For local data persistence of scan history.
- **CoreBluetooth:** For interacting with Bluetooth Low Energy devices.
- **MMLanScan:** A powerful library for network discovery.
- **Lottie:** For rendering high-quality vector animations.
- **CocoaPods & SPM:** Used for dependency management.

## 🚀 Installation

This project uses **CocoaPods** for some dependencies.

1. **Clone the repository:**

   ```bash
   git clone https://github.com/teenagelove/NetworkScanner.git
   cd NetworkScanner
   ```

2. **Install Pods:**

   ```bash
   pod install
   ```

3. **Open the Workspace:**
   ⚠️ **Important:** Always open the `.xcworkspace` file, not the `.xcodeproj` file.

   ```bash
   open NetworkScanner.xcworkspace
   ```

## 👥 Contributors

- [Danil Kazakov](https://github.com/teenagelove) - creator and maintainer

## 📄 License

This project is available under the MIT license. See the LICENSE file for more info.
