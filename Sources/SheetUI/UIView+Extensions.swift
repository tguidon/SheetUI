//
//  File.swift
//  
//
//  Created by Taylor Guidon on 1/17/22.
//

import UIKit

extension UIView {

    /// Add rounded top corners to the view as a `CAShapeLayer` mask
    func addRoundedTopCorners() {
        let path = UIBezierPath(
            roundedRect: self.bounds,
            byRoundingCorners: [.topLeft, .topRight],
            cornerRadii: CGSize(width: 20.0, height: 20.0)
        )
        
        let shape = CAShapeLayer()
        shape.path = path.cgPath
        self.layer.mask = shape
    }
}
