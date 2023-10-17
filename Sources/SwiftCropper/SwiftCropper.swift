// The Swift Programming Language
// https://docs.swift.org/swift-book
import SwiftUI

public extension View{
    @ViewBuilder
    func cropImagePicker(options: [Crop], show: Binding<Bool>, croppedImage: Binding<UIImage?>) -> some View {
        CustomeImagePicker(options: options, show: show, croppedimage: croppedImage) {
            self
        }
    }
}
