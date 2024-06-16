//
//  CartoCollectionCustomizeView.swift
//  Carto
//
//  Created by Ex10si0n Yan on 6/15/24.
//

import SwiftUI
import SwiftData

struct CartoCollectionCustomizeView: View {
    var editingCollection: CartoCollection
    
    public let categories = [
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
    
    @State private var selectedColor = Color.accentColor
    
    
    var body: some View {
        @State var selectedCategory = editingCollection.category
        @Bindable var editingCollection = editingCollection
        
        Form {
            Section(header: Text("Color")) {
                VStack {
                    ColorPicker("Theme Color", selection: $selectedColor)
                        .onChange(of: selectedColor) { oldValue, newValue in
                            editingCollection.colorHex = newValue.toHex()
                        }
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            Section(header: Text("Category Icon")) {
                ForEach(categories, id: \.self) { category in
                    Button(action: {
                        editingCollection.category = category
                        selectedCategory = category
                    }) {
                        HStack {
                            Image(systemName: category.sfIcon)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                                .padding(.trailing, 8)
                                .symbolRenderingMode(.hierarchical)
                            Text(category.name)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Spacer()
                            if selectedCategory?.name == category.name {
                                Image(systemName: "checkmark")
                            }
                        }.foregroundColor(selectedColor)
                    }
                }
            }
        }
        .onAppear {
            selectedColor = Color.fromHex(editingCollection.colorHex ?? Color.accentColor.toHex())
        }
    }
}

#Preview {
    let container = CartoCollection.preview
    let fetchDescriptor = FetchDescriptor<CartoCollection>()
    let collection = try! container.mainContext.fetch(fetchDescriptor)[0]
    
    return NavigationStack {
        CartoCollectionCustomizeView(editingCollection: collection)
    }.modelContainer(CartoCollection.preview)
    
}
