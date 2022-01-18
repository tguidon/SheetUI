//
//  File.swift
//  
//
//  Created by Taylor Guidon on 1/17/22.
//

import UIKit

public struct SheetViewStyle {
    /// The background colo to apply to the sheet view
    internal let backgroundColor: UIColor
    /// Set this value to mirror the functionality found on a `UIViewController`.
    internal let isModalInPresentation: Bool
    
    public init(
        backgroundColor: UIColor = .systemBackground,
        isModalInPresentation: Bool = false
    ) {
        self.backgroundColor = backgroundColor
        self.isModalInPresentation = isModalInPresentation
    }
}

public extension SheetViewStyle {
    static let standard = SheetViewStyle()
}
