//
//  AboutViewController.swift
//  Imgur
//
//  Created by yinzixiong on 5/30/16.
//  Copyright © 2016 yinzixiong. All rights reserved.
//

import UIKit

class AboutViewController: BaseViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.mHeadBarView.mTitleLabel.text = "About"
        
        let versionLabel : UILabel = UILabel(frame: CGRectMake(0, 100, UtilityObject.getScreenWidth(), 40))
        versionLabel.textAlignment = .Center
        if let version = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as? String
        {
            versionLabel.text = "Version: \(version)"
        }
        else
        {
            assert(false, "no version in plist")
        }
        self.view.addSubview(versionLabel)
        
        var y = versionLabel.frame.origin.y + versionLabel.frame.size.height + 30
        let buildLabel : UILabel = UILabel(frame: CGRectMake(0, y, UtilityObject.getScreenWidth(), 40))
        buildLabel.textAlignment = .Center
        if let build = NSBundle.mainBundle().infoDictionary!["CFBundleVersion"] as? String
        {
            buildLabel.text = "Build: \(build)"
        }
        else
        {
            assert(false, "no build in plist")
        }
        self.view.addSubview(buildLabel)
        
        y = buildLabel.frame.origin.y + buildLabel.frame.size.height + 30
        let authorLabel : UILabel = UILabel(frame: CGRectMake(0, y, UtilityObject.getScreenWidth(), 40))
        authorLabel.text = "Author: Yin Zixiong"
        authorLabel.textAlignment = .Center
        self.view.addSubview(authorLabel)
        
        y = authorLabel.frame.origin.y + authorLabel.frame.size.height + 30
        let emailLabel : UILabel = UILabel(frame: CGRectMake(0, y, UtilityObject.getScreenWidth(), 40))
        emailLabel.textAlignment = .Center
        emailLabel.text = "Email: abc123@abc.com"
        self.view.addSubview(emailLabel)
        
        self.mHeadBarView.setupDefaultBackButton()
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
