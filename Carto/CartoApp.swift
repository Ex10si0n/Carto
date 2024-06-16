//
//  CartoApp.swift
//  Carto
//
//  Created by Ex10si0n Yan on 6/8/24.
//

import SwiftUI
import SwiftData

@main
struct CartoApp: App {

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: CartoCollection.self)
    }
}
