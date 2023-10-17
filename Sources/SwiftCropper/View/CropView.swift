//
//  CropView.swift
//  
//
//  Created by mohamed ahmed on 16/10/2023.
//

import Foundation
import SwiftUI
struct CropView: View {
    var crop: Crop
    var image: UIImage?
    var onCrop: (UIImage?, Bool) -> ()
    
    /// - View Properties
    @Environment(\.dismiss) private var dismiss
    /// - Geasture Properties
    @State private var scale: CGFloat = 1
    @State private var lastScale: CGFloat = 0
    @State private var offset: CGSize = .zero
    @State private var lastStoredOffset: CGSize = .zero
    @GestureState private var isInteracting: Bool = false
    
    var body: some View {
        NavigationStack {
            ImageView()
                .navigationTitle("Crop View")
                .navigationBarTitleDisplayMode(.inline)
                .toolbarBackground(.visible, for: .navigationBar)
                .toolbarBackground(Color.black, for: .navigationBar)
                .toolbarColorScheme(.dark, for: .navigationBar)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background {
                    Color.black
                        .ignoresSafeArea()
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            //MARK: - Generating Cropped Image
                            /// - Converting View to Image (Native iOS 16+)
                            let renderer = ImageRenderer(content: ImageView(true))
                            renderer.proposedSize = .init(crop.size())
                            if let image = renderer.uiImage {
                                onCrop(image, true)
                            } else {
                                onCrop(nil, false)
                            }
                            dismiss()
                        } label: {
                            Image(systemName: "checkmark")
                                .font(.callout)
                                .fontWeight(.semibold)
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark")
                                .font(.callout)
                                .fontWeight(.semibold)
                        }

                    }
                }
        }
    }
    
    /// - Image View
    @ViewBuilder
    func ImageView(_ hideGrids: Bool = false) -> some View {
        let cropSize = crop.size()
        GeometryReader {
            let size = $0.size
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .overlay(content: {
                        GeometryReader { proxy in
                            let rect = proxy.frame(in: .named("CROPVIEW"))
                            Color.clear
                                .onChange(of: isInteracting) { newValue in
                                    /// - true Dragging
                                    /// - false Stopped Dragging
                                    /// with the Help of GeometryReader
                                    /// we can now read the minX,Y and maxX,Y of the Image
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        if rect.minX > 0 {
                                            /// - Resetting to the last location
                                            offset.width = (offset.width - rect.minX)
                                            haptics(.medium)
                                        }
                                        if rect.minY > 0 {
                                            /// - Resetting to the last location
                                            offset.height = (offset.height - rect.minY)
                                            haptics(.medium)
                                        }
                                        
                                        /// - Doing the Same for maxX,Y
                                        if rect.maxX < size.width {
                                            /// - Resetting to the last location
                                            offset.width = (rect.minX - offset.width)
                                            haptics(.medium)
                                        }
                                        if rect.maxY < size.height {
                                            /// - Resetting to the last location
                                            offset.height = (rect.minY - offset.height)
                                        }
                                    }
                                    if !newValue {
                                        /// - Store Last Offset
                                        lastStoredOffset = offset
                                    }
                                }
                        }
                    })
                    .frame(size)
            }
        }
        .scaleEffect(scale)
        .offset(offset)
        .overlay(content: {
            /// we don't need grid view for cropped
            if !hideGrids {
                Grids()
            }
        })
        .coordinateSpace(name:"CROPVIEW")
        .gesture(
            DragGesture()
                .updating($isInteracting) { _, out, _ in
                    out = true
                }.onChanged { value in
                    let translation = value.translation
                    offset = CGSize(width: translation.width + lastStoredOffset.width,
                                    height: translation.height + lastStoredOffset.height)
                }
        )
        .gesture(
            MagnificationGesture()
                .updating($isInteracting) { _, out, _ in
                    out = true
                }.onChanged { value in
                    let updatedScale = value + lastScale
                    scale = (updatedScale < 1 ? 1 : updatedScale)
                }.onEnded({ value in
                    withAnimation(.easeInOut(duration: 0.2)) {
                        if scale < 1 {
                            scale = 1
                            lastScale = 0
                        } else {
                            lastScale = scale - 1
                        }
                    }
                })
        )
        .frame(cropSize)
        .cornerRadius(isCropShapeCircle() ? cropSize.height / 2 : 0)
    }
    
    private func isCropShapeCircle() -> Bool {
        switch crop {
        case .circle:
            return true
        default:
            return false
        }
    }
    
    /// Grids
    @ViewBuilder
    func Grids() -> some View {
        ZStack {
            HStack {
                ForEach(1...5, id: \.self) { _ in
                    Rectangle()
                        .fill(.white.opacity(0.7))
                        .frame(width: 1)
                        .frame(maxWidth: .infinity)
                }
            }
            
            VStack {
                ForEach(1...8, id: \.self) { _ in
                    Rectangle()
                        .fill(.white.opacity(0.7))
                        .frame(height: 1)
                        .frame(maxHeight: .infinity)
                }
            }
        }
    }
}

private extension View {
    /// for making it simple and easy to use
    @ViewBuilder
    func frame(_ size: CGSize) -> some View {
        self
            .frame(width: size.width, height: size.height)
    }
    
    /// - Haptic Feedback
    func haptics(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        UIImpactFeedbackGenerator(style: style).impactOccurred()
    }
}
