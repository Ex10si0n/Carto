//
//  CartoNote.swift
//  Carto
//
//  Created by Ex10si0n Yan on 6/8/24.
//

import Foundation
import SwiftData
import MapKit

@Model
class CartoNote {
    
    var timestamp: Date
    var title: String
    var systemImage: String?
    var content: String
    var address: String
    
    var latitude: Double
    var longitude: Double
    
    var collection: CartoCollection?

    init(timestamp: Date, title: String, systemImage: String? = nil, content: String, address: String, latitude: Double, longitude: Double, collection: CartoCollection? = nil) {
        self.timestamp = timestamp
        self.title = title
        self.systemImage = systemImage
        self.content = content
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
        self.collection = collection
    }
    
    var coordinate: CLLocationCoordinate2D {
        .init(latitude: latitude, longitude: longitude)
    }
}
