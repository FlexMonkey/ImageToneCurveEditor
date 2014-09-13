//
//  ViewController.swift
//  ToneCurveEditor
//
//  Created by Simon Gladman on 12/09/2014.
//  Copyright (c) 2014 Simon Gladman. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate
{

    let imageWidget = ImageWidget(frame: CGRectZero)
    let toneCurveEditor = ToneCurveEditor(frame: CGRectZero)
    
    /*
    curve through points: http://stackoverflow.com/questions/7054272/how-to-draw-smooth-curve-through-n-points-using-javascript-html5-canvas
    
    // move to the first point
    ctx.moveTo(points[0].x, points[0].y);


    for (i = 1; i < points.length - 2; i ++)
    {
    var xc = (points[i].x + points[i + 1].x) / 2;
    var yc = (points[i].y + points[i + 1].y) / 2;
    ctx.quadraticCurveTo(points[i].x, points[i].y, xc, yc);
    }
    // curve through the last two points
    ctx.quadraticCurveTo(points[i].x, points[i].y, points[i+1].x,points[i+1].y);
    */

    override func viewDidLoad()
    {
        super.viewDidLoad()

        imageWidget.backgroundColor = UIColor.redColor()
        toneCurveEditor.backgroundColor = UIColor.blueColor()
        
        view.addSubview(imageWidget)
        view.addSubview(toneCurveEditor)
    }
    
    override func viewDidLayoutSubviews()
    {
        if view.frame.size.width < view.frame.size.height
        {
            // portrait mode
            let widgetWidth = Int(view.frame.size.width)
            let widgetHeight = Int(view.frame.size.height) / 2
            
            imageWidget.frame = CGRect(x: 0, y: 0, width: widgetWidth, height: widgetHeight)
            toneCurveEditor.frame = CGRect(x: 0, y: widgetHeight, width: widgetWidth, height: widgetHeight)
        }
        else
        {
            // landscape mode
            let widgetWidth = Int(view.frame.size.width) / 2
            let widgetHeight = Int(view.frame.size.height)
            
            imageWidget.frame = CGRect(x: widgetWidth, y: 0, width: widgetWidth, height: widgetHeight)
            toneCurveEditor.frame = CGRect(x: 0, y: 0, width: widgetWidth, height: widgetHeight)
        }
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func buttonClickHandler(sender: AnyObject)
    {
        var imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum
        
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }

    @IBOutlet weak var imageView: UIImageView!
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject])
    {
        let foo = info[UIImagePickerControllerOriginalImage] as UIImage;
        
        imageView.image = foo
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}

