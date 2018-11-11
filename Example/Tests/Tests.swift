//
//  ViewController.swift
//  EPSignature
//
//  Created by Prabaharan on 01/13/2016.
//  Modified By C0mrade on 27/09/2016.
//  Copyright (c) 2016 Prabaharan. All rights reserved.
//

import XCTest
import EPSignature

class EPCalendarTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test1 () {
        let signatureView = EPSignatureView(frame: CGRect(x: 0, y: 0, width: 240, height: 320))
        XCTAssertNil(signatureView.getSignatureAsImage())
        XCTAssertFalse(signatureView.isSigned)
    }
    
}
