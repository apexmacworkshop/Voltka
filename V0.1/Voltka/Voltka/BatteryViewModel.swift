//
//  BatteryViewModel.swift
//  Voltka
//
//  Created by Ziqian Huang on 2025/6/18.

// File: VoltkaApp/Sources/BatteryViewModel.swift
import Foundation
import Combine

struct CombinedBatteryInfo {
    var percentage: Int?
    var isCharging: Bool?
    var isCharged: Bool?
    var cycleCount: Int?
    var designCapacity: Int?
    var currentCapacity: Int?
    var healthStatus: String?
    var voltage: Int?
    var amperage: Int?
    var timeToFull: Int?
    var timeToEmpty: Int?
    
    var healthPercentage: Int? {
        guard let design = designCapacity, let current = currentCapacity, design > 0 else { return nil }
        return Int((Double(current) / Double(design)) * 100)
    }
}

struct GoBackendResponse: Codable {
    let is_charging: Bool
    let is_charged: Bool
    let percentage: Int
    let cycle_count: Int
    let design_capacity: Int
    let current_capacity: Int
    let health_status: String
    let amperage: Int?
    let voltage: Int
    let time_to_full: Int
    let time_to_empty: Int
}

@MainActor
class BatteryViewModel: ObservableObject {
    @Published var batteryInfo = CombinedBatteryInfo()
    @Published var statusMessage = "Loading..."
    
    private var fastTimer: Timer?
    private var slowTimer: Timer?

    init() {
        startFetching()
    }

    func startFetching() {
        Task {
            await fetchFastData()
            await fetchSlowData()
        }
        
        fastTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [weak self] _ in
            Task { await self?.fetchFastData() }
        }
        
        slowTimer = Timer.scheduledTimer(withTimeInterval: 300.0, repeats: true) { [weak self] _ in
            Task { await self?.fetchSlowData() }
        }
    }
    
    private func fetchFastData() async {
        let output = shell("/usr/bin/pmset", "-g", "batt")
        guard !output.isEmpty else { return }
        
        batteryInfo.percentage = Int(parse(from: output, regex: #"(\d{1,3})%"#) ?? "")
        batteryInfo.isCharging = output.contains(" charging;")
        self.statusMessage = "Last updated: \(Date().formatted(date: .omitted, time: .standard))"
    }
    
    private func fetchSlowData() async {
        guard let backendData: GoBackendResponse = await executePlugin(named: "main") else {
            self.statusMessage = "Error: Backend data failed"
            return
        }
        
        batteryInfo.percentage = backendData.percentage
        batteryInfo.isCharging = backendData.is_charging
        batteryInfo.isCharged = backendData.is_charged
        batteryInfo.cycleCount = backendData.cycle_count
        batteryInfo.designCapacity = backendData.design_capacity
        batteryInfo.currentCapacity = backendData.current_capacity
        batteryInfo.healthStatus = backendData.health_status
        batteryInfo.voltage = backendData.voltage
        batteryInfo.amperage = backendData.amperage
        batteryInfo.timeToFull = backendData.time_to_full == 0 ? nil : backendData.time_to_full
        batteryInfo.timeToEmpty = backendData.time_to_empty == 0 ? nil : backendData.time_to_empty
    }
    
    private func shell(_ launchPath: String, _ arguments: String...) -> String {
        let process = Process()
        let pipe = Pipe()
        process.executableURL = URL(fileURLWithPath: launchPath)
        process.arguments = arguments
        process.standardOutput = pipe
        do {
            try process.run()
            process.waitUntilExit()
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            return String(data: data, encoding: .utf8) ?? ""
        } catch {
            print("❌ ERROR: Failed to run shell command '\(launchPath)': \(error)")
            return ""
        }
    }
    
    private func parse(from text: String, regex: String) -> String? {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            if let match = regex.firstMatch(in: text, range: NSRange(text.startIndex..., in: text)) {
                if match.numberOfRanges > 1, let range = Range(match.range(at: 1), in: text) {
                    return String(text[range])
                }
            }
        } catch {
            print("❌ ERROR: Invalid regex '\(regex)': \(error)")
        }
        return nil
    }

    private func executePlugin<T: Decodable>(named executableName: String) async -> T? {
        guard let bundlePath = Bundle.main.executableURL?.deletingLastPathComponent().path else {
            print("❌ ERROR: Could not determine executable path for plugins.")
            return nil
        }
        
        let executablePath = "\(bundlePath)/\(executableName)"

        guard FileManager.default.fileExists(atPath: executablePath) else {
            print("❌ ERROR: Plugin '\(executableName)' not found at path: \(executablePath)")
            return nil
        }

        let output = shell(executablePath)
        guard let data = output.data(using: .utf8) else {
            print("❌ ERROR: Could not get data from plugin '\(executableName)'. Output was: '\(output)'")
            return nil
        }
        
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            print("❌ ERROR: Failed to decode JSON from '\(executableName)'. Output: '\(output)'. Error: \(error)")
            return nil
        }
    }
}
