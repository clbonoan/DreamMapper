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
    @Query private var items: [Dream]
    
    @State private var xOffset: CGFloat = 0
    
    // console log to see if google fonts were correctly added
    init() {
        for family in UIFont.familyNames {
            print(family)
            for name in UIFont.fontNames(forFamilyName: family) {
                print("  \(name)")
            }
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "#F4F3EE") 
                    .ignoresSafeArea()
                VStack {
                    Image("dream-home")
                        // rotate line image to the left to make it leveled
                        .rotationEffect(.degrees(-18))
                        .offset(x: -60)
                        // decrease space between image and title
                        .padding(.bottom, 0)
                        // decrease padding at top of image
                        .padding(.top, -50)
                    Text("Astral")
                        .font(.custom("MouseMemoirs-Regular", size: 110))
                        .foregroundColor(Color(hex: "#B6CFB6"))
                        // add space in between letters
                        .tracking(3)
                        .padding(.top, -50)
                        .navigationBarBackButtonHidden(true)
                    Text("Your Spirit Travel Journies")
                        .font(.custom("AlegreyaSans-Medium", size: 26))
                        .foregroundColor(Color(hex: "#484848"))
                        .padding(.bottom, 30)
                    
                    // after clicking get started, show nav bar
                    NavigationLink(destination: TabsView()) {
                        Text("Ready")
                            .font(.custom("AlegreyaSans-Medium", size: 22))
                            .padding(.vertical, 14)
                            .padding(.horizontal, 20)
                            .background(Color(hex: "#B6CFB6"))
                            .foregroundColor(Color(hex: "#484848"))
                            .cornerRadius(10)
                        
                    }
                        
                }
            }
        }
        
    }
}

#Preview {
    HomeView()
        .modelContainer(for: Dream.self, inMemory: true)
}


