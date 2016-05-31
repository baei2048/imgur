//
//  ImageCollectionDatasource.swift
//  Imgur
//
//  Created by yinzixiong on 5/31/16.
//  Copyright © 2016 yinzixiong. All rights reserved.
//

import UIKit

enum RequestStatusCode : Int
{
    case NORMAL = 0, INVALID_URL, DOWNLOAD_ERROR, INVALID_JSON_DATA
}

let CLIENT_ID = "ffd43b9ee4b8f45"

let BASE_URL = "https://api.imgur.com/"
let API_VERSION = "3/"
let GALLERY_MODULE_NAME = "gallery/"

let NUM_COLUMN_GRID_VIEW = 3

class ImageCollectionDatasource: NSObject, UICollectionViewDataSource
{
    var mListViewDataArray : Array<GalleryImageModel> = []
    var mDataTask : NSURLSessionDataTask?
    
    var mNumImageInSection = 0
    
    func refresh(urlString : String, complete : (code : RequestStatusCode)->Void) -> Void
    {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration();
        let dataSession = NSURLSession(configuration: configuration, delegate: nil, delegateQueue: nil);
        
        if let url = NSURL(string: urlString)
        {
            if let previousTask = mDataTask
            {
                print("cancel previous data task")
                previousTask.cancel()
                mDataTask = nil
            }
            
            let request = NSMutableURLRequest(URL: url)
            request.addValue("Client-ID \(CLIENT_ID)", forHTTPHeaderField:"Authorization")
            
            let task = dataSession.dataTaskWithRequest(request, completionHandler:
                { (data, response, error) in
                    self.mDataTask = nil
                    if error == nil
                    {
                        if let notNilData = data
                        {
                            do
                            {
                                if let jsonResult: NSDictionary = try NSJSONSerialization.JSONObjectWithData(notNilData, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary
                                {
                                    print("fetched json \(urlString)")
                                    self.mListViewDataArray.removeAll()
                                    if let galleryArray = jsonResult.objectForKey("data") as? NSArray
                                    {
                                        for i in 0..<galleryArray.count
                                        {
                                            if let galleryInfo = galleryArray[i] as? NSDictionary
                                            {
                                                let galleryObject = GalleryImageModel()
                                                self.mListViewDataArray.append(galleryObject)
                                                
                                                if let imageId = galleryInfo["id"] as? String
                                                {
                                                    galleryObject.mId = imageId
                                                }
                                                
                                                if let title = galleryInfo["title"] as? String
                                                {
                                                    galleryObject.mTitle = title
                                                }
                                                
                                                if let description = galleryInfo["description"] as? String
                                                {
                                                    galleryObject.mDiscription = description
                                                }
                                                
                                                if let link = galleryInfo["link"] as? String
                                                {
                                                    galleryObject.mLink = link
                                                    
                                                    if let _ = galleryInfo["type"] as? String
                                                    {
                                                        galleryObject.mBigImageLink = "http://i.imgur.com/\(galleryObject.mId)h.jpg"
                                                    }
                                                    else
                                                    {
                                                        if let coverId = galleryInfo["cover"] as? String
                                                        {
                                                            galleryObject.mCoverId = coverId
                                                            galleryObject.mLink = "http://i.imgur.com/\(galleryObject.mCoverId).jpg"
                                                            galleryObject.mBigImageLink = "http://i.imgur.com/\(galleryObject.mCoverId)h.jpg"
                                                        }
                                                    }
                                                }
                                                
                                                if let ups = galleryInfo["ups"] as? Int
                                                {
                                                    galleryObject.mUpVotes = ups
                                                }
                                                
                                                if let downs = galleryInfo["downs"] as? Int
                                                {
                                                    galleryObject.mDownVotes = downs
                                                }
                                                
                                                if let score = galleryInfo["score"] as? Int
                                                {
                                                    galleryObject.mScore = score
                                                }
                                            }
                                            else
                                            {
                                                complete(code: RequestStatusCode.INVALID_JSON_DATA)
                                            }
                                        }
                                        self.mNumImageInSection = 3
                                        complete(code: RequestStatusCode.NORMAL)
                                    }
                                    else
                                    {
                                        complete(code: RequestStatusCode.INVALID_JSON_DATA)
                                    }
                                }
                                else
                                {
                                    complete(code: RequestStatusCode.INVALID_JSON_DATA)
                                }
                            }
                            catch let error as NSError
                            {
                                print("json serial error, code \(error.code)")
                                complete(code: RequestStatusCode.INVALID_JSON_DATA)
                            }
                        }
                        else
                        {
                            complete(code: RequestStatusCode.INVALID_JSON_DATA)
                        }
                    }
                    else
                    {
                        complete(code: RequestStatusCode.DOWNLOAD_ERROR)
                    }
            })
            mDataTask = task
            task.resume()
        }
        else
        {
            complete(code: RequestStatusCode.INVALID_URL)
        }
    }

    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return mNumImageInSection
    }
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
    {
        return mListViewDataArray.count / 3
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath)
        
        if let imageCell = cell as? ImageCollectionViewCell
        {
            let index = indexPath.section * NUM_COLUMN_GRID_VIEW + indexPath.row
            if index < mListViewDataArray.count
            {
                let galleryImage = mListViewDataArray[index]
                imageCell.update(galleryImage)
            }
            else
            {
                print("ERROR: out of index mListViewDataArray")
            }
        }
        
        return cell
    }
}
