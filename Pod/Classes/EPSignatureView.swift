//
//  EPDrawingView.swift
//  Pods
//
//  Created by Prabaharan Elangovan on 13/01/16.
//
//

import UIKit

open class EPSignatureView: UIView {

    // MARK: - Private Vars
    
    fileprivate var bezierPoints = [CGPoint](repeating: CGPoint(), count: 5)
    fileprivate var bezierPath = UIBezierPath()
    fileprivate var bezierCounter : Int = 0
    fileprivate var maxPoint = CGPoint.zero
    fileprivate var minPoint = CGPoint.zero
    
    // MARK: - Public Vars
    
    open var strokeColor = UIColor.black
    open var strokeWidth: CGFloat = 2.0
    open var isSigned: Bool = false
    
    // MARK: - Initializers
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.clear
        bezierPath.lineWidth = strokeWidth
        addLongPressGesture()
        minPoint = CGPoint(x: self.frame.size.width,y: self.frame.size.height)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        bezierPath.lineWidth = strokeWidth
        addLongPressGesture()
        minPoint = CGPoint(x: self.frame.size.width,y: self.frame.size.height)
    }
    
    override open func draw(_ rect: CGRect) {
        bezierPath.stroke()
        strokeColor.setStroke()
        bezierPath.stroke()

    }
    
    
    // MARK: - Touch Functions
    
    func addLongPressGesture() {
        //Long press gesture is used to keep clear dots in the canvas
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(EPSignatureView.longPressed(_:)))
        longPressGesture.minimumPressDuration = 1.5
        self.addGestureRecognizer(longPressGesture)
    }
    
    func longPressed(_ gesture: UILongPressGestureRecognizer) {
        let touchPoint = gesture.location(in: self)
        let endAngle = CGFloat(2.0 * M_PI)
        bezierPath.move(to: touchPoint)
        bezierPath.addArc(withCenter: touchPoint, radius: 2, startAngle: 0, endAngle: endAngle, clockwise: true)
        setNeedsDisplay()
    }
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        if let currentPoint = touchPoint(touches) {
            isSigned = true
            bezierPoints[0] = currentPoint
            bezierCounter = 0
        }
    }
    
    override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let currentPoint = touchPoint(touches) {
            bezierCounter += 1
            bezierPoints[bezierCounter] = currentPoint

            //Smoothing is done by Bezier Equations where curves are calculated based on four concurrent  points drawn
            if bezierCounter == 4 {
                bezierPoints[3] = CGPoint(x: (bezierPoints[2].x + bezierPoints[4].x) / 2 , y: (bezierPoints[2].y + bezierPoints[4].y) / 2)
                bezierPath.move(to: bezierPoints[0])
                bezierPath.addCurve(to: bezierPoints[3], controlPoint1: bezierPoints[1], controlPoint2: bezierPoints[2])
                setNeedsDisplay()
                bezierPoints[0] = bezierPoints[3]
                bezierPoints[1] = bezierPoints[4]
                bezierCounter = 1
            }
        }
    }
    
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        bezierCounter = 0
    }
    
    func touchPoint(_ touches: Set<UITouch>) -> CGPoint? {
        if let touch = touches.first {
            let point = touch.location(in: self)
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
    open func clear() {
        isSigned = false
        bezierPath.removeAllPoints()
        setNeedsDisplay()
    }
    
    /** Returns the drawn path as Image. Adding subview to this view will also get returned in this image.
     */
    open func getSignatureAsImage() -> UIImage? {
        if isSigned {
            UIGraphicsBeginImageContext(CGSize(width: self.bounds.size.width, height: self.bounds.size.height))
            self.layer.render(in: UIGraphicsGetCurrentContext()!)
            let signature: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            return signature
        }
        return nil
    }
    
    /** Returns the rect of signature image drawn in the canvas. This can very very useful in croping out the unwanted empty areas in the signature image returned.
     */

    open func getSignatureBoundsInCanvas() -> CGRect {
        return CGRect(x: minPoint.x, y: minPoint.y, width: maxPoint.x - minPoint.x, height: maxPoint.y - minPoint.y)
    }
    
    //MARK: Save load signature methods
    
    open func saveSignature(_ localPath: String) {
        if isSigned {
            NSKeyedArchiver.archiveRootObject(bezierPath, toFile: localPath)
        }
    }

    open func loadSignature(_ filePath: String) {
        if let path = getPath(filePath) {
            isSigned = true
            bezierPath = path
            setNeedsDisplay()
        }
    }
    
    fileprivate func getPath(_ filePath: String) -> UIBezierPath? {
        if FileManager.default.fileExists(atPath: filePath) {
            return NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? UIBezierPath
        }
        return nil
    }
    
    func removeSignature() {
        let docPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        let filePath = (docPath! as NSString).appendingPathComponent("sig.data")
        do {
            try FileManager.default.removeItem(atPath: filePath)
        }
        catch let error {
            print(error)
        }
    }
    
}
