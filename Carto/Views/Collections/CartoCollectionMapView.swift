//
//  CartoCollectionMapView.swift
//  Carto
//
//  Created by Ex10si0n Yan on 6/9/24.
//

import SwiftUI
import MapKit
import SwiftData

struct CartoCollectionMapView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.isSearching) private var isSearching: Bool
    
    @State private var cameraPosition: MapCameraPosition = .automatic
    @State private var visibleRegion: MKCoordinateRegion?
    @State private var searchText = ""
    @State private var searchFieldFocus = false
    @State private var selectedNote: CartoNote?
    @Query(filter: #Predicate<CartoNote> { $0.collection == nil}) private var searchPlaces: [CartoNote]
    
    private var listPlaces: [CartoNote] {
        searchPlaces + collection.notes
    }
    
    var collection: CartoCollection
    
    var body: some View {
        @Bindable var collection = collection
        Map(position: $cameraPosition, selection: $selectedNote){
            ForEach(listPlaces) { note in
                Group {
                    if note.collection != nil {
                        Marker(coordinate: note.coordinate) {
                            Label(note.title, systemImage: collection.category?.sfIcon ?? "flag.circle.fill")
                        }
                        .tint(Color.fromHex(collection.colorHex ?? Color.accentColor.toHex()))
                    } else {
                        Marker(coordinate: note.coordinate) {
                            Label(note.title, systemImage: "pencil.line")
                        }
                        .tint(.red)
                    }
                    
                }.tag(note)
            }
        }
        .sheet(item: $selectedNote) { selectedNote in  
            CartoNoteEditView(editingNote: selectedNote, collection: collection)
                .presentationDetents([.medium, .large])
        }
        .navigationTitle(collection.title)
        .searchable(text: $searchText, isPresented: $searchFieldFocus, prompt: "Seach a place to add new note")
        .onSubmit(of: .search) {
            Task {
                await CartoMapManager.searchPlaces(
                    modelContext,
                    searchText: searchText,
                    visibleRegion: visibleRegion
                )
            }
        }
        .onChange(of: searchText) { oldState, newState in
            if searchText.isEmpty && !isSearching {
                CartoMapManager.removeSearchResults(modelContext)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onMapCameraChange(frequency: .onEnd) { context in
            visibleRegion = context.region
            if let visibleRegion {
                collection.latitude = visibleRegion.center.latitude
                collection.longtitude = visibleRegion.center.longitude
                collection.latitudeDelta = visibleRegion.span.longitudeDelta
                collection.longtitudeDelta = visibleRegion.span.longitudeDelta
            }
        }
        .onAppear {
            if let region = collection.region {
                cameraPosition = .region(region)
            }
        }
        .onDisappear {
            CartoMapManager.removeSearchResults(modelContext)
        }
        .toolbar {
            Button {
                searchFieldFocus = true
            } label: {
                Image(systemName: "note.text.badge.plus")
                    .symbolRenderingMode(.hierarchical)
            }
        }
        
    }
    
}

#Preview {
    let container = CartoCollection.preview
    let fetchDescriptor = FetchDescriptor<CartoCollection>()
    let collection = try! container.mainContext.fetch(fetchDescriptor)[0]
    
    return NavigationStack {
        CartoCollectionMapView(collection: collection)
    }.modelContainer(CartoCollection.preview)
}
