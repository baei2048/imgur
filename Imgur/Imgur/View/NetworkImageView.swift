//
//  NetworkImageView.swift
//  Imgur
//
//  Created by yinzixiong on 5/30/16.
//  Copyright © 2016 yinzixiong. All rights reserved.
//

import UIKit

enum ImageDownloadCode : Int
{
    case NORMAL = 0, INVALID_URL, DOWNLOAD_ERROR, INVALID_IMAGE_DATA
}

var gPlaceHolderImageCache : Dictionary<String, UIImage> = [String : UIImage]()
var sImageCache : Dictionary<String, UIImage> = [String : UIImage]()

class NetworkImageView: UIImageView
{
    var mDataTask : NSURLSessionDataTask?
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    
    func downloadImageFromUrl(urlString : String, complete : (code : ImageDownloadCode) -> Void)
    {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration();
        let backgroundSession = NSURLSession(configuration: configuration, delegate: nil, delegateQueue: nil);
        
        if let image = sImageCache[urlString]
        {
            self.image = image
        }
        else
        {
            if let url = NSURL(string: urlString)
            {
                if let previousTask = mDataTask
                {
                    debugLog("cancel previous image downloading task")
                    previousTask.cancel()
                    mDataTask = nil
                }
                
                let request = NSURLRequest(URL: url)
                self.image = self.generatePlaceHolder()
                let task = backgroundSession.dataTaskWithRequest(request, completionHandler:
                    { (data, response, error) in
                        self.mDataTask = nil
                        if error == nil
                        {
                            if let notNilData = data
                            {
                                if let image = UIImage(data: notNilData)
                                {
                                    debugLog("fetched image \(url)")
                                    
                                    self.performSelectorOnMainThread(#selector(NetworkImageView.updateImage(_:)), withObject: image, waitUntilDone: false)
                                    
                                    sImageCache[urlString] = image
                                    complete(code: ImageDownloadCode.NORMAL)
                                }
                                else
                                {
                                    complete(code: ImageDownloadCode.INVALID_IMAGE_DATA)
                                }
                            }
                            else
                            {
                                complete(code: ImageDownloadCode.INVALID_IMAGE_DATA)
                            }
                        }
                        else
                        {
                            complete(code: ImageDownloadCode.DOWNLOAD_ERROR)
                        }
                })
                mDataTask = task
                task.resume()
            }
            else
            {
                complete(code: ImageDownloadCode.INVALID_URL)
            }
        }
    }
    
    
    func updateImage(image : UIImage) -> Void
    {
        self.image = image
    }
    
    
    func generatePlaceHolder() -> UIImage
    {
        let key = "\(Int(self.frame.size.width))x\(Int(self.frame.size.height))"
        if let image = gPlaceHolderImageCache[key]
        {
            return image
        }
        else
        {
            let view = UIView(frame: CGRectMake(0, 0, self.frame.size.width, self.frame.size.height))
            view.backgroundColor = UIColor.whiteColor()
            view.layer.borderColor = UtilityObject.UIColorFromRGB(0xfdfdfd).CGColor
            view.layer.borderWidth = 0.5
            let label = UILabel(frame: CGRectMake(0, (self.frame.size.height - 30) * 0.5, self.frame.size.width, 30))
            label.textAlignment = .Center
            label.textColor = UIColor.lightGrayColor()
            label.font = UIFont(name: "FontAwesome", size: 22)
            label.text = IconCode.IMAGE_ICON.rawValue
            view.addSubview(label)
            let placeHolderImage = UtilityObject.convertUiViewToUiImage(view)
            return placeHolderImage
        }
    }
}
