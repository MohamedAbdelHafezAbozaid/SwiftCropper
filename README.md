# SwiftCropper

FavOnboardingKit provides an onboarding flow that is simple and easy to implement.


## Contents

- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)
- [Credits](#credits)

## Requirements

- iOS 16.0 or later
- Xcode 14.3 or later
- Swift 5.0 or later


## Installation
There are two ways to use FavOnboardingKit in your project:
- using Swift Package Manager
- manual install (build frameworks or embed Xcode Project)

### Swift Package Manager

To integrate FavOnboardingKit into your Xcode project using Swift Package Manager, add it to the dependencies value of your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/MohamedAbdelHafezAbozaid/SwiftCropper.git", .upToNextMajor(from: "1.0.0"))
]
```
[Swift Package Manager](https://swift.org/package-manager/) is a tool for managing the distribution of Swift code. It’s integrated with the Swift build system to automate the process of downloading, compiling, and linking dependencies.

### Manually

If you prefer not to use Swift Package Manager, you can integrate FavOnboardingKit into your project manually.

---

## Usage

### Quick Start

```swift
import SwiftUI

struct Home: View {
    
    //MARK: - View Properties
    @State private var showPicker: Bool = false
    @State private var croppedImage: UIImage?
    var body: some View {
        NavigationStack {
            VStack {
                if let croppedImage {
                    Image(uiImage: croppedImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } else {
                    Text("No Image is Selected")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 300, height: 400)
                }
            }
            .navigationTitle("Crop Image Picker")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showPicker.toggle()
                    }, label: {
                        Image(systemName: "photo.on.rectangle.angled")
                            .font(.callout)
                    })
                    .tint(.black)
                }
            }
            .cropImagePicker(options: [.circle, .square, .rectangle, .custom(.init(width: 200, height: 200))], show: $showPicker, croppedImage: $croppedImage)
        }
    }
}
```

## Credits

- Mohamed Ahmed (Abozaid)
