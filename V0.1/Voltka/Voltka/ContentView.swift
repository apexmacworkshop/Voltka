//
//  ContentView.swift
//  Voltka
//
//  Created by Ziqian Huang on 2025/6/18.
//

// File: VoltkaApp/Sources/ContentView.swift
// File: VoltkaApp/Sources/ContentView.swift
// File: VoltkaApp/Sources/ContentView.swift
// File: VoltkaApp/Sources/ContentView.swift
import SwiftUI

struct ContentView: View {
    // This view receives both the viewModel for data and settings for configuration.
    @ObservedObject var viewModel: BatteryViewModel
    @ObservedObject var settings: AppSettings

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // --- Header ---
            Text("Voltka")
                .font(.system(size: 36, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
            
            Divider()

            // --- Main Status Section ---
            InfoRow(label: "Charge", value: "\(viewModel.batteryInfo.percentage ?? 0)%", systemImage: "battery.100.bolt")
            InfoRow(label: "Status", value: statusText(), systemImage: statusIcon())
            
            if viewModel.batteryInfo.isCharging == true {
                InfoRow(label: "Time to Full", value: formatTime(minutes: viewModel.batteryInfo.timeToFull), systemImage: "timelapse")
            } else {
                InfoRow(label: "Time Remaining", value: formatTime(minutes: viewModel.batteryInfo.timeToEmpty), systemImage: "hourglass")
            }
            
            Divider()
            
            // --- Battery Health Section ---
            Text("Battery Health").font(.headline).foregroundColor(.secondary)
            InfoRow(label: "Health", value: "\(viewModel.batteryInfo.healthPercentage ?? 100)% (\(viewModel.batteryInfo.healthStatus ?? "Good"))", systemImage: "heart.fill")
            InfoRow(label: "Charge Cycles", value: "\(viewModel.batteryInfo.cycleCount ?? 0)", systemImage: "arrow.2.circlepath.circle.fill")
            InfoRow(label: "Current Capacity", value: "\(viewModel.batteryInfo.currentCapacity ?? 0) mAh", systemImage: "bolt.batteryblock.fill")

            if let amps = viewModel.batteryInfo.amperage, let volts = viewModel.batteryInfo.voltage {
                let watts = abs(Double(amps) * Double(volts) / 1000.0)
                let prefix = amps < 0 ? "-" : "+"
                InfoRow(label: "Current Draw", value: "\(String(format: "%@%.2f W", prefix, watts))", systemImage: "speedometer")
            }

            // --- Footer Section ---
            Spacer() // Pushes all footer content to the bottom.
            Divider()
            
            // The "About" section with creator and workshop info.
            HStack {
                Text("Created by Gordon.H").font(.caption).foregroundColor(.secondary)
                Spacer()
                Link(destination: URL(string: "https://github.com/orgs/apexmacworkshop")!) {
                    HStack(spacing: 4) {
                        Text("Apex Mac Workshop").font(.caption)
                        Image(systemName: "link.circle.fill")
                    }
                }
                .buttonStyle(.plain)
            }
            .padding(.top, 4)
            
            // A dedicated row for action buttons.
            HStack {
                // ** THE FIX **
                // SettingsLink is the modern, idiomatic SwiftUI way to open the
                // Settings scene defined in VoltkaApp.swift.
                SettingsLink {
                    // This label makes it look just like a standard button.
                    Text("Settings...")
                }
                
                Spacer()
                
                Button("Quit Voltka") {
                    NSApplication.shared.terminate(nil)
                }
            }
            .padding(.top, 8)

            // The timestamp for the last data refresh.
            Text(viewModel.statusMessage)
                .font(.caption).foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 4)
        }
        .padding()
        .frame(width: 380)
        // This modifier ensures the dock icon setting is applied only *after*
        // the app has properly launched and the settings object is initialized.
        .onAppear {
            settings.applyDockIconSetting()
        }
    }

    // MARK: - Helper Functions

    private func statusText() -> String {
        if viewModel.batteryInfo.isCharged == true { return "Fully Charged" }
        if viewModel.batteryInfo.isCharging == true { return "Charging" }
        return "On Battery"
    }
    
    private func statusIcon() -> String {
        if viewModel.batteryInfo.isCharged == true { return "battery.100.bolt" }
        if viewModel.batteryInfo.isCharging == true { return "powerplug.fill" }
        return "powerplug"
    }

    private func formatTime(minutes: Int?) -> String {
        guard let minutes = minutes, minutes > 0 else { return "Calculating..." }
        let hours = minutes / 60
        let remainingMinutes = minutes % 60
        return "\(hours)h \(remainingMinutes)m"
    }
}

// MARK: - Reusable InfoRow View

struct InfoRow: View {
    var label: String
    var value: String
    var systemImage: String
    
    var body: some View {
        HStack {
            Image(systemName: systemImage)
                .font(.title2)
                .frame(width: 35)
                .foregroundColor(.accentColor)
            
            Text(label)
                .font(.headline)
            
            Spacer()
            
            Text(value)
                .font(.body.monospacedDigit())
                .fontWeight(.semibold)
        }
    }
}
