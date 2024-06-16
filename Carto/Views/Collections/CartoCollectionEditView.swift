//
//  CartoCollectionEditView.swift
//  Carto
//
//  Created by Ex10si0n Yan on 6/14/24.
//

import SwiftUI
import SwiftData
import MapKit

struct CartoCollectionEditView: View {
    
    var editingCollection: CartoCollection
    @State private var newTitle = ""
    @State private var isShowingAlert = false
    
    var body: some View {
        @Bindable var editingCollection = editingCollection
        VStack {
            Form {
                Section(header: Text("Collection Title")) {
                    TextField(editingCollection.title, text: $editingCollection.title)
                }
                Section(header: Text("Customize")) {
                    NavigationLink (destination: CartoCollectionCustomizeView(editingCollection: editingCollection)) {
                        HStack {
                            Image(systemName: editingCollection.category?.sfIcon ?? "flag.circle.fill")
                                .symbolRenderingMode(.hierarchical)
                            Text(editingCollection.category?.name ?? "Default")
                        }.foregroundColor(Color.fromHex(editingCollection.colorHex ?? Color.accentColor.toHex()))
                    }
                }
                
                
                Section(header: Text("Notes")) {
                    ForEach(editingCollection.notes) { note in
                        Text(note.title)
                            .swipeActions {
                                Button() {
                                    // TODO: implement deletion
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }.tint(.red)
                            }
                    }
                }
            }.onAppear {
                newTitle = editingCollection.title
            }
        }
        .alert("Save Failed", isPresented: $isShowingAlert) {} message: {
            Text("Please enter a title for the collection")
        }
//        .navigationTitle(editingCollection.title)
        .navigationBarTitleDisplayMode(.inline)
//        .toolbar {
//            Button {
//                if newTitle.isEmpty {
//                    isShowingAlert = true
//                } else {
//                    editingCollection.title = newTitle
//                }
//            } label: {
//                Text("Save")
//            }
//        }
    }
}

#Preview {
    let container = CartoCollection.preview
    let fetchDescriptor = FetchDescriptor<CartoCollection>()
    let collection = try! container.mainContext.fetch(fetchDescriptor)[0]
    
    return NavigationStack {
        CartoCollectionEditView(editingCollection: collection)
    }.modelContainer(CartoCollection.preview)
}
