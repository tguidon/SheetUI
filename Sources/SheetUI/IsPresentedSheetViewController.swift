//
//  IsPresentedSheetViewController.swift
//  
//
//  Created by Taylor Guidon on 1/23/22.
//

import SwiftUI
import UIKit

class IsPresentedSheetViewController<Content: View>: SheetViewController<Content> {
    
    @Binding private var isPresented: Bool
    
    init(isPresented: Binding<Bool>, style: SheetViewStyle, content: Content) {
        self._isPresented = isPresented

        super.init(style: style, content: content)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.isPresented = false
    }
}

