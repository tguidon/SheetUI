//
//  File.swift
//  
//
//  Created by Taylor Guidon on 1/17/22.
//

import Foundation
import SwiftUI
import UIKit

public struct ItemSheetViewModifier<ContentView: View, Item: Equatable>: ViewModifier {
    @Binding private var selectedItem: Item?
    private let style: SheetViewStyle
    private let onDismiss: (() -> Void)?
    @ViewBuilder private let contentView: (Item) -> ContentView

    @State private var sheetViewController: SheetViewController<ContentView>?

    public init (
        selectedItem: Binding<Item?>,
        style: SheetViewStyle,
        onDismiss: (() -> Void)?,
        @ViewBuilder contentView: @escaping (Item) -> ContentView
    ) {
        self._selectedItem = selectedItem
        self.style = style
        self.onDismiss = onDismiss
        self.contentView = contentView
    }
    
    public func body(content: Content) -> some View {
        ZStack {
            content
                .onChange(of: selectedItem, perform: updatePresentation)
        }
    }
    
    /// Update the presentation state of the `sheetViewController`
    /// - Parameter isPresented: Presents the `sheetViewController` when set to `true`
    private func updatePresentation(_ item: Item?) {
        guard let presentingViewController = UIApplication.shared.presentingViewController else {
            self.selectedItem = nil
            return
        }
        
        if let item = item {
            sheetViewController = SheetViewController(
                isPresented: .constant(true),
                style: SheetViewStyle(),
                content: self.contentView(item)
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
    func presentSheet<ContentView: View, Item: Equatable>(
        selectedItem: Binding<Item?>,
        style: SheetViewStyle = .standard,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder contentView: @escaping (Item) -> ContentView
    ) -> some View {
        self.modifier(
            ItemSheetViewModifier(
                selectedItem: selectedItem,
                style: style,
                onDismiss: onDismiss,
                contentView: contentView
            )
        )
    }
}


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
