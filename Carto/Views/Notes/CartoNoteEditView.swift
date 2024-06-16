//
//  CartoNoteEditView.swift
//  Carto
//
//  Created by Ex10si0n Yan on 6/15/24.
//

import SwiftUI
import SwiftData

struct CartoNoteEditView: View {
    var editingNote: CartoNote
    
    var body: some View {
        Text("Editing \(editingNote.title)")
    }
}

#Preview {
    let container = CartoCollection.preview
    let fetchDescriptor = FetchDescriptor<CartoCollection>()
    let collection = try! container.mainContext.fetch(fetchDescriptor)[0]
    
    return NavigationStack {
        CartoNoteEditView(editingNote: collection.notes[0])
    }.modelContainer(CartoCollection.preview)

}
