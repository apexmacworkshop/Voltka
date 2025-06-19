package main

import (
	"encoding/json"
	"os"
	"os/exec"
	"strconv"
	"strings"
)

type BatteryInfo struct {
	IsCharging      bool   `json:"is_charging"`
	IsCharged       bool   `json:"is_charged"`
	Percentage      int    `json:"percentage"`
	CycleCount      int    `json:"cycle_count"`
	DesignCapacity  int    `json:"design_capacity"`
	CurrentCapacity int    `json:"current_capacity"` // This is actually the Full-Charge Capacity (AppleRawMaxCapacity)
	HealthStatus    string `json:"health_status"`
	Voltage         int    `json:"voltage"`
	TimeToFull      int    `json:"time_to_full"`
	TimeToEmpty     int    `json:"time_to_empty"`
}

func parseIoregOutput(output string) BatteryInfo {
	info := BatteryInfo{}
	lines := strings.Split(output, "\n")

	for _, line := range lines {
		line = strings.TrimSpace(line)
		if strings.Contains(line, "=") {
			parts := strings.SplitN(line, "=", 2)
			// The key from ioreg includes the quotes, e.g., `"IsCharging"`
			key := strings.TrimSpace(parts[0])
			value := strings.Trim(strings.TrimSpace(parts[1]), `";`)

			switch key {
			case `"IsCharging"`:
				info.IsCharging = value == "Yes"
			case `"FullyCharged"`:
				info.IsCharged = value == "Yes"
			case `"DesignCapacity"`:
				info.DesignCapacity, _ = strconv.Atoi(value)
			case `"AppleRawMaxCapacity"`:
				info.CurrentCapacity, _ = strconv.Atoi(value)
			case `"CycleCount"`:
				info.CycleCount, _ = strconv.Atoi(value)
			case `"Voltage"`:
				info.Voltage, _ = strconv.Atoi(value)
			case `"AvgTimeToFull"`:
				// 65535 is ioreg's way of saying "not applicable" or "calculating"
				if val, err := strconv.Atoi(value); err == nil && val != 65535 {
					info.TimeToFull = val
				}
			case `"AvgTimeToEmpty"`:
				if val, err := strconv.Atoi(value); err == nil && val != 65535 {
					info.TimeToEmpty = val
				}
			case `"CurrentCapacity"`: // This field is the percentage value
				if maxCap, err := strconv.Atoi(value); err == nil {
					info.Percentage = maxCap
				}
			case `"PermanentFailureStatus"`:
				if value == "0" {
					info.HealthStatus = "Good"
				} else {
					info.HealthStatus = "Service Recommended"
				}
			}
		}
	}

	return info
}

func main() {
	// FIX: Removed the "-a" flag to get plain text output instead of XML
	cmd := exec.Command("ioreg", "-rn", "AppleSmartBattery")
	output, err := cmd.Output()
	if err != nil {
		// It's good practice to also log the error to see why it failed
		// log.Printf("Failed to execute ioreg: %v", err)
		json.NewEncoder(os.Stdout).Encode(BatteryInfo{})
		return
	}

	info := parseIoregOutput(string(output))
	json.NewEncoder(os.Stdout).Encode(info)
}