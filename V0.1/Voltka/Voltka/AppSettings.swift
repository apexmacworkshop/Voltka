//
//  AppSettings.swift
//  Voltka
//
//  Created by Ziqian Huang on 2025/6/18.
//

import SwiftUI

enum MenuBarDisplay: String, CaseIterable, Identifiable {
    case percentage = "Percentage"
    case time = "Time"
    case wattage = "Wattage"
    
    var id: String { self.rawValue }
}

enum ThemeColor: String, CaseIterable, Identifiable {
    case blue, purple, pink, red, orange, yellow, green, indigo, cyan
    
    var id: String { self.rawValue }
    
    var color: Color {
        switch self {
        case .blue: return .blue
        case .purple: return .purple
        case .pink: return .pink
        case .red: return .red
        case .orange: return .orange
        case .yellow: return .yellow
        case .green: return .green
        case .indigo: return .indigo
        case .cyan: return .cyan
        }
    }
}

class AppSettings: ObservableObject {
    @AppStorage("menuBarDisplayOption") var menuBarDisplay: MenuBarDisplay = .percentage
    @AppStorage("showInDock") var showInDock: Bool = false {
        didSet {
            if oldValue != showInDock {
                needsRestartForDock = true
            }
        }
    }
    @AppStorage("themeColor") var themeColor: ThemeColor = .blue
    @Published var needsRestartForDock: Bool = false
    
    func applyDockIconSetting() {
        if showInDock {
            NSApp.setActivationPolicy(.regular)
        } else {
            NSApp.setActivationPolicy(.accessory)
        }
    }
}
