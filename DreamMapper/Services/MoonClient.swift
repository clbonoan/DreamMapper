//
//  MoonClient.swift
//  DreamMapper
//
//  Created by Edwin Aviles on 12/6/25.
//

import Foundation
import CoreLocation

struct TimeAndDateMoonResponse: Codable {
        struct Location: Codable {
                struct Astronomy: Codable {
                    struct Object: Codable {
                        struct Day: Codable {
                            let date: String?
                            let moonphase: String?
                        }
                        let name: String?
                        let days: [Day]?
                    }
                    let objects: [Object]?
                }
                let astronomy: Astronomy?
            }
            let locations: [Location]?
}
// API call for moon phase from farmsense
struct MoonClient {
    let accessKey: String = "8WhxSxPnAY"
    let secretKey: String = "a8pkJLgW57JLZQHVhw4P"

    func fetchMoonPhase(
        for date: Date,
        placeID: String = "norway/oslo"
    ) async throws -> String {

        // Format date as YYYY-MM-DD
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: date)

        var components = URLComponents(string: "https://api.xmltime.com/astronomy")!
        components.queryItems = [
            URLQueryItem(name: "version", value: "3"),
            URLQueryItem(name: "accesskey", value: accessKey),
            URLQueryItem(name: "secretkey", value: secretKey),
            URLQueryItem(name: "placeid", value: placeID),
            URLQueryItem(name: "object", value: "moon"),
            URLQueryItem(name: "types", value: "phase"),
            URLQueryItem(name: "startdt", value: dateString)
        ]

        guard let url = components.url else { throw URLError(.badURL) }

        let (data, response) = try await URLSession.shared.data(from: url)

        print("RAW MOON API RESPONSE:")
        print(String(data: data, encoding: .utf8) ?? "No UTF8")

        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        let decoded = try JSONDecoder().decode(TimeAndDateMoonResponse.self, from: data)

        // locations[0] -> astronomy.objects[name == "moon"].days[0].moonphase
        if let location   = decoded.locations?.first,
           let astronomy  = location.astronomy,
           let moonObject = astronomy.objects?.first(where: { ($0.name ?? "").lowercased() == "moon" }),
           let day        = moonObject.days?.first,
           let rawPhase   = day.moonphase {

            return normalizedPhaseName(rawPhase)
        }

        return "Unknown Phase"
    }

    private func normalizedPhaseName(_ raw: String) -> String {
        let lower = raw.lowercased()
        switch lower {
        case "newmoon":        return "New Moon"
        case "waxingcrescent": return "Waxing Crescent"
        case "firstquarter":   return "First Quarter"
        case "waxinggibbous":  return "Waxing Gibbous"
        case "fullmoon":       return "Full Moon"
        case "waninggibbous":  return "Waning Gibbous"
        case "lastquarter":    return "Last Quarter"
        case "waningcrescent": return "Waning Crescent"
        default:               return raw
        }
    }
}

extension MoonClient {
    func emoji(for phase: String) -> String {
        let p = phase.lowercased()

        switch true {
        case p.contains("new"):
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
            return "🌙" // fallback / unknown
        }
    }
}

