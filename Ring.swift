//
//  Ring.swift
//  Limbo
//
//  Created by Rahul Bhethanabotla on 7/14/16.
//  Copyright © 2016 Rahul Bhethanabotla. All rights reserved.
//

import Foundation
import UIKit
class Ring: UIView {
    override func drawRect(rect: CGRect) {
        drawRingFittingInsideView(rect)
    }
    
    internal func drawRingFittingInsideView(rect: CGRect) -> () {
        let halfSize:CGFloat = min( bounds.size.width/2, bounds.size.height/2)
        let desiredLineWidth:CGFloat = 1    // your desired value
        let hw:CGFloat = desiredLineWidth/2
        
        let circlePath = UIBezierPath(ovalInRect: CGRectInset(rect,hw,hw) )
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.CGPath
        
        shapeLayer.fillColor = UIColor.clearColor().CGColor
        shapeLayer.strokeColor = UIColor.redColor().CGColor
        shapeLayer.lineWidth = desiredLineWidth
        
        layer.addSublayer(shapeLayer)
    
    }
}
