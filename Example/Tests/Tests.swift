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
        let signatureView = EPSignatureView(frame: CGRectMake(0,0,240,320))
        XCTAssertNil(signatureView.getSignatureAsImage())
        XCTAssertFalse(signatureView.isSigned)
    }
    
}