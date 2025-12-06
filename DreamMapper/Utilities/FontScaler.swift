//
//  FontScaler.swift
//  DreamMapper
//
//  Created by Christine Bonoan on 12/6/25.
//  This is a helper to adjust the font sizes on screen.

import SwiftUI
import Combine

class FontScaler: ObservableObject {
    // typically +- 5 in the font size
    @Published var offset: CGFloat = 0
}

