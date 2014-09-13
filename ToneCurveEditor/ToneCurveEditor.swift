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
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        createSliders()
    }

    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        createSliders()
    }
    
    func createSliders()
    {
        let rotateTransform = CGAffineTransformIdentity
        
        for i in 0..<5
        {
            let slider = UISlider(frame: CGRectZero)
            slider.value = 0.25
 
            slider.transform = CGAffineTransformRotate(rotateTransform, CGFloat(-90.0 * M_PI / 180.0));
            slider.addTarget(self, action: "sliderChangeHandler:", forControlEvents: .ValueChanged)
            
            sliders.append(slider)
            
            addSubview(slider)
        }
    }
    
    func sliderChangeHandler(slider : UISlider)
    {
        println("slider change \(slider.value)")
    }
    
    override func layoutSubviews()
    {
        let targetHeight = Int(frame.height) - 40
        let targetWidth = Int(frame.width) / sliders.count
        
        for (i : Int, slider : UISlider) in enumerate(sliders)
        {
            let targetX = i * Int(frame.width) / sliders.count

            slider.frame = CGRect(x: targetX, y: 20, width: targetWidth, height: targetHeight)
        }
    }

}
