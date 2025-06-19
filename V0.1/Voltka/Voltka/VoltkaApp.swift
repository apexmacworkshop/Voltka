//
//  VoltkaApp.swift
//  Voltka
//
//  Created by Ziqian Huang on 2025/6/18.
//
// File: VoltkaApp.swift
// File: VoltkaApp.swift
// File: VoltkaApp.swift
import SwiftUI

@main
struct VoltkaApp: App {
    @StateObject private var viewModel = BatteryViewModel()
    @StateObject private var settings = AppSettings()

    var body: some Scene {
        MenuBarExtra {
            ContentView(viewModel: viewModel, settings: settings)
                .accentColor(settings.themeColor.color)
        } label: {
            MenuBarLabelView(info: viewModel.batteryInfo, displayOption: settings.menuBarDisplay)
                .accentColor(settings.themeColor.color)
        }
        .menuBarExtraStyle(.window)

        Settings {
            SettingsView(settings: settings)
                .accentColor(settings.themeColor.color)
        }
    }
}
