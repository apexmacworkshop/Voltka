//
//  MenuBarLabelView.swift
//  Voltka
//
//  Created by Ziqian Huang on 2025/6/18.
//

// File: VoltkaApp.swift
// File: MenuBarLabelView.swift (Renamed from MenuBarBatteryView)
// File: MenuBarLabelView.swift
import SwiftUI

struct MenuBarLabelView: View {
    let info: CombinedBatteryInfo
    let displayOption: MenuBarDisplay
    
    var body: some View {
        HStack(spacing: 2) {
            ZStack {
                Image(systemName: "battery.0").font(.body)
                GeometryReader { geo in
                    let fillWidth = geo.size.width * 0.7
                    let fillOffset = geo.size.width * 0.05
                    Rectangle()
                        .path(in: CGRect(
                            x: fillOffset, y: geo.size.height * 0.22,
                            width: fillWidth * CGFloat(info.percentage ?? 0) / 100.0,
                            height: geo.size.height * 0.56
                        ))
                        .fill(batteryColor())
                }
                if info.isCharging == true {
                    Image(systemName: "bolt.fill")
                        .font(.caption)
                        .foregroundColor(.white)
                        .opacity(0.8)
                }
            }

            if let text = menuBarText() {
                Text(text)
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                    .monospacedDigit()
            }
        }
    }

    private func menuBarText() -> String? {
        switch displayOption {
        case .percentage:
            guard let percentage = info.percentage else { return "..." }
            return "\(percentage)%"
        case .time:
            let timeValue = info.isCharging == true ? info.timeToFull : info.timeToEmpty
            guard let time = timeValue else { return "--:--" }
            return formatTime(minutes: time)
        case .wattage:
            guard let amps = info.amperage, let volts = info.voltage else { return "..." }
            let watts = abs(Double(amps) * Double(volts) / 1000.0)
            return String(format: "%.1fW", watts)
        }
    }
    
    private func formatTime(minutes: Int) -> String {
        let hours = minutes / 60
        let remainingMinutes = minutes % 60
        return String(format: "%02d:%02d", hours, remainingMinutes)
    }

    private func batteryColor() -> Color {
        guard let percentage = info.percentage else { return .secondary }
        
        if info.isCharging == true {
            return .accentColor
        }
        
        switch percentage {
        case 0...20: return .red
        default: return .green
        }
    }
}
