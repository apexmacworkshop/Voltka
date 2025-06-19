# Voltka

Voltka is a lightweight macOS battery monitoring application designed to provide detailed insights into your Mac's battery status. With a sleek menu bar interface and a detailed main window, Voltka offers real-time battery information, customizable display options, and a user-friendly settings panel. Built with SwiftUI and a Go backend, Voltka combines modern macOS design with efficient system integration.

![Voltka Icon](https://github.com/apexmacworkshop/Voltka/raw/main/preview_screenshots/Voltka%20Dock%20Icons%20Screenshot.png)

## Features

- **Menu Bar Integration**: Displays battery percentage, time remaining, or wattage in the macOS menu bar with a customizable icon.
- **Detailed Battery Information**: View charge percentage, health status, cycle count, current capacity, voltage, amperage, and estimated time to full/empty.
- **Customizable Display**: Choose what to show in the menu bar (percentage, time, or wattage) and select from multiple theme colors.
- **Dock Icon Toggle**: Option to show or hide the app icon in the Dock for a minimalistic experience.
- **Real-Time Updates**: Fast updates (every 2 seconds) for charge status and percentage, with slower updates (every 5 minutes) for detailed battery metrics.
- **Battery Health Insights**: Monitor battery health with calculated health percentage and status indicators.
- **Low CPU Usage**: Only 0.6% CPU Usage on background.

![Voltka Main Window](https://github.com/apexmacworkshop/Voltka/raw/main/preview_screenshots/Voltka%20Main%20Panel%20Preview%20Screenshot.png)

## Requirements

- **macOS**: macOS 14.0 (Sonoma) or later
- **Hardware**: Any Mac with a battery (e.g., MacBook, MacBook Air, MacBook Pro)
- **Dependencies**:
  - Xcode 13 or later (for development)
  - Go 1.16 or later (for building the backend plugin)

## Installation

### Pre-built Binary

1. Download the latest release from the [Releases](https://github.com/apexmacworkshop/Voltka/releases) page.
2. Unzip the downloaded file and move `Voltka.app` to your `/Applications` folder.
3. Launch Voltka from the Applications folder or Spotlight.

### Building from Source

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/apexmacworkshop/Voltka.git
   cd Voltka
   ```

2. **Build the Go Backend**:
   Ensure Go is installed (`go version` to verify). Compile the Go backend plugin:
   ```bash
   cd VoltkaApp/Plugins
   go build -o main main.go
   ```

3. **Open in Xcode**:
   - Open `Voltka.xcodeproj` in Xcode.
   - Select your development team in the Signing & Capabilities section.
   - Build and run the project (`Cmd + R`).

4. **Archive and Export** (Optional):
   - In Xcode, go to `Product > Archive`.
   - Export the app as a macOS application and save it to your preferred location.

## Usage

1. **Launch Voltka**:
   After installation, open Voltka. It will appear in the menu bar with a battery icon and a customizable label (percentage, time, or wattage).

2. **Main Window**:
   Click the menu bar icon to open the main window, which displays:
   - **Charge**: Current battery percentage.
   - **Status**: Charging, fully charged, or on battery.
   - **Time**: Estimated time to full (when charging) or time remaining (on battery).
   - **Battery Health**: Health percentage, cycle count, current capacity, and current draw (in watts).
   - **Footer**: Links to the Apex Mac Workshop GitHub, settings, and a quit button.

3. **Settings**:
   - Access settings via the "Settings..." button in the main window.
   - Configure:
     - **Menu Bar Display**: Choose between percentage, time, or wattage.
     - **Theme Color**: Select from blue, purple, pink, red, orange, yellow, green, indigo, or cyan.
     - **Show Icon in Dock**: Toggle the app’s Dock icon (requires a restart).

   ![Voltka Settings View](https://github.com/apexmacworkshop/Voltka/raw/main/preview_screenshots/Voltka%20Settings%20Screenshot.png)


## Project Structure

- **`VoltkaApp/Sources`**:
  - `BatteryViewModel.swift`: Manages battery data fetching and updates using `pmset` and the Go backend.
  - `ContentView.swift`: Main SwiftUI view for the app’s primary window.
  - `AppSettings.swift`: Handles user preferences (menu bar display, theme color, Dock icon).
  - `MenuBarLabelView.swift`: Custom SwiftUI view for the menu bar extra.
  - `SettingsView.swift`: Settings window for configuring app behavior.
  - `VoltkaApp.swift`: App entry point, defining the menu bar extra and settings scene.
  - `Item.swift`: SwiftData model (placeholder for potential future features).

- **`VoltkaApp/Plugins`**:
  - `main.go`: Go backend that uses `ioreg` to fetch detailed battery information and outputs JSON.

## Technical Details

- **Frontend**: Built with SwiftUI for a native macOS experience.
- **Backend**: A Go plugin (`main`) fetches battery data using the `ioreg` command and outputs JSON, which is parsed by `BatteryViewModel`.
- **Data Fetching**:
  - **Fast Updates**: Every 2 seconds, `pmset -g batt` fetches percentage and charging status.
  - **Slow Updates**: Every 5 minutes, the Go backend fetches detailed metrics (cycle count, capacity, etc.).
- **Persistence**: Uses `@AppStorage` for settings persistence.
- **Menu Bar**: Uses `MenuBarExtra` with a custom `MenuBarLabelView` for dynamic battery visualization.

## Contributing

Contributions are welcome! To contribute:

1. Fork the repository.
2. Create a new branch (`git checkout -b feature/your-feature`).
3. Make your changes and test thoroughly.
4. Commit your changes (`git commit -m "Add your feature"`).
5. Push to your branch (`git push origin feature/your-feature`).
6. Open a pull request.


## Troubleshooting

- **App Doesn’t Show in Menu Bar**:
  - Ensure macOS permissions allow Voltka to run.
  - Check if the Go backend (`main`) is compiled and located in the app’s executable directory.
- **Data Not Updating**:
  - Verify that `pmset` and `ioreg` commands are accessible in Terminal.
  - Check Xcode console logs for errors related to `shell` or `executePlugin`.
- **Dock Icon Setting Not Applying**:
  - Restart the app after toggling the "Show icon in Dock" setting.
- **Build Errors**:
  - Ensure Go is installed and the backend is built (`go build -o main main.go`).
  - Verify Xcode signing settings are configured correctly.

## License

Voltka is licensed under the [Apache 2.0 License](LICENSE). See the LICENSE file for details.

## Credits

- **Created by**: Gordon.H
- **Organization**: [Apex Mac Workshop](https://github.com/apexmacworkshop)
- **Built with**: SwiftUI, Combine, Go, and love for macOS.

## Screenshots

- **Main Window**: Shows detailed battery information and settings access.
  ![Main Window](https://github.com/apexmacworkshop/Voltka/raw/main/preview_screenshots/Voltka%20Main%20Panel%20Preview%20Screenshot.png)

- **Menu Bar**: Displays battery status with customizable label.
  ![Menu Bar](https://github.com/apexmacworkshop/Voltka/raw/main/preview_screenshots/Dock%20Icon%20Preview%20Screenshot.png)

- **Settings**: Configure display options, theme, and Dock behavior.
  ![Settings View](https://github.com/apexmacworkshop/Voltka/raw/main/preview_screenshots/Voltka%20Settings%20Screenshot.png)

- **Terminal CPU Usage**: Displays CPU usage when running Voltka.
  ![Terminal CPU Usage](https://github.com/apexmacworkshop/Voltka/raw/main/preview_screenshots/Voltka%20Terminal%20CPU%20Usage%20Screenshot.png)

---

Thank you for using Voltka! For issues or feature requests, please open an issue on the [GitHub repository](https://github.com/apexmacworkshop/Voltka).
Built With Love. 
