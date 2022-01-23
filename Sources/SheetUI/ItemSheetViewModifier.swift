//
//  File.swift
//  
//
//  Created by Taylor Guidon on 1/23/22.
//

import SwiftUI

public struct ItemSheetViewModifier<ContentView: View, Item: SheetItem>: ViewModifier {
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
        if UIDevice.current.userInterfaceIdiom == .phone {
            content
                .onChange(of: selectedItem, perform: updatePresentation)
        } else {
            content
                .sheet(item: $selectedItem, onDismiss: self.onDismiss) { item in
                    self.contentView(item)
                }
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
            sheetViewController = SheetItemSheetViewController(
                selectedItem: self.$selectedItem,
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
    func presentSheet<ContentView: View, Item: SheetItem>(
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
