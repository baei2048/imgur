//
//  HeadBarView.swift
//  Imgur
//
//  Created by yinzixiong on 5/30/16.
//  Copyright © 2016 yinzixiong. All rights reserved.
//

import UIKit

enum HeadBarAction : Int
{
    case LEFT_BUTTON = 0, RIGHT_BUTTON
}

let NAVIGATION_BAR_HEIGHT : CGFloat = 64.0

class HeadBarView: UIView
{
    let mLeftButton = UIButton()
    let mRightButton = UIButton()
    let mTitleLabel = UILabel()
    
    dynamic var actionId : NSNumber = NSNumber()
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        //self.backgroundColor = UIColor.lightGrayColor()
        
        var viewFrame = mLeftButton.frame;
        viewFrame.origin.x = 5;
        viewFrame.origin.y = 20;
        viewFrame.size.height = 44;
        viewFrame.size.width = 66;
        mLeftButton.frame = viewFrame;
        mLeftButton.backgroundColor = UIColor.clearColor()
        mLeftButton.tag = HeadBarAction.LEFT_BUTTON.rawValue
        mLeftButton.addTarget(self, action: #selector(HeadBarView.onTap(_:)), forControlEvents: .TouchUpInside)
        mLeftButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        self.addSubview(mLeftButton)
        
        viewFrame.origin.x = mLeftButton.frame.origin.x + mLeftButton.frame.size.width + 10
        viewFrame.size.width = frame.size.width - viewFrame.origin.x * 2
        mTitleLabel.frame = viewFrame
        mTitleLabel.textAlignment = .Center
        mTitleLabel.font = UIFont.boldSystemFontOfSize(20)
        mTitleLabel.textColor = UIColor.blackColor()
        self.addSubview(mTitleLabel)
        
        viewFrame.origin.x = mTitleLabel.frame.origin.x + mTitleLabel.frame.size.width + 10
        viewFrame.size.width = 44
        mRightButton.frame = viewFrame;
        mRightButton.backgroundColor = UIColor.clearColor()
        mRightButton.tag = HeadBarAction.RIGHT_BUTTON.rawValue
        mRightButton.addTarget(self, action: #selector(HeadBarView.onTap(_:)), forControlEvents: .TouchUpInside)
        mRightButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        self.addSubview(mRightButton)
    }
    
    
    func onTap(sender : UIButton)
    {
        actionId = NSNumber(integer: sender.tag)
    }
    
    
    func setupDefaultBackButton()
    {
        mLeftButton.titleLabel?.font = UIFont(name: "FontAwesome", size: 25)
        mLeftButton.setTitle(IconCode.LIGTH_BACK_ICON.rawValue, forState: .Normal)
        mLeftButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
    }
    
    
    func setupLeftButtonIcon(iconCode : String)
    {
        mLeftButton.titleLabel?.font = UIFont(name: "FontAwesome", size: 20)
        mLeftButton.setTitle(iconCode, forState: .Normal)
    }
    
    
    func setupRightButtonIcon(iconCode : String)
    {
        mRightButton.titleLabel?.font = UIFont(name: "FontAwesome", size: 20)
        mRightButton.setTitle(iconCode, forState: .Normal)
    }
    
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
}
