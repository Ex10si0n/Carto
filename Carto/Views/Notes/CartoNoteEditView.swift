//
//  CartoNoteEditView.swift
//  Carto
//
//  Created by Ex10si0n Yan on 6/15/24.
//

import SwiftUI
import SwiftData

struct CartoNoteEditView: View {
    @Environment(\.dismiss) private var dismiss
    
    var editingNote: CartoNote
    var collection: CartoCollection
    
    
    var body: some View {
        
        @Bindable var editingNote = editingNote
        HStack {
            ScrollView {
                VStack(alignment: .leading) {
                    TextField("Title", text: $editingNote.title, axis: .vertical)
                        .font(.title.bold())
                        .submitLabel(.next)
                    TextField("Address", text: $editingNote.address, axis: .vertical)
                        .font(.subheadline)
                        .foregroundColor(Color.fromHex(editingNote.collection?.colorHex ?? Color.accentColor.toHex()))
                    if editingNote.collection == nil {
                        Button {
                            editingNote.collection = collection
                            collection.notes.append(editingNote)
                            dismiss()
                        } label: {
                            Label("Add to Collection", systemImage: "folder")
                        }
                    } else {
                        TextEditor(text: $editingNote.content)
                            .frame(height: 300)
                        
                    }
                }
            }
            .padding(10)
        }
    }
}

#Preview {
    let container = CartoCollection.preview
    let fetchDescriptor = FetchDescriptor<CartoCollection>()
    let collection = try! container.mainContext.fetch(fetchDescriptor)[0]
    
    return NavigationStack {
        CartoNoteEditView(editingNote: collection.notes[0], collection: collection)
    }.modelContainer(CartoCollection.preview)
    
}
