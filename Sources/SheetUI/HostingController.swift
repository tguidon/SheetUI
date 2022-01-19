//
//  HostingController.swift
//  
//
//  Created by Taylor Guidon on 1/18/22.
//

import SwiftUI

/// Answer found at https://stackoverflow.com/a/69359296
/// When using a custom `UIPresentationController`, the `UIHostingController` will add spacing to the top
/// and bottom of the SwiftUI `Content`. This fix will resolve this issue and respect the constraints.
final class HostingController<Content: View>: UIHostingController<Content> {
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        view.setNeedsUpdateConstraints()
    }
}
