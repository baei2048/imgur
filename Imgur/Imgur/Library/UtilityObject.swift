//
//  UtilityObject.swift
//  Imgur
//
//  Created by yinzixiong on 5/30/16.
//  Copyright © 2016 yinzixiong. All rights reserved.
//

import UIKit

let THEME_COLOR : UInt = 0xEB5416

func debugLog(output: String)
{
    #if DEBUG
        print(output)
    #else
        
    #endif
}


func errorLog(output: String)
{
    #if DEBUG
        print("Error - \(output)")
    #else
        
    #endif
}


class UtilityObject: NSObject
{
    static var sDateFormatter : NSDateFormatter {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .MediumStyle
        dateFormatter.timeStyle = .ShortStyle
        
        return dateFormatter
    }
    
    static func UIColorFromRGB(rgbValue: UInt) -> UIColor
    {
        return UIColor(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                       green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                       blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                       alpha: CGFloat(1.0)
                       )
    }
    
    
    static func createImageFromColor(color: UIColor) -> UIImage
    {
        let rect = CGRectMake(0, 0, 1, 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, color.CGColor);
        CGContextFillRect(context, rect);
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image;
    }
    
    
    static func resizeImage(image : UIImage, size: CGSize) -> UIImage
    {
        UIGraphicsBeginImageContext(size);
        image.drawInRect(CGRectMake(0, 0, size.width, size.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        
        return newImage
    }
    
    
    static func getUserDocumentDirectory() -> String
    {
        return NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
    }
    
    
    static func getScreenWidth() -> CGFloat
    {
        return UIScreen.mainScreen().bounds.size.width
    }
    
    
    static func getScreenHeight() -> CGFloat
    {
        return UIScreen.mainScreen().bounds.size.height
    }
    
    
    static func getTimeString(time : String) -> String
    {
        let date = NSDate(timeIntervalSince1970: NSTimeInterval(time)!)
        return sDateFormatter.stringFromDate(date)
    }
    
    
    static func convertUiViewToUiImage(view : UIView) -> UIImage
    {
        let size = view.bounds.size
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.mainScreen().scale)
        view.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext()
        
        return image
    }
    
    
    static func blurImage(sourceImage : UIImage) -> UIImage
    {
        let frame = CGRectMake(0, 0, sourceImage.size.width, sourceImage.size.height)
        let imageRef : CGImageRef = CGImageCreateWithImageInRect(sourceImage.CGImage, frame)!
        
        let inputImageRef = UIImage(CGImage:imageRef).CGImage
        let inputCiImage = CIImage(CGImage: inputImageRef!)
        let filter = CIFilter(name: "CIGaussianBlur")
        filter?.setValue(inputCiImage, forKey:kCIInputImageKey)
        filter?.setValue(NSNumber(float: 15.0), forKey:"inputRadius")
        let result : CIImage = filter?.valueForKey(kCIOutputImageKey) as! CIImage
        let context = CIContext(options: nil)
        let resultCgImage = context.createCGImage(result, fromRect: inputCiImage.extent)
        
        return UIImage(CGImage: resultCgImage)
    }
}
