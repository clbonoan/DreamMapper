//
//  Motif.swift
//  DreamMapper
//
//  Created by Christine Bonoan on 11/14/25.
//

import Foundation
import SwiftData

@Model
final class Motif {
    var symbol: String
    var meaning: String
    
    init(
        symbol: String,
        meaning: String
    ) {
        self.symbol = symbol
        self.meaning = meaning
    }
}
