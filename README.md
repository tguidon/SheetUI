# SheetUI

![example workflow](https://github.com/tguidon/SheetUI/actions/workflows/swift-test.yml/badge.svg)

Easily present SwiftUI content in a bottom sheet fit for the content it's presenting. No more worrying about SwiftUI hierarchy. SheetUI provides a `ViewModifier` for presenting content that will always be presented above all SwiftUI views.

## Features
- iPhone and iPad support
- `isModalInPresentation` support
- Presents over tab bar, regardless of UIKit or SwiftUI tab layout
- Adapts to SwiftUI content size, with customizable top offset
- Swipe to dismiss
- Tap outter content to dismiss

## Installation

<p align="center">
  <img width="400" alt="iphone" src="https://user-images.githubusercontent.com/665323/150056793-07bb81ef-8725-49ca-b932-2f9cf43b6059.png">
  <img width="400" alt="ipad" src="https://user-images.githubusercontent.com/665323/150056805-a11972f9-1e19-4893-b5a9-30606db28ae4.png">
</p>

### Requirements

- iOS 14.0+

### Installation via Swift Package Manager 

In Xcode click on your project in the Project Navigator pane. Select your project and then click on the Package Depdendencies tab. Click on the plus button and add this via searching for "`git@github.com:tguidon/SheetUI.git`".

## Example

```swift
import SheetUI

/// `SheetItem` is defined as
/// public protocol SheetItem: Equatable, Identifiable { }

enum DisplayItem: Int, SheetItem {
    var id: Int { return self.rawValue }

    case menu
    case settings
}

struct ContentView: View {
    @State private var isPresented: Bool = false
    @State private var selectedItem: DisplayItem? = nil
    
    var body: some View {
        VStack {
            Text("Hello, world!")
                .padding()
            Button {
                self.isPresented = true
                // Can also set Equatable type, helpful with enums
                // self.selectedItem = DisplayItem.settings
            } label: {
                Text("Present")
            }
        }
        .presentSheet(
            isPresented: $isPresented
        ) {
            Text("Hello, sheet world!").padding()
        }
        .presentSheet(
            selectedItem: $selectedItem,
            style: .standard,
            onDismiss: nil
        ) { item in
            switch item {
            case .menu:
                Text("This is the menu!!!").padding()
            case .settings:
                Text("Settings!!!").padding()
            }
        }
    }
}
```
