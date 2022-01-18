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
    /// The amount of spacing to set between the sheet top and the safe area layout guide top
    internal let topSpacing: CGFloat
    /// The velocity threshold at which to determine if the view should be dismissed
    internal let targetVelocity: CGFloat = 1000

    public init(
        backgroundColor: UIColor = .systemBackground,
        isModalInPresentation: Bool = false,
        topSpacing: CGFloat = 40
    ) {
        self.backgroundColor = backgroundColor
        self.isModalInPresentation = isModalInPresentation
        self.topSpacing = topSpacing
    }
}

public extension SheetViewStyle {
    static let standard = SheetViewStyle()
}
