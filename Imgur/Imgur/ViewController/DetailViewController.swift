//
//  DetailViewController.swift
//  Imgur
//
//  Created by yinzixiong on 5/30/16.
//  Copyright © 2016 yinzixiong. All rights reserved.
//

import UIKit

class DetailViewController: BaseViewController
{
    let mImageView : NetworkImageView = NetworkImageView(frame: CGRectMake(0, 64, UtilityObject.getScreenWidth(), UtilityObject.getScreenWidth()))
    
    let mTitleLabel : UILabel = UILabel(frame: CGRectMake(0, 0, UtilityObject.getScreenWidth(), 40))
    let mDiscriptionLabel : UILabel = UILabel(frame: CGRectMake(0, 0, UtilityObject.getScreenWidth(), 40))
    let mUpVoteLabel : UILabel = UILabel(frame: CGRectMake(0, 0, UtilityObject.getScreenWidth(), 40))
    let mDownVoteLabel : UILabel = UILabel(frame: CGRectMake(0, 0, UtilityObject.getScreenWidth(), 40))
    let mScoreLabel : UILabel = UILabel(frame: CGRectMake(0, 0, UtilityObject.getScreenWidth(), 40))
    
    var mGalleryImage : GalleryImageModel?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.mHeadBarView.backgroundColor = UIColor.whiteColor()
        
        self.view.backgroundColor = UIColor.grayColor()
        
        self.mHeadBarView.mTitleLabel.text = "Detail"
        
        self.mHeadBarView.setupDefaultBackButton()
        self.view.addSubview(mImageView)
        
        var y = UtilityObject.getScreenHeight() - 40
        mTitleLabel.frame.origin.y = y
        mTitleLabel.textAlignment = .Center
        mTitleLabel.textColor = UIColor.whiteColor()
        self.view.addSubview(mTitleLabel)
        
        y = mTitleLabel.frame.origin.y - 40
        mDiscriptionLabel.frame.origin.y = y
        mDiscriptionLabel.textAlignment = .Center
        mDiscriptionLabel.textColor = UIColor.whiteColor()
        self.view.addSubview(mDiscriptionLabel)
        
        y = mDiscriptionLabel.frame.origin.y - 40
        mUpVoteLabel.frame.origin.y = y
        mUpVoteLabel.textAlignment = .Center
        mUpVoteLabel.textColor = UIColor.whiteColor()
        self.view.addSubview(mUpVoteLabel)
        
        y = mUpVoteLabel.frame.origin.y - 40
        mDownVoteLabel.frame.origin.y = y
        mDownVoteLabel.textAlignment = .Center
        mDownVoteLabel.textColor = UIColor.whiteColor()
        self.view.addSubview(mDownVoteLabel)
        
        y = mDownVoteLabel.frame.origin.y - 40
        mScoreLabel.frame.origin.y = y
        mScoreLabel.textAlignment = .Center
        mScoreLabel.textColor = UIColor.whiteColor()
        self.view.addSubview(mScoreLabel)
        
        self.mHeadBarView.setupDefaultBackButton()
    }
    
    
    override func viewWillAppear(animated: Bool)
    {
        if let image = mGalleryImage
        {
            mImageView.downloadImageFromUrl(image.mBigImageLink, complete: { (code) in
                
            })
            
            mTitleLabel.text = image.mTitle
            mDiscriptionLabel.text = image.mDiscription
            mUpVoteLabel.text = "Up Votes: \(image.mUpVotes)"
            mDownVoteLabel.text = "Down Votes: \(image.mDownVotes)"
            mScoreLabel.text = "Score: \(image.mScore)"
        }
    }

    
    override func onTapLeft()
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}

