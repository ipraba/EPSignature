//
//  EPDrawingView.swift
//  Pods
//
//  Created by Prabaharan Elangovan on 13/01/16.
//
//

import UIKit

public class EPSignatureView: UIView {

    // MARK: - Private Vars
    
    private var bezierPoints = [CGPoint](count: 5, repeatedValue: CGPoint())
    private var bezierPath = UIBezierPath()
    private var bezierCounter : Int = 0
    private var maxPoint = CGPointZero
    private var minPoint = CGPointZero
    
    // MARK: - Public Vars
    
    public var strokeColor = UIColor.blackColor()
    public var strokeWidth: CGFloat = 2.0
    public var isSigned: Bool = false
    
    // MARK: - Initializers
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        bezierPath.lineWidth = strokeWidth
        addLongPressGesture()
        minPoint = CGPointMake(self.frame.size.width,self.frame.size.height)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        bezierPath.lineWidth = strokeWidth
        addLongPressGesture()
        minPoint = CGPointMake(self.frame.size.width,self.frame.size.height)
    }
    
    override public func drawRect(rect: CGRect) {
        bezierPath.stroke()
        strokeColor.setStroke()
        bezierPath.stroke()

    }
    
    
    // MARK: - Touch Functions
    
    func addLongPressGesture() {
        //Long press gesture is used to keep clear dots in the canvas
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: "longPressed:")
        longPressGesture.minimumPressDuration = 1.5
        self.addGestureRecognizer(longPressGesture)
    }
    
    func longPressed(gesture: UILongPressGestureRecognizer) {
        let touchPoint = gesture.locationInView(self)
        let endAngle = CGFloat(2.0 * M_PI)
        bezierPath.moveToPoint(touchPoint)
        bezierPath.addArcWithCenter(touchPoint, radius: 2, startAngle: 0, endAngle: endAngle, clockwise: true)
        setNeedsDisplay()
    }
    
    override public func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {

        if let currentPoint = touchPoint(touches) {
            isSigned = true
            bezierPoints[0] = currentPoint
            bezierCounter = 0
        }
    }
    
    override public func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let currentPoint = touchPoint(touches) {
            bezierCounter++
            bezierPoints[bezierCounter] = currentPoint

            //Smoothing is done by Bezier Equations where curves are calculated based on four concurrent  points drawn
            if bezierCounter == 4 {
                bezierPoints[3] = CGPointMake((bezierPoints[2].x + bezierPoints[4].x) / 2 , (bezierPoints[2].y + bezierPoints[4].y) / 2)
                bezierPath.moveToPoint(bezierPoints[0])
                bezierPath.addCurveToPoint(bezierPoints[3], controlPoint1: bezierPoints[1], controlPoint2: bezierPoints[2])
                setNeedsDisplay()
                bezierPoints[0] = bezierPoints[3]
                bezierPoints[1] = bezierPoints[4]
                bezierCounter = 1
            }
        }
    }
    
    override public func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        bezierCounter = 0
    }
    
    func touchPoint(touches: Set<UITouch>) -> CGPoint? {
        if let touch = touches.first {
            let point = touch.locationInView(self)
            //Track the signature bounding area
            if point.x > maxPoint.x {
                maxPoint.x = point.x
            }
            if point.y > maxPoint.y {
                maxPoint.y = point.y
            }
            if point.x < minPoint.x {
                minPoint.x = point.x
            }
            if point.y < minPoint.y {
                minPoint.y = point.y
            }
            return point
        }
        return nil
    }
    
    //MARK: Utility Methods
    
    /** Clears the drawn paths in the canvas
    */
    public func clear() {
        isSigned = false
        bezierPath.removeAllPoints()
        setNeedsDisplay()
    }
    
    /** Returns the drawn path as Image. Adding subview to this view will also get returned in this image.
     */
    public func getSignatureAsImage() -> UIImage? {
        if isSigned {
            UIGraphicsBeginImageContext(CGSizeMake(self.bounds.size.width, self.bounds.size.height))
            self.layer.renderInContext(UIGraphicsGetCurrentContext()!)
            let signature: UIImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return signature
        }
        return nil
    }
    
    /** Returns the rect of signature image drawn in the canvas. This can very very useful in croping out the unwanted empty areas in the signature image returned.
     */

    public func getSignatureBoundsInCanvas() -> CGRect {
        return CGRectMake(minPoint.x, minPoint.y, maxPoint.x - minPoint.x, maxPoint.y - minPoint.y)
    }
    
    //MARK: Save load signature methods
    
    public func saveSignature(localPath: String) {
        if isSigned {
            NSKeyedArchiver.archiveRootObject(bezierPath, toFile: localPath)
        }
    }

    public func loadSignature(filePath: String) {
        if let path = getPath(filePath) {
            isSigned = true
            bezierPath = path
            setNeedsDisplay()
        }
    }
    
    private func getPath(filePath: String) -> UIBezierPath? {
        if NSFileManager.defaultManager().fileExistsAtPath(filePath) {
            return NSKeyedUnarchiver.unarchiveObjectWithFile(filePath) as? UIBezierPath
        }
        return nil
    }
    
    func removeSignature() {
        let docPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first
        let filePath = (docPath! as NSString).stringByAppendingPathComponent("sig.data")
        do {
            try NSFileManager.defaultManager().removeItemAtPath(filePath)
        }
        catch let error {
            print(error)
        }
    }
    
}
