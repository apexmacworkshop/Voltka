//
//  Item.swift
//  Voltka
//
//  Created by Ziqian Huang on 2025/6/18.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
