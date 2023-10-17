//
//  CustomeImagePicker.swift
//
//
//  Created by mohamed ahmed on 16/10/2023.
//

import Foundation
import SwiftUI
import PhotosUI

struct CustomeImagePicker<Content: View>: View {
    
    var content: Content
    var options: [Crop]
    @Binding var show: Bool
    @Binding var croppedimage: UIImage?
    init(options: [Crop], show: Binding<Bool>, croppedimage: Binding<UIImage?>, @ViewBuilder content: @escaping ()-> Content) {
        self.content = content()
        self._show = show
        self._croppedimage = croppedimage
        self.options = options
    }
    
    //MARK: - View Properties
    @State private var photosItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    @State private var showDialog: Bool = false
    @State private var selectedCropType: Crop = .circle(200)
    @State private var showCropView: Bool = false
    
    var body: some View {
        content
            .photosPicker(isPresented: $show, selection: $photosItem)
            .onChange(of: photosItem) { newValue in
                if let newValue {
                    Task {
                        if let imageData = try? await newValue.loadTransferable(type: Data.self), let image = UIImage(data: imageData) {
                            // UI Must be updated on the Main thread
                            await MainActor.run {
                                selectedImage = image
                                showDialog.toggle()
                            }
                        }
                    }
                }
            }
            .confirmationDialog("", isPresented: $showDialog) {
                /// Dispplaying All The Options
                ForEach(options.indices, id: \.self) { index in
                    Button(options[index].name()) {
                        selectedCropType = options[index]
                        showCropView.toggle()
                    }
                }
            }
            .fullScreenCover(isPresented: $showCropView, onDismiss: {
                /// When Exited Clearing the old Selcted Image
                selectedImage = nil
            }, content: {
                CropView(crop: selectedCropType, image: selectedImage) { croppedImage, status in
                    if let croppedImage {
                        self.croppedimage = croppedImage
                    }
                }
            })
    }
}
