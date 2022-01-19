//
//  UIViewExtensionTests.swift
//  
//
//  Created by Taylor Guidon on 1/18/22.
//

import XCTest
@testable import SheetUI

class UIViewExtensionTests: XCTestCase {

    var sut: UIView!
    
    override func setUp() {
        super.setUp()

        sut = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    }

    override func tearDown() {
        sut = nil

        super.tearDown()
    }

    func testViewAddRoundedTopCorners() {
        XCTAssertNil(sut.layer.mask)

        let expectedPath = UIBezierPath(
            roundedRect: self.sut.bounds,
            byRoundingCorners: [.topLeft, .topRight],
            cornerRadii: CGSize(width: 20, height: 20)
        ).cgPath

        sut.addRoundedTopCorners()

        XCTAssertNotNil(sut.layer.mask)
        let shapeLayer = sut.layer.mask as! CAShapeLayer
        XCTAssertEqual(shapeLayer.path, expectedPath)
    }
}
