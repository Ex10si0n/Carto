//
//  ContentView.swift
//  Carto
//
//  Created by Ex10si0n Yan on 6/8/24.
//

import SwiftUI
import SwiftData
import MapKit

enum Tab {
    case carto
    case collections
    case milestones
    case featured
}

struct ContentView: View {
    @State private var selectedTab: Tab = .carto

    var body: some View {
        TabView(selection: $selectedTab) {
            CartoMapView()
                .tabItem {
                    Label("Carto", systemImage: "globe.asia.australia.fill")
                }
                .tag(Tab.carto)
            
            CartoCollectionListView()
                .tabItem {
                    Label("Collections", systemImage: "book.pages.fill")
                }
                .tag(Tab.collections)
            
            Text("Milestones shows here")
                .tabItem {
                    Label("Milestones", systemImage: "party.popper.fill")
                }
                .tag(Tab.milestones)
            
            Text("Featured")
                .tabItem {
                    Label("Featured", systemImage: "doc.text.image")
                }
                .tag(Tab.featured)
        }
    }
}

#Preview {
    ContentView().modelContainer(CartoCollection.preview)
}
