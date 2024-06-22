//
//  CartoNoteEditView.swift
//  Carto
//
//  Created by Ex10si0n Yan on 6/15/24.
//

import SwiftUI
import SwiftData
import MapKit

struct CartoNoteEditView: View {
    @Environment(\.dismiss) private var dismiss
    
    var editingNote: CartoNote
    var collection: CartoCollection
    
    @State private var lookaroundScene: MKLookAroundScene?
    @State private var editingNoteLocal: CartoNote
    
    init(editingNote: CartoNote, collection: CartoCollection) {
        self.editingNote = editingNote
        self.collection = collection
        _editingNoteLocal = State(initialValue: editingNote)
    }
    
    var body: some View {
        
        @Bindable var editingNoteLocal = editingNote
        HStack {
            ScrollView {
                VStack(alignment: .leading) {
                    TextField("Title", text: $editingNoteLocal.title, axis: .vertical)
                        .font(.title.bold())
                        .submitLabel(.next)
                    TextField("Address", text: $editingNoteLocal.address, axis: .vertical)
                        .font(.subheadline)
                        .foregroundColor(Color.fromHex(editingNoteLocal.collection?.colorHex ?? Color.accentColor.toHex()))
                    
                    if editingNoteLocal.collection == nil {
                    HStack {
                        Spacer()
                        Button {
                                editingNoteLocal.collection = collection
                                collection.notes.append(editingNoteLocal)
                                dismiss()
                            } label: {
                                Label("Add to \(collection.title)", systemImage: collection.category?.sfIcon ?? "flag.circle.fill").padding()
                            }
                            .background(Color.fromHex(editingNoteLocal.collection?.colorHex ?? Color.accentColor.toHex()))
                            .foregroundStyle(Color.white)
                        .clipShape(Capsule())
                        Spacer()
                    }
                        
                    } else {
                        TextEditor(text: $editingNoteLocal.content)
                            .frame(height: 300)
                    }
                }
//                if let lookaroundScene {
//                    LookAroundPreview(initialScene: lookaroundScene)
//                }
            }
            
            .padding(10)
//            .task(id: editingNoteLocal) {
//                await fetchLookaroundPreview()
//            }
        }
    }
    
//    func fetchLookaroundPreview() async {
//        lookaroundScene = nil
//        let lookaroundRequest = MKLookAroundSceneRequest(coordinate: editingNoteLocal.coordinate)
//        lookaroundScene = try? await lookaroundRequest.scene
//    }
}

#Preview {
    let container = CartoCollection.preview
    let fetchDescriptor = FetchDescriptor<CartoCollection>()
    let collection = try! container.mainContext.fetch(fetchDescriptor)[0]
    
    return NavigationStack {
        CartoNoteEditView(editingNote: collection.notes[0], collection: collection)
    }.modelContainer(CartoCollection.preview)
    
}
