//
//  Dream.swift
//  DreamMapper
//
//  Created by Christine Bonoan on 11/14/25.
//

import Foundation
import SwiftData

@Model
final class Dream {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}

