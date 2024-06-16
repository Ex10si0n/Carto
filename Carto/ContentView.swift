//
//  ContentView.swift
//  Carto
//
//  Created by Ex10si0n Yan on 6/8/24.
//

import SwiftUI
import SwiftData
import MapKit

struct ContentView: View {
    
    var body: some View {
        TabView {
            Group {
                CartoMapView()
                    .tabItem {
                        Label("Carto", systemImage: "globe.asia.australia.fill")
                    }
                CartoCollectionListView()
                    .tabItem {
                        Label("Collections", systemImage: "book.pages.fill")
                    }
                Text("Milestones shows here")
                    .tabItem {
                        Label("Milestones", systemImage: "party.popper.fill")
                    }
                Text("Featured")
                    .tabItem {
                        Label("Featured", systemImage: "doc.text.image")
                    }
            }
        }
    }
}

#Preview {
    ContentView().modelContainer(CartoCollection.preview)
}
