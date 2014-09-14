//
//  ToneCurveEditorCurveLayer.swift
//  ToneCurveEditor
//
//  Created by Simon Gladman on 13/09/2014.
//  Copyright (c) 2014 Simon Gladman. All rights reserved.
//

import UIKit
import CoreGraphics

class ToneCurveEditorCurveLayer: CALayer
{
    weak var toneCurveEditor : ToneCurveEditor?
    
    override func drawInContext(ctx: CGContext!)
    {
        if let curveValues = toneCurveEditor?.curveValues
        {
            var path = UIBezierPath()
            var previousPoint = CGPointZero
            
            let margin = 20
            let thumbRadius = 15
            let widgetWidth = Int(frame.width)
            let widgetHeight = Int(frame.height) - margin - margin - thumbRadius - thumbRadius

            for (i: Int, value: Double) in enumerate(curveValues)
            {
                let pathPointX = i * (widgetWidth / curveValues.count) + (widgetWidth / curveValues.count / 2)
                let pathPointY = thumbRadius + margin + widgetHeight - Int(Double(widgetHeight) * value)
                
                if i == 0
                {
                    previousPoint = CGPoint(x: pathPointX,y: pathPointY)
                    
                    path.moveToPoint(previousPoint)
                }
                else
                {
                    // TODO - implement as Catmull-Rom
                    let currentPoint = CGPoint(x: pathPointX, y: pathPointY)

                    let controlPointOne = CGPoint(x: currentPoint.x, y: previousPoint.y)
                    let controlPointTwo = CGPoint(x: previousPoint.x, y: currentPoint.y)
                    
                    path.addCurveToPoint(CGPoint(x: pathPointX, y: pathPointY), controlPoint1: controlPointOne, controlPoint2: controlPointTwo)
                    
                    previousPoint = currentPoint
                }
            }
    
            CGContextSetLineJoin(ctx, kCGLineJoinRound)
            CGContextAddPath(ctx, path.CGPath)
            CGContextSetStrokeColorWithColor(ctx, UIColor.lightGrayColor().CGColor)
            CGContextSetLineWidth(ctx, 2)
            CGContextStrokePath(ctx)
        }
    }

}
