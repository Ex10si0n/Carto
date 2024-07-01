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
    
    @State private var height: CGFloat = 40
    
    @State private var editingNoteLocal: CartoNote
    
    init(editingNote: CartoNote, collection: CartoCollection) {
        self.editingNote = editingNote
        self.collection = collection
        _editingNoteLocal = State(initialValue: editingNote)
    }
    
    var body: some View {
        
        @Bindable var editingNoteLocal = editingNote
        HStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    TextField("Title", text: $editingNoteLocal.title, axis: .vertical)
                        .font(.title.bold())
                        .submitLabel(.next)
                        .padding(.top)
                        .padding(.horizontal, 5)
                    TextField("Address", text: $editingNoteLocal.address, axis: .vertical)
                        .font(.subheadline)
                        .foregroundColor(Color.fromHex(editingNoteLocal.collection?.colorHex ?? Color.accentColor.toHex()))
                        .padding(.horizontal, 5)
                    
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
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                Spacer()
                                
                                DatePicker(selection: $editingNoteLocal.timestamp, in: ...Date.now, displayedComponents: .date) {
                                    
                                }
                                
                                Button("Open in Map", systemImage: "map") {
                                    let placemark = MKPlacemark(coordinate: editingNote.coordinate)
                                    let mapItem = MKMapItem(placemark: placemark)
                                    mapItem.name = editingNote.title
                                    mapItem.openInMaps()
                                }.tint(Color.fromHex(editingNoteLocal.collection?.colorHex ?? Color.accentColor.toHex()))
                                
                                
                                Button(action: {
                                    // TODO: Share
                                }) {
                                    Label("Share", systemImage: "square.and.arrow.up")
                                        .font(.system(size: 16)) // Adjust the size as needed
                                }
                                .tint(Color.accentColor)
                                
                                Button("Delete", systemImage: "trash") {
                                    // TODO: Deletion
                                    
                                }.tint(Color.red)
                                
                                Spacer()
                                
                            }.buttonStyle(.bordered)
                        }
                        .overlay(
                            HStack {
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color(UIColor.systemBackground),
                                        Color(UIColor.systemBackground).opacity(0)
                                    ]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                                .frame(width: 20)
                                
                                Spacer()
                                
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color(UIColor.systemBackground).opacity(0),
                                        Color(UIColor.systemBackground)
                                    ]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                                .frame(width: 20)
                            }
                        )
                    }
                    
                    TextEditor(text: $editingNoteLocal.content)
                        .frame(height: 300)
                        .padding(.horizontal, 5)

             
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
