//
//  MyCollection.swift
//  Carto
//
//  Created by Ex10si0n Yan on 6/8/24.
//

import SwiftUI
import SwiftData

struct CartoCollectionListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \CartoCollection.title) private var collections: [CartoCollection]
    @State private var newCollection = false
    @State private var collectionTitle = ""
    @State private var path = NavigationPath()
    @State private var showingDeletion = false
    var body: some View {
        NavigationStack(path: $path) {
            Group {
                if !collections.isEmpty {
                    List(collections) { collection in
                        NavigationLink(value: collection) {
                            HStack {
                                Image(systemName: collection.category?.sfIcon ?? "flag.circle.fill")
                                    .imageScale(.large)
                                    .symbolRenderingMode(.hierarchical)
                                    .foregroundColor(Color.fromHex(collection.colorHex ?? Color.accentColor.toHex()))
                                VStack(alignment: .leading) {
                                    Text(collection.title)
                                    Text("^[\(collection.notes.count) Note](inflect: true)")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .swipeActions(edge: .trailing) {
                                Button() {
                                    showingDeletion = true
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }.tint(.red)
                                NavigationLink(destination: CartoCollectionEditView(editingCollection: collection)) {
                                    Button() { } label: {
                                        Label("Edit", systemImage: "pencil")
                                    }.tint(.blue)
                                }
                            }.confirmationDialog(Text("About to delete \(collection.title) including ^[\(collection.notes.count) Note](inflect: true)"), isPresented: $showingDeletion, titleVisibility: .visible) {
                                Button("Delete", role: .destructive) {
                                    modelContext.delete(collection)
                                }
                                Button("Cancel", role: .cancel) {}
                            }
                        }
                    }
                    .navigationDestination(for: CartoCollection.self) { collection in
                        CartoCollectionMapView(collection: collection)
                    }
                } else {
                    ContentUnavailableView("Empty Collection", systemImage: "globe.asia.australia.fill", description: Text("To add your first collection, tap on the \(Image(systemName: "rectangle.stack.badge.plus")) button in the toolbar to begin."))
                }
            }
            .navigationTitle("Collections")
            .toolbar {
                Button {
                    newCollection.toggle()
                } label: {
                    Image(systemName: "rectangle.stack.badge.plus")
                }
                .alert("Enter Collection Name", isPresented: $newCollection) {
                    TextField("Enter collection name", text: $collectionTitle)
                        .autocorrectionDisabled()
                    Button("OK") {
                        if !collectionTitle.isEmpty {
                            let collection = CartoCollection(title: collectionTitle.trimmingCharacters(in: .whitespacesAndNewlines))
                            modelContext.insert(collection)
                            collectionTitle = ""
                            path.append(collection)
                        }
                    }
                    Button("Cancel", role: .cancel) {}
                } message: {
                    Text("Create a new collection")
                }
            }
        }
        
    }
}

#Preview {
    CartoCollectionListView()
        .modelContainer(CartoCollection.preview)
}
