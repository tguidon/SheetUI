//
//  SheetItemSheetViewController.swift
//  
//
//  Created by Taylor Guidon on 1/23/22.
//

import SwiftUI
import UIKit

class SheetItemSheetViewController<Content: View, Item: SheetItem>: SheetViewController<Content> {
    
    @Binding private var selectedItem: Item?
    
    init(selectedItem: Binding<Item?>, style: SheetViewStyle, content: Content) {
        self._selectedItem = selectedItem
        
        super.init(style: style, content: content)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.selectedItem = nil
    }
}
