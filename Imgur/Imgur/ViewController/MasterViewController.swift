//
//  MasterViewController.swift
//  Imgur
//
//  Created by yinzixiong on 5/30/16.
//  Copyright © 2016 yinzixiong. All rights reserved.
//

import UIKit

let IMAGE_PADDING : CGFloat = 5.0
let TABLEVIEW_RATIO : CGFloat = 0.7

class MasterViewController: BaseViewController, UITableViewDelegate, UICollectionViewDelegate
{
    lazy var mDetailViewController : DetailViewController = DetailViewController()
    lazy var mAboutViewController : AboutViewController = AboutViewController()

    var mUrlConfigTableView : UITableView = UITableView(frame: CGRectMake(0, 20, UtilityObject.getScreenWidth() * TABLEVIEW_RATIO, UtilityObject.getScreenHeight() - 20))
    
    var mCloseConfigTableButton : UIButton = UIButton(frame: CGRectMake(UtilityObject.getScreenWidth() * TABLEVIEW_RATIO, 20,
        UtilityObject.getScreenWidth() * (1 - TABLEVIEW_RATIO), UtilityObject.getScreenHeight() - 20))
    
    let mUrlConfigTableViewDatasource = UrlSettingTableViewDatasource()
    
    let mImageCollectionDatasource = ImageCollectionDatasource()
    
    let mImageCollectionViewLayout : UICollectionViewFlowLayout =
    {
        let layout = UICollectionViewFlowLayout()
        
        let width = UtilityObject.getScreenWidth() / CGFloat(NUM_COLUMN_GRID_VIEW) - 2.0 * IMAGE_PADDING
        layout.itemSize = CGSizeMake(width, width)
        layout.sectionInset = UIEdgeInsetsMake(IMAGE_PADDING, IMAGE_PADDING, IMAGE_PADDING, IMAGE_PADDING)
        return layout
    }()
    
    let mLoadingIndicator = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
    
    let mImageCollectionView : UICollectionView
    
    required init?(coder aDecoder: NSCoder)
    {
        mImageCollectionView = UICollectionView(frame: CGRectMake(0, 64, UtilityObject.getScreenWidth(), UtilityObject.getScreenHeight() - 64), collectionViewLayout:mImageCollectionViewLayout)
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!)
    {
        mImageCollectionView = UICollectionView(frame: CGRectMake(0, 64, UtilityObject.getScreenWidth(), UtilityObject.getScreenHeight() - 64), collectionViewLayout:mImageCollectionViewLayout)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    convenience init()
    {
        self.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.mHeadBarView.backgroundColor = UIColor.whiteColor()
        self.mHeadBarView.mTitleLabel.text = "Imgur"
        
        self.mHeadBarView.setupLeftButtonIcon(IconCode.MENU_ICON.rawValue)
        
        mImageCollectionView.registerClass(ImageCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        mImageCollectionView.dataSource = mImageCollectionDatasource
        mImageCollectionView.backgroundColor = UIColor.lightGrayColor()
        mImageCollectionView.delegate = self
        self.view.addSubview(mImageCollectionView)
        
        mCloseConfigTableButton.addTarget(self, action:#selector(MasterViewController.removeConfigTableView), forControlEvents:.TouchUpInside)
        mCloseConfigTableButton.backgroundColor = UIColor.blackColor()
        mCloseConfigTableButton.alpha = 0.7
        
        self.view.backgroundColor = UIColor.lightGrayColor()
        mLoadingIndicator.frame = CGRectMake((UtilityObject.getScreenWidth() - 37) * 0.5, (UtilityObject.getScreenHeight() - 37) * 0.5, 37, 37)
        self.view.addSubview(mLoadingIndicator)
    }
    
    
    func removeConfigTableView() -> Void
    {
        mCloseConfigTableButton.removeFromSuperview()
        mUrlConfigTableView.removeFromSuperview()
    }
    
    
    override func onTapLeft()
    {
        mUrlConfigTableView.dataSource = mUrlConfigTableViewDatasource
        mUrlConfigTableView.delegate = self
        self.view.addSubview(mUrlConfigTableView)
        self.view.addSubview(mCloseConfigTableButton)
    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        let index = indexPath.section * NUM_COLUMN_GRID_VIEW + indexPath.row
        if index < mImageCollectionDatasource.mListViewDataArray.count
        {
            let galleryImage = mImageCollectionDatasource.mListViewDataArray[index]
            mDetailViewController.mGalleryImage = galleryImage
            self.navigationController?.pushViewController(mDetailViewController, animated: true)
        }
        else
        {
            print("ERROR: out of index didSelectItemAtIndexPath")
        }
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) -> Void
    {
        if mUrlConfigTableViewDatasource.mSectionTypeArray[indexPath.section].mId == UrlSettingSection.URL_SETTING_ABOUT.rawValue
        {
            self.navigationController?.pushViewController(mAboutViewController, animated: true)
        }
        else
        {
            mUrlConfigTableViewDatasource.updateSelection(indexPath, tableView: tableView)
            mUrlConfigTableView.reloadData()
            refreshCollectionView()
        }
    }

    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        refreshCollectionView()
    }
    
    
    func refreshCollectionView() -> Void
    {
        let url = BASE_URL + API_VERSION + GALLERY_MODULE_NAME + mUrlConfigTableViewDatasource.getUrlString()
        
        mLoadingIndicator.startAnimating()
        
        mImageCollectionDatasource.refresh(url)
        { (code) in
            switch code
            {
            case .NORMAL:
                self.performSelectorOnMainThread(#selector(MasterViewController.reloadCollection), withObject: nil, waitUntilDone: true)
                
            case .DOWNLOAD_ERROR:
                self.showFailed("Connection Timeout")
                
            case .INVALID_JSON_DATA:
                self.showFailed("Invalid data format")
                
            case .INVALID_URL:
                self.showFailed("Invalid url")
            }
        }
    }
    
    
    func showFailed(content: String) -> Void
    {
        let alert = UIAlertController(title: "Error", message: content, preferredStyle: .Alert)
        let alertAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alert.addAction(alertAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    func reloadCollection() -> Void
    {
        mLoadingIndicator.stopAnimating()
        mImageCollectionView.reloadData()
    }

    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}

