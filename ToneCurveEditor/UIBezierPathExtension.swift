//
//  File.swift
//  ToneCurveEditor
//
//  Created by Simon Gladman on 15/09/2014.
//  Copyright (c) 2014 Simon Gladman. All rights reserved.
//
// Based on Objective C code from: https://github.com/jnfisher/ios-curve-interpolation/blob/master/Curve%20Interpolation/UIBezierPath%2BInterpolation.m
// From this article: http://spin.atomicobject.com/2014/05/28/ios-interpolating-points/

import Foundation
import UIKit


extension UIBezierPath
{
    func interpolatePointsWithHermite(interpolationPoints : [CGPoint])
    {
        let n = interpolationPoints.count - 1
        
        for var ii = 0; ii < n; ++ii
        {
            
            var currentPoint = interpolationPoints[ii]
            
            if ii == 0
            {
                self.moveToPoint(interpolationPoints[0])
            }
            
            var nextii = (ii + 1) % interpolationPoints.count
            var previi = (ii - 1 < 0 ? interpolationPoints.count - 1 : ii-1);
            var previousPoint = interpolationPoints[previi]
            var nextPoint = interpolationPoints[nextii]
            let endPoint = nextPoint;
            var mx : Double = 0.0
            var my : Double = 0.0
            
            if ii > 0
            {
                mx = Double(nextPoint.x - currentPoint.x) * 0.5 + Double(currentPoint.x - previousPoint.x) * 0.5;
                my = Double(nextPoint.y - currentPoint.y) * 0.5 + Double(currentPoint.y - previousPoint.y) * 0.5;
            }
            else
            {
                mx = Double(nextPoint.x - currentPoint.x) * 0.5;
                my = Double(nextPoint.y - currentPoint.y) * 0.5;
            }
            
            let controlPoint1 = CGPoint(x: Double(currentPoint.x) + mx / 3.0, y: Double(currentPoint.y) + my / 3.0)
            currentPoint = interpolationPoints[nextii]
            nextii = (nextii + 1) % interpolationPoints.count
            previi = ii;
            previousPoint = interpolationPoints[previi]
            nextPoint = interpolationPoints[nextii]
            
            if ii < n - 1
            {
                mx = Double(nextPoint.x - currentPoint.x) * 0.5 + Double(currentPoint.x - previousPoint.x) * 0.5;
                my = Double(nextPoint.y - currentPoint.y) * 0.5 + Double(currentPoint.y - previousPoint.y) * 0.5;
            }
            else
            {
                mx = Double(currentPoint.x - previousPoint.x) * 0.5;
                my = Double(currentPoint.y - previousPoint.y) * 0.5;
            }
            
            let controlPoint2 = CGPoint(x: Double(currentPoint.x) - mx / 3.0, y: Double(currentPoint.y) - my / 3.0)
            
            self.addCurveToPoint(endPoint, controlPoint1: controlPoint1, controlPoint2: controlPoint2)
        }
    }
}