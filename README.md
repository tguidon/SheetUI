# SheetUI

Easily present SwiftUI content in a bottom sheet fit for the content it's presenting. No more worrying about SwiftUI hierarchy. SheetUI provides a `ViewModifier` for presenting content that will always be presented above all SwiftUI views.

## Installation

### Requirements

- iOS 14.0+

### Installation via Swift Package Manager 

In Xcode click on your project in the Project Navigator pane. Select your project and then click on the Package Depdendencies tab. Click on the plus button and add this via searching for "`git@github.com:tguidon/SheetUI.git`".

## Example

```swift
import SheetUI

struct ContentView: View {
    @State private var isPresented: Bool = false
    
    var body: some View {
        VStack {
            Text("Hello, world!")
                .padding()
            Button {
                self.isPresented = true
            } label: {
                Text("Open")
            }

        }
        .presentSheet(isPresented: $isPresented) {
            Text("Hello, other world!")
                .padding()
        }
    }
}
```
