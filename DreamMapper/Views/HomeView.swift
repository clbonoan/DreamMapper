//
//  HomeView.swift
//  DreamMapper
//
//  Created by Christine Bonoan on 11/14/25.
//  Home page with user input
//

import SwiftUI
import SwiftData

// to use hex codes for colors
extension Color {
    init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let r, g, b, a: Double
        switch hexSanitized.count {
        case 6: // RGB (no alpha)
            (r, g, b, a) = (
                Double((rgb >> 16) & 0xFF) / 255,
                Double((rgb >> 8) & 0xFF) / 255,
                Double(rgb & 0xFF) / 255,
                1.0
            )
        case 8: // RGBA
            (r, g, b, a) = (
                Double((rgb >> 24) & 0xFF) / 255,
                Double((rgb >> 16) & 0xFF) / 255,
                Double((rgb >> 8) & 0xFF) / 255,
                Double(rgb & 0xFF) / 255
            )
        default:
            (r, g, b, a) = (1, 1, 1, 1) // fallback white
        }

        self.init(.sRGB, red: r, green: g, blue: b, opacity: a)
    }
}

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "#F4F3EE") 
                    .ignoresSafeArea()
                VStack {
                    Text("INSERT NAME")
                        .font(.system(size: 55, weight: .bold, design: .rounded))
                        .foregroundColor(Color(hex: "#B6CFB6"))
                        .navigationBarBackButtonHidden(true)
                        .padding(.bottom, -60)
                }
            }
        }
        
    }
}

#Preview {
    HomeView()
        .modelContainer(for: Item.self, inMemory: true)
}


