//
//  CartoMap.swift
//  Carto
//
//  Created by Ex10si0n Yan on 6/8/24.
//

import SwiftUI
import MapKit
import SwiftData

struct CartoMapView: View {
    
    @State private var cameraPosition: MapCameraPosition = .automatic
    @Query private var collections: [CartoCollection]
    
    @StateObject private var locationManager = CartoLocationManager()
    
    var body: some View {
        Map(position: $cameraPosition){
            
            ForEach(collections) { collection in
                ForEach(collection.notes) { note in
                    Marker(coordinate: note.coordinate) {
                        Label(note.title, systemImage: note.collection?.category?.sfIcon ?? "")
                    }.tint(Color.fromHex(collection.colorHex ?? Color.accentColor.toHex()))
                }
            }
        }.onAppear {
            // get user location
            locationManager.checkLocationAuthorization()
            
            let coordinate = locationManager.lastKnownLocation
            let span = MKCoordinateSpan(latitudeDelta: 180, longitudeDelta: 180)
            let region = MKCoordinateRegion(center: coordinate!, span: span)
            cameraPosition = .region(region)
            
        }.mapStyle(.hybrid(elevation: .realistic))
    }
    
}

#Preview {
    CartoMapView()
        .modelContainer(CartoCollection.preview)
}
