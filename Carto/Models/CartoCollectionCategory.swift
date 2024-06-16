//
//  CartoCollectionCategory.swift
//  Carto
//
//  Created by Ex10si0n Yan on 6/15/24.
//

import Foundation
import SwiftData
import SwiftUI

@Model
final class CartoCollectionCategory {
    var sfIcon: String
    var name: String
    
    @Relationship(
        deleteRule: .cascade
    )
    
    init(sfIcon: String, name: String) {
        self.sfIcon = sfIcon
        self.name = name
    }
}
