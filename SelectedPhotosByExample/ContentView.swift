//
//  ContentView.swift
//  SelectedPhotosByExample
//
//  Created by yukun on 2023/8/15.
//

import SwiftUI
import PhotosUI

struct ContentView: View {

    @State private var selectedPhotosItem = [PhotosPickerItem]()
    @State private var selectedImages = [Image]()
    
    var body: some View {
        NavigationStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .center, spacing: 16) {
                    ForEach(0..<selectedImages.count, id: \.self) { index in
                        VStack {
                            selectedImages[index]
                                .resizable()
                                .scaledToFit()
                                .frame(height: 200)
                            
                            Button {
                                removePhoto(at: index)
                            } label: {
                                Text("Remove")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                }
            }
            .toolbar {
                PhotosPicker(selection: $selectedPhotosItem,
                             maxSelectionCount: 5,
                             matching: .images) {
                    Image(systemName: "pencil")
                }
            }
            .onChange(of: selectedPhotosItem) { newValue in
                Task {
                    selectedImages.removeAll()
                
                    for item in selectedPhotosItem {
                        if let data = try? await item.loadTransferable(type: Data.self) {
                            if let uiImage = UIImage(data: data) {
                                let image = Image(uiImage: uiImage)
                                selectedImages.append(image)
                            }
                        }
                    }
                }
            }
        }
        
    }
    
    private func removePhoto(at index: Int) {
        selectedImages.indices.forEach { i in
            if i == index {
                selectedImages.remove(at: i)
                selectedPhotosItem.remove(at: i)
            }
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
