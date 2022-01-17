//
//  File.swift
//  
//
//  Created by Taylor Guidon on 1/17/22.
//

import Foundation
import SwiftUI
import UIKit

struct SheetViewModifier<ContentView: View>: ViewModifier {
    @Binding private var isPresented: Bool
    private let contentView: ContentView
    
    @State private var sheetViewController: SheetViewController<ContentView>?
    
    init(
        isPresented: Binding<Bool>,
        @ViewBuilder contentView: () -> ContentView
    ) {
        self._isPresented = isPresented
        self.contentView = contentView()
    }
    
    func body(content: Content) -> some View {
        content
            .onChange(of: isPresented, perform: updatePresentation(_:))
    }
    
    /// Update the presentation state of the `sheetViewController`
    /// - Parameter isPresented: Presents the `sheetViewController` when set to `true`
    private func updatePresentation(_ isPresented: Bool) {
        guard let rootViewController = UIApplication.shared.getRootViewController() else {
            self.isPresented = false
            return
        }
        
        let presentingController = rootViewController.presentedViewController ?? rootViewController
        
        if isPresented {
            sheetViewController = SheetViewController(
                isPresented: $isPresented,
                content: self.contentView
            )
            if let sheetViewController = self.sheetViewController {
                presentingController.present(sheetViewController, animated: true, completion: nil)
            }
        } else {
            sheetViewController?.dismiss(animated: true, completion: nil)
            sheetViewController = nil
        }
    }
}

extension View {
    func presentBottomSheet<SheetContent: View>(
        isPresented: Binding<Bool>,
        @ViewBuilder sheetContent: () -> SheetContent
    ) -> some View {
        self.modifier(
            SheetViewModifier(
                isPresented: isPresented,
                contentView: sheetContent
            )
        )
    }
}
