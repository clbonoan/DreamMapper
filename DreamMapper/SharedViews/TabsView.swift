//
//  TabsView.swift
//  DreamMapper
//
//  Created by Christine Bonoan on 11/14/25.
//  Contains all the options for the tab bar.

import SwiftUI

struct TabsView: View {
    
    var body: some View {
        TabView {
            NavigationStack { HomeView() }
                .tabItem { Label("Home", systemImage: "cloud.fill") }
                
            NavigationStack { DreamMapView() }
                .tabItem { Label("Map", systemImage: "map.fill") }
            
            NavigationStack { DreamListView() }
                .tabItem { Label("List", systemImage: "text.document.fill") }
            
            NavigationStack { SettingsView() }
                .tabItem { Label("Settings", systemImage: "gearshape.fill") }
        }
        .tint(Color(hex: "#C5C6C8"))
        .navigationBarBackButtonHidden(true)
        
    }
}

#Preview {
    TabsView()
}


