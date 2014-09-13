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
    let curveLayer = ToneCurveEditorCurveLayer()
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        curveLayer.toneCurveEditor = self
        curveLayer.contentsScale = UIScreen.mainScreen().scale
        layer.addSublayer(curveLayer)
  
        createSliders()
    }

    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    var curveValues : [Double] = [0.0, 0.25, 0.5, 0.75, 1.0]
    {
        didSet
        {
            for (i : Int, value : Double) in enumerate(curveValues)
            {
                sliders[i].value = Float(value)
            }
            
            drawCurve()
        }
    }
    
    func createSliders()
    {
        let rotateTransform = CGAffineTransformIdentity
        
        for i in 0..<5
        {
            let slider = UISlider(frame: CGRectZero)
  
            slider.transform = CGAffineTransformRotate(rotateTransform, CGFloat(-90.0 * M_PI / 180.0));
            slider.addTarget(self, action: "sliderChangeHandler:", forControlEvents: .ValueChanged)
            
            sliders.append(slider)
            
            addSubview(slider)
        }
    }
    
    func drawCurve()
    {
        curveLayer.frame = bounds.rectByInsetting(dx: 0, dy: 0)
        curveLayer.setNeedsDisplay()
    }
    
    func sliderChangeHandler(slider : UISlider)
    {
        curveValues = [Double]()
        
        for slider in sliders
        {
            curveValues.append(Double(slider.value))
        }
    }
    
    override func layoutSubviews()
    {
        let margin = 20
        let targetHeight = Int(frame.height) - margin - margin
        let targetWidth = Int(frame.width) / sliders.count
        
        for (i : Int, slider : UISlider) in enumerate(sliders)
        {
            let targetX = i * Int(frame.width) / sliders.count

            slider.frame = CGRect(x: targetX, y: margin, width: targetWidth, height: targetHeight)
        }
        
        drawCurve()
    }

}
