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
    let sliderZero = UISlider(frame: CGRectZero)
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        addSubview(sliderZero)
    }

    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews()
    {
        sliderZero.frame = frame
    }

}
