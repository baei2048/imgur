//
//  ImageCollectionViewCell.swift
//  Imgur
//
//  Created by yinzixiong on 5/31/16.
//  Copyright © 2016 yinzixiong. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell
{
    let mImageView : NetworkImageView
    
    let mLabel : UILabel
    
    override init(frame: CGRect)
    {
        mImageView = NetworkImageView(frame: CGRectMake(0, 0, frame.size.width, frame.size.height))
        mLabel = UILabel(frame : CGRectMake(0, frame.size.height - 20, frame.size.width, 20))
        mLabel.textColor = UIColor.whiteColor()
        mLabel.font = UIFont.systemFontOfSize(13)
        super.init(frame: frame)
        self.contentView.addSubview(mImageView)
        self.contentView.addSubview(mLabel)
    }
    
    func update(galleryImage : GalleryImageModel) -> Void
    {
        mImageView.downloadImageFromUrl(galleryImage.mLink) { (code) in
            
        }
        
        mLabel.text = galleryImage.mDiscription
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        mImageView = NetworkImageView(frame: CGRectZero)
        mLabel = UILabel(frame : CGRectZero)
        super.init(coder: aDecoder)
    }
}
