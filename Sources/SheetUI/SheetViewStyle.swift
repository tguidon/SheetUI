//
//  File.swift
//  
//
//  Created by Taylor Guidon on 1/17/22.
//

import UIKit

public struct SheetViewStyle {
    internal let backgroundColor: UIColor
    
    public init(
        backgroundColor: UIColor
    ) {
        self.backgroundColor = backgroundColor
    }
}

public extension SheetViewStyle {
    static let standard = SheetViewStyle(
        backgroundColor: .systemBackground
    )
}
