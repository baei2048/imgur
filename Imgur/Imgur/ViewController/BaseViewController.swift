//
//  BaseViewController.swift
//  Imgur
//
//  Created by yinzixiong on 5/30/16.
//  Copyright © 2016 yinzixiong. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController
{
    let mHeadBarView = HeadBarView(frame: CGRectMake(0, 0, UtilityObject.getScreenWidth() , NAVIGATION_BAR_HEIGHT))
    var mTitle: String?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.setNeedsStatusBarAppearanceUpdate()
        self.view.backgroundColor = UIColor.whiteColor()
        
        mHeadBarView.addObserver(self, forKeyPath: "actionId", options: .New, context: nil)
        self.view.addSubview(mHeadBarView)
    }
    
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        if let tempTitle = mTitle
        {
            mHeadBarView.mTitleLabel.text = tempTitle
        }
    }
    
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>)
    {
        if object is HeadBarView
        {
            if keyPath == "actionId"
            {
                if let tappedId : NSNumber = change?[NSKeyValueChangeNewKey] as? NSNumber
                {
                    if let action = HeadBarAction(rawValue: tappedId.integerValue)
                    {
                        switch action
                        {
                        case .LEFT_BUTTON:
                            self.onTapLeft()
                            
                        case .RIGHT_BUTTON:
                            self.onTapRight()
                        }
                    }
                    else
                    {
                        assert(false, "invalid enum HeadBarAction")
                    }
                }
                else
                {
                    assert(false, "invalide observing type")
                }
            }
        }
        else
        {
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        }
    }
    
    
    func enableBarShadow() -> Void
    {
        mHeadBarView.layer.shadowColor = UIColor.darkGrayColor().CGColor
        mHeadBarView.layer.shadowOpacity = 0.8
        mHeadBarView.layer.shadowRadius = 3
        self.view.bringSubviewToFront(mHeadBarView)
    }
    
    
    func safePushViewController(viewController : UIViewController, isAnimated : Bool = true)
    {
        if let navigationController = self.navigationController
        {
            navigationController.pushViewController(viewController, animated: isAnimated)
        }
    }
    
    
    func safePopCurrentViewController(isAnimated : Bool = true)
    {
        if let navigationController = self.navigationController
        {
            navigationController.popViewControllerAnimated(isAnimated)
        }
    }
    
    
    func onTapLeft()
    {
        
    }
    
    
    func onTapRight()
    {
        
    }

    
    override func preferredStatusBarStyle() -> UIStatusBarStyle
    {
        return UIStatusBarStyle.LightContent
    }

    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}
