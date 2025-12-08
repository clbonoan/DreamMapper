//
//  MoonClient.swift
//  DreamMapper
//
//  Created by Edwin Aviles on 12/6/25.
//  This is for mapping moon phase text from Moon API to the correct moon phase emoji.

import Foundation
import CoreLocation

struct MoonClient {
    // phase text comes from moon api
    func emoji(for phase: String) -> String {
        // normalize string to lowercase for matching
        let p = phase.lowercased()
        
        switch true {
        case p.contains("new"):
            // new moon
            return "🌑"
        case p.contains("waxing crescent"):
            return "🌒"
        case p.contains("first quarter"):
            return "🌓"
        case p.contains("waxing gibbous"):
            return "🌔"
        case p.contains("full"):
            return "🌕"
        case p.contains("waning gibbous"):
            return "🌖"
        case p.contains("last quarter"):
            return "🌗"
        case p.contains("waning crescent"):
            return "🌘"
        default:
            // fallback to this if unknown
            return "🌙"
        }
    }
}

