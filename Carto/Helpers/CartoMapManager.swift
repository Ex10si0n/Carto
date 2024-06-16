//
//  CartoMapManager.swift
//  Carto
//
//  Created by Ex10si0n Yan on 6/14/24.
//

import MapKit
import SwiftData

enum CartoMapManager {
    @MainActor
    static func searchPlaces(_ modelContext: ModelContext, searchText: String, visibleRegion: MKCoordinateRegion?) async {
        removeSearchResults(modelContext)
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        if let visibleRegion {
            request.region = visibleRegion
        }
        let searchItems = try? await MKLocalSearch(request: request).start()
        let results = searchItems?.mapItems ?? []
        results.forEach {
            let notes = CartoNote(
                timestamp: Date(),
                title: $0.placemark.name ?? "",
                content: "",
                address: $0.placemark.title ?? "",
                latitude: $0.placemark.coordinate.latitude,
                longitude: $0.placemark.coordinate.longitude
            )
            modelContext.insert(notes)
        }
    }
    
    static func removeSearchResults(_ modelContext: ModelContext) {
        let searchPredicate = #Predicate<CartoNote> { $0.collection == nil }
        try? modelContext.delete(model: CartoNote.self, where: searchPredicate)
    }
}
