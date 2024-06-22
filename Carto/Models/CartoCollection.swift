//
//  Item.swift
//  Carto
//
//  Created by Ex10si0n Yan on 6/8/24.
//

import Foundation
import SwiftData
import MapKit
import SwiftUI

extension Color {
    func toHex() -> String {
        guard let components = UIColor(self).cgColor.components else {
            return ""
        }

        let red = CGFloat(components[0])
        let green = CGFloat(components[1])
        let blue = CGFloat(components[2])

        return String(format: "#%02X%02X%02X", Int(red * 255), Int(green * 255), Int(blue * 255))
    }
    
    static func fromHex(_ hex: String) -> Color {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0

        return Color(UIColor(red: red, green: green, blue: blue, alpha: 1.0))
    }
}

@Model
final class CartoCollection {
    
    var title: String
    
    var latitude: Double?
    var longtitude: Double?
    var latitudeDelta: Double?
    var longtitudeDelta: Double?
    
    var systemImage: String?
    var category: CartoCollectionCategory?
    var colorHex: String?

    
    @Relationship(
        deleteRule: .cascade
    )
    
    var notes: [CartoNote] = []
    
    
    init(
        title: String,
        latitude: Double? = nil,
        longtitude: Double? = nil,
        latitudeDelta: Double? = nil,
        longtitudeDelta: Double? = nil,
        category: CartoCollectionCategory? = nil,
        colorHex: String? = nil
    ) {
        self.title = title
        self.latitude = latitude
        self.longtitude = longtitude
        self.latitudeDelta = latitudeDelta
        self.longtitudeDelta = longtitudeDelta
        self.category = category
        self.colorHex = colorHex
    }
    
    var region: MKCoordinateRegion? {
        if let latitude, let longtitude, let latitudeDelta, let longtitudeDelta {
            return MKCoordinateRegion(
                center: CLLocationCoordinate2D(
                    latitude: latitude,
                    longitude: longtitude
                ),
                span: MKCoordinateSpan(
                    latitudeDelta: latitudeDelta,
                    longitudeDelta: longtitudeDelta
                )
            )
        } else {
            return nil
        }
    }
}

extension CartoCollection {
    
    @MainActor
    static var preview: ModelContainer {
        let container = try! ModelContainer(
            for: CartoCollection.self,
            configurations: ModelConfiguration(
                isStoredInMemoryOnly: true
            )
        )
        let categories = [
            CartoCollectionCategory(sfIcon: "map.circle.fill", name: "Travelling"),
            CartoCollectionCategory(sfIcon: "figure.walk.circle.fill", name: "Outdoor Sports"),
            CartoCollectionCategory(sfIcon: "camera.circle.fill", name: "Photography"),
            CartoCollectionCategory(sfIcon: "tent.circle.fill", name: "Camping"),
            CartoCollectionCategory(sfIcon: "sailboat.circle.fill", name: "Sailing"),
            CartoCollectionCategory(sfIcon: "bird.circle.fill", name: "Birds"),
            CartoCollectionCategory(sfIcon: "leaf.circle.fill", name: "Natural"),
            CartoCollectionCategory(sfIcon: "binoculars.circle.fill", name: "Observation"),
            CartoCollectionCategory(sfIcon: "graduationcap.circle.fill", name: "Education"),
            CartoCollectionCategory(sfIcon: "house.circle.fill", name: "Properties"),
        ]
        let universities = CartoCollection(
            title: "Universities",
            latitude: 40.4406,
            longtitude: -79.9959,
            latitudeDelta: 0.2,
            longtitudeDelta: 0.2,
            category: categories[8],
            colorHex: Color.accentColor.toHex()
        )
        
        container.mainContext.insert(universities)
        var notes: [CartoNote] {
            [
                CartoNote(timestamp: Date(), title: "Columbia University", content: "Columbia University is for testing lookaround view", address: "116th and Broadway, New York, NY 10027, United States", latitude: 40.808040, longitude: -73.961966),
                CartoNote(timestamp: Date(), title: "Carnegie Mellon University", content: "Carnegie Mellon University is a private research university in Pittsburgh, Pennsylvania. The institution was established in 1900 by Andrew Carnegie as the Carnegie Technical Schools. In 1912, it became the Carnegie Institute of Technology and began granting four-year degrees.", address: "5000 Forbes Ave, Pittsburgh, PA 15213", latitude: 40.445037, longitude: -79.945224)
            ]
        }
        notes.forEach {note in
            universities.notes.append(note)
            note.collection = universities
        }
        return container
    }
}
