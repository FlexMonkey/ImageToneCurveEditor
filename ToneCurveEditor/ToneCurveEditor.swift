//
//  ToneCurveEditor.swift
//  ToneCurveEditor
//
//  Created by Simon Gladman on 12/09/2014.
//  Copyright (c) 2014 Simon Gladman. All rights reserved.
//

import UIKit

class ToneCurveEditor: UIControl
{
    var sliders = [UISlider]()
    var labels = [UILabel]()
    let curveLayer = ToneCurveEditorCurveLayer()
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        curveLayer.toneCurveEditor = self
        curveLayer.contentsScale = UIScreen.mainScreen().scale
        layer.addSublayer(curveLayer)
  
        createSliders()
        createLabels()
    }

    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    var curveValues : [Double] = [Double](count: 5, repeatedValue: 0.0)
    {
        didSet
        {
            for (i, value): (Int, Double) in curveValues.enumerate()
            {
                sliders[i].value = Float(value)
                labels[i].text = String(Float(value))
            }
            
            drawCurve()
        }
    }
    
    func createSliders()
    {
        let rotateTransform = CGAffineTransformIdentity
        
        for _ in 0..<5
        {
            let slider = UISlider(frame: CGRectZero)
  
            slider.transform = CGAffineTransformRotate(rotateTransform, CGFloat(-90.0 * M_PI / 180.0));
            slider.addTarget(self, action: #selector(ToneCurveEditor.sliderChangeHandler(_:)), forControlEvents: .ValueChanged)
            
            sliders.append(slider)
            
            addSubview(slider)
        }
    }
    
    func createLabels()
    {
        for _ in 0..<5
        {
            let label = UILabel(frame: CGRectZero)
            
            //label.textAlignment = NSTextAlignment(rawValue: 2)!
            
            labels.append(label)
            
            addSubview(label)
        }
    }
    
    func drawCurve()
    {
        curveLayer.frame = bounds.insetBy(dx: 0, dy: 0)
        curveLayer.setNeedsDisplay()
    }
    
    func sliderChangeHandler(slider : UISlider)
    {
        let index = sliders.indexOf(slider)
        curveValues[index!] = Double(slider.value)
        let label = labels[index!]
        label.text = String(slider.value)
        
        sendActionsForControlEvents(.ValueChanged)
    }
    
    override func layoutSubviews()
    {
        let margin = 20
        let targetHeight = Int(frame.height) - margin - margin
        let targetWidth = Int(frame.width) / sliders.count
        
        for (i, slider): (Int, UISlider) in sliders.enumerate()
        {
            let targetX = i * Int(frame.width) / sliders.count

            slider.frame = CGRect(x: targetX, y: margin, width: targetWidth, height: targetHeight)
        }
        
        for (i, label): (Int, UILabel) in labels.enumerate()
        {
            let targetX = i * Int(frame.width) / labels.count
            
            label.frame = CGRect(x: targetX + (targetWidth / 2) + (margin / 5), y: (targetHeight - (margin / 5)), width: targetWidth - (margin * 2), height: margin)
        }
        
        drawCurve()
    }

}
