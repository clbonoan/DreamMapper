//
//  DreamDetailController.swift
//  DreamMapper
//
//  Created by Christine Bonoan on 12/6/25.
//

import SwiftUI
import Combine

@MainActor
final class DreamDetailController: ObservableObject {
    @Published var fontOffset: CGFloat = 0
    
    let dream: Dream
    
    private let minOffset: CGFloat = -5
    private let maxOffset: CGFloat = 5
    
    init(dream: Dream) {
        self.dream = dream
    }
    
    // let user change font size when reading details
    func increaseFont() {
        fontOffset = min(fontOffset + 1, maxOffset)
    }
    
    func decreaseFont() {
        fontOffset = max(fontOffset - 1, minOffset)
    }
}

