//
//  SettingsView.swift
//  Voltka
//
//  Created by Ziqian Huang on 2025/6/18.
//

// File: SettingsView.swift
// File: SettingsView.swift
import SwiftUI

struct SettingsView: View {
    @ObservedObject var settings: AppSettings
    
    var body: some View {
        Form {
            Section(header: Text("Menu Bar Display")) {
                Picker("Show next to icon:", selection: $settings.menuBarDisplay) {
                    ForEach(MenuBarDisplay.allCases) { option in
                        Text(option.rawValue).tag(option)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }

            Section(header: Text("Appearance")) {
                Picker("Theme Color:", selection: $settings.themeColor) {
                    ForEach(ThemeColor.allCases) { theme in
                        Text(theme.rawValue.capitalized)
                            .foregroundColor(theme.color)
                            .tag(theme)
                    }
                }
            }
            
            Section(header: Text("Application Behavior")) {
                Toggle("Show icon in Dock", isOn: $settings.showInDock)
                
                if settings.needsRestartForDock {
                    Text("A restart is required for the Dock setting to take effect.")
                        .font(.caption)
                        .foregroundColor(.orange)
                }
            }
        }
        .padding(20)
        .frame(width: 350, height: 250)
    }
}
