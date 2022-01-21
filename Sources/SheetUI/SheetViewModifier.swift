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
    private let style: SheetViewStyle
    private let onDismiss: (() -> Void)?
    private let contentView: ContentView
    
    @State private var sheetViewController: SheetViewController<ContentView>?
    
    init(
        isPresented: Binding<Bool>,
        style: SheetViewStyle,
        onDismiss: (() -> Void)?,
        @ViewBuilder contentView: () -> ContentView
    ) {
        self._isPresented = isPresented
        self.style = style
        self.onDismiss = onDismiss
        self.contentView = contentView()
    }
    
    func body(content: Content) -> some View {
        if UIDevice.current.userInterfaceIdiom == .phone {
            content
                .onChange(of: isPresented, perform: updatePresentation(_:))
        } else {
            content
                .sheet(isPresented: $isPresented, onDismiss: self.onDismiss) {
                    self.contentView
                }
        }
    }
    
    /// Update the presentation state of the `sheetViewController`
    /// - Parameter isPresented: Presents the `sheetViewController` when set to `true`
    private func updatePresentation(_ isPresented: Bool) {
        guard let presentingViewController = UIApplication.shared.presentingViewController else {
            self.isPresented = false
            return
        }
        
        if isPresented {
            sheetViewController = SheetViewController(
                isPresented: self.$isPresented,
                style: self.style,
                content: self.contentView
            )
            if let sheetViewController = self.sheetViewController {
                presentingViewController.present(sheetViewController, animated: true)
            }
        } else {
            sheetViewController?.dismiss(animated: true, completion: self.onDismiss)
            sheetViewController = nil
        }
    }
}

public extension View {
    func presentSheet<ContentView: View>(
        isPresented: Binding<Bool>,
        style: SheetViewStyle = .standard,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder contentView: () -> ContentView
    ) -> some View {
        self.modifier(
            SheetViewModifier(
                isPresented: isPresented,
                style: style,
                onDismiss: onDismiss,
                contentView: contentView
            )
        )
    }
}
