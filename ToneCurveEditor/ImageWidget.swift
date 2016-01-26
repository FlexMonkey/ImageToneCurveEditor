//
//  ImageWidget.swift
//  ToneCurveEditor
//
//  Created by Simon Gladman on 12/09/2014.
//  Copyright (c) 2014 Simon Gladman. All rights reserved.
//

import UIKit

class ImageWidget: UIControl , UINavigationControllerDelegate, UIImagePickerControllerDelegate
{
    let blurOveray = UIVisualEffectView(effect: UIBlurEffect())
    let loadImageButton = UIButton(frame: CGRectZero)
    let imageView = UIImageView(frame: CGRectZero)
    let activityIndicator = UIActivityIndicatorView(frame: CGRectZero)
    
    let ciContext = CIContext(options: nil)
    let filter = CIFilter(name: "CIToneCurve")
    
    var backgroundBlock : Async?
    var loadedImage : UIImage?
    var filteredImage : UIImage?
    
    weak var viewController : UIViewController?
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
 
        backgroundColor = UIColor.blackColor()
        
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        
        addSubview(imageView)
        addSubview(blurOveray)
        
        loadImageButton.setTitle("Load Image", forState: .Normal)
        loadImageButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        
        loadImageButton.addTarget(self, action: "loadImageButtonClickHandler:", forControlEvents: .TouchUpInside)
        
        addSubview(loadImageButton)
        
        activityIndicator.hidesWhenStopped = true
        
        activityIndicator.color = UIColor.blackColor()
        addSubview(activityIndicator)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    func loadImageButtonClickHandler(button : UIButton)
    {
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.modalInPopover = false
        imagePicker.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum
        
        viewController!.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    var filterIsRunning : Bool = false
    {
        didSet
        {
            if filterIsRunning
            {
                activityIndicator.startAnimating()
            }
            else
            {
                activityIndicator.stopAnimating()
            }
        }
    }
    
    var curveValues: [Double] = [0.0, 0.25, 0.5, 0.75, 1.0]
    {
        didSet
        {
            applyFilterAsync()
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        backgroundBlock?.cancel()
        backgroundBlock = nil
        
        filterIsRunning = false
        
        if let rawImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            loadedImage = rawImage.resizeToBoundingSquare(boundingSquareSideLength: 1024)
            
            applyFilterAsync()
        }

        viewController!.dismissViewControllerAnimated(true, completion: nil)
    }


    
    func applyFilterAsync()
    {
        backgroundBlock = Async.background
        {
            if !self.filterIsRunning && self.loadedImage != nil
            {
                self.filterIsRunning = true
                self.filteredImage = ImageWidget.applyFilter(loadedImage: self.loadedImage!, curveValues: self.curveValues, ciContext: self.ciContext, filter: self.filter)
            }
        }
        .main
        {
            self.imageView.image = self.filteredImage
            self.filterIsRunning = false
        }
    }
    
    
    class func applyFilter(loadedImage loadedImage: UIImage, curveValues: [Double], ciContext: CIContext, filter: CIFilter) -> UIImage
    {
        let coreImage = CIImage(image: loadedImage)
        
        filter.setValue(coreImage, forKey: kCIInputImageKey)
        
        filter.setValue(CIVector(x: 0.0, y: CGFloat(curveValues[0])), forKey: "inputPoint0")
        filter.setValue(CIVector(x: 0.25, y: CGFloat(curveValues[1])), forKey: "inputPoint1")
        filter.setValue(CIVector(x: 0.5, y: CGFloat(curveValues[2])), forKey: "inputPoint2")
        filter.setValue(CIVector(x: 0.75, y: CGFloat(curveValues[3])), forKey: "inputPoint3")
        filter.setValue(CIVector(x: 1.0, y: CGFloat(curveValues[4])), forKey: "inputPoint4")
        
        let filteredImageData = filter.valueForKey(kCIOutputImageKey) as! CIImage
        let filteredImageRef = ciContext.createCGImage(filteredImageData, fromRect: filteredImageData.extent())
        let filteredImage = UIImage(CGImage: filteredImageRef)
       
        return filteredImage
    }
    
    override func layoutSubviews()
    {
        blurOveray.frame = CGRect(x: 0, y: frame.height - 50, width: frame.width, height: 50)
   
        loadImageButton.frame = CGRect(x: 20, y: frame.height - 50, width: 100, height: 50)
    
        imageView.frame = CGRect(x: 5, y: 5, width: frame.width - 10, height: frame.height - 10)
        
        activityIndicator.frame = CGRect(x: frame.width - 20, y: frame.height - 25, width: 0, height: 0)
    }
}
