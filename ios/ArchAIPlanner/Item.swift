//
//  Item.swift
//  ArchAIPlanner
//
//  Created by Rork on May 8, 2026.
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
