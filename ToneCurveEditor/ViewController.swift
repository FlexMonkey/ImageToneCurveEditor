//
//  ViewController.swift
//  ToneCurveEditor
//
//  Created by Simon Gladman on 12/09/2014.
//  Copyright (c) 2014 Simon Gladman. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    let imageWidget = ImageWidget(frame: CGRectZero)
    let toneCurveEditor = ToneCurveEditor(frame: CGRectZero)
    let resetButton = UIButton(frame: CGRectZero)

    override func viewDidLoad()
    {
        super.viewDidLoad()

        imageWidget.viewController = self
        
        resetButton.setTitle("Reset Curve", forState: .Normal)
        resetButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        resetButton.addTarget(self, action: "resetButtonClickedSelector:", forControlEvents: .TouchUpInside)
        
        view.addSubview(imageWidget)
        view.addSubview(toneCurveEditor)
        view.addSubview(resetButton)
        
        toneCurveEditor.curveValues = curveValues
        toneCurveEditor.addTarget(self, action: "toneCurveEditorChangedSelector:", forControlEvents: .ValueChanged)
    }
    
    func resetButtonClickedSelector(value: UIButton)
    {
        curveValues = [0.0, 0.25, 0.5, 0.75, 1.0]
    }
    
    func toneCurveEditorChangedSelector(value : ToneCurveEditor)
    {
        curveValues = value.curveValues
    }
    
    var curveValues: [Double] = [0.0, 0.25, 0.5, 0.75, 1.0]
    {
        didSet
        {
            imageWidget.curveValues = curveValues
            toneCurveEditor.curveValues = curveValues
        }
    }
    
    override func viewDidLayoutSubviews()
    {
        let topMargin = Int(topLayoutGuide.length)
        
        if view.frame.size.width < view.frame.size.height
        {
            // portrait mode
            let widgetWidth = Int(view.frame.size.width)
            let widgetHeight = Int(view.frame.size.height) / 2
            
            imageWidget.frame = CGRect(x: 5, y: topMargin, width: widgetWidth - 10, height: widgetHeight - topMargin - topMargin)
            toneCurveEditor.frame = CGRect(x: 0, y: widgetHeight, width: widgetWidth, height: widgetHeight - 50)
            
            resetButton.frame = CGRect(x: 20, y: view.frame.height - 70, width: 100, height: 50)
        }
        else
        {
            // landscape mode
            let widgetWidth = Int(view.frame.size.width) / 2
            let widgetHeight = Int(view.frame.size.height)
            
            imageWidget.frame = CGRect(x: widgetWidth, y: topMargin, width: widgetWidth - 5, height: widgetHeight - topMargin - topMargin)
            toneCurveEditor.frame = CGRect(x: 0, y: 0, width: widgetWidth, height: widgetHeight - 50)
            
            resetButton.frame = CGRect(x: 20, y: view.frame.height - 70, width: 100, height: 50)
        }
    }

    

    
    
}

