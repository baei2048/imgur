//
//  UrlSettingTableViewDatasource.swift
//  Imgur
//
//  Created by yinzixiong on 5/30/16.
//  Copyright © 2016 yinzixiong. All rights reserved.
//

import UIKit

enum UrlSettingSection : Int
{
    case URL_SETTING_SECTION, URL_SETTING_SORT, URL_SETTING_WINDOW, URL_SETTING_FLAG, URL_SETTING_ABOUT
}

enum SectionSetting : Int
{
    case SECTION_HOT, SECTION_TOP, SECTION_USER
}

enum SortSetting : Int
{
    case SORT_VIRAL, SORT_TOP, SORT_TIME, SORT_RISING
}

enum WindowSetting : Int
{
    case WINDOW_DAY, WINDOW_WEEK, WINDOW_MONTH, WINDOW_YEAR, WINDOW_ALL
}

struct OptionObject
{
    var mId : Int = 0
    var mTitle : String = ""
    var mValue : String = ""
}

class UrlSettingTableViewDatasource: NSObject, UITableViewDataSource
{
    var mSectionTypeArray : Array<OptionObject> = []
    var mSectionSettingArray : Array<OptionObject> = []
    var mSortSettingArray : Array<OptionObject> = []
    var mWindowSettingArray : Array<OptionObject> = []
    
    var mUrlSection = ""
    var mUrlSort = ""
    var mUrlWindow = ""
    var mUrlViral = ""
    
    var mSectionSetting = SectionSetting.SECTION_HOT
    var mSortSetting = SortSetting.SORT_VIRAL
    var mWindowSetting = WindowSetting.WINDOW_DAY
    var mIsViral = false
    
    override init()
    {
        super.init()
        
        mSectionTypeArray.append(OptionObject(mId: UrlSettingSection.URL_SETTING_SECTION.rawValue, mTitle: "Section", mValue: ""))
        mSectionTypeArray.append(OptionObject(mId: UrlSettingSection.URL_SETTING_SORT.rawValue, mTitle: "Sort", mValue: ""))
        mSectionTypeArray.append(OptionObject(mId: UrlSettingSection.URL_SETTING_FLAG.rawValue, mTitle: "Flag", mValue: ""))
        mSectionTypeArray.append(OptionObject(mId: UrlSettingSection.URL_SETTING_ABOUT.rawValue, mTitle: "About", mValue: ""))
        
        mSectionSettingArray.append(OptionObject(mId: SectionSetting.SECTION_HOT.rawValue, mTitle: "Hot", mValue: "hot"))
        mSectionSettingArray.append(OptionObject(mId: SectionSetting.SECTION_TOP.rawValue, mTitle: "Top", mValue: "top"))
        mSectionSettingArray.append(OptionObject(mId: SectionSetting.SECTION_USER.rawValue, mTitle: "User", mValue: "user"))
        mUrlSection = mSectionSettingArray[0].mValue
        
        mSortSettingArray.append(OptionObject(mId: SortSetting.SORT_VIRAL.rawValue, mTitle: "Viral", mValue: "viral"))
        mSortSettingArray.append(OptionObject(mId: SortSetting.SORT_TOP.rawValue, mTitle: "Top", mValue: "top"))
        mSortSettingArray.append(OptionObject(mId: SortSetting.SORT_TIME.rawValue, mTitle: "Time", mValue: "time"))
        mUrlSort = mSortSettingArray[0].mValue
        
        mWindowSettingArray.append(OptionObject(mId: WindowSetting.WINDOW_DAY.rawValue, mTitle: "Day", mValue: "day"))
        mWindowSettingArray.append(OptionObject(mId: WindowSetting.WINDOW_WEEK.rawValue, mTitle: "Week", mValue: "week"))
        mWindowSettingArray.append(OptionObject(mId: WindowSetting.WINDOW_MONTH.rawValue, mTitle: "Month", mValue: "month"))
        mWindowSettingArray.append(OptionObject(mId: WindowSetting.WINDOW_YEAR.rawValue, mTitle: "Year", mValue: "year"))
        mWindowSettingArray.append(OptionObject(mId: WindowSetting.WINDOW_ALL.rawValue, mTitle: "All", mValue: "all"))
        mUrlWindow = mWindowSettingArray[0].mValue
    }
    
    
    func updateSelection(indexPath : NSIndexPath, tableView : UITableView) -> Void
    {
        if let sectionType = UrlSettingSection(rawValue: mSectionTypeArray[indexPath.section].mId)
        {
            switch sectionType
            {
            case .URL_SETTING_SECTION:
                if let sectionSetting = SectionSetting(rawValue : mSectionSettingArray[indexPath.row].mId)
                {
                    switch sectionSetting
                    {
                    case .SECTION_HOT:
                        
                        switch mSectionSetting
                        {
                        case .SECTION_TOP:
                            self.setWindowVisibilty(false)
                            
                        case .SECTION_USER:
                            self.setRisingVisibilty(false, table: tableView, indexPath: indexPath)
                            
                        case .SECTION_HOT:
                            print("tap at same selection")
                        }
                        
                    case .SECTION_TOP:
                        
                        switch mSectionSetting
                        {
                        case .SECTION_TOP:
                            print("tap at same selection")
                            
                        case .SECTION_USER:
                            self.setRisingVisibilty(false, table: tableView, indexPath: indexPath)
                            self.setWindowVisibilty(true)
                            
                        case .SECTION_HOT:
                            self.setWindowVisibilty(true)
                        }
                        
                    case .SECTION_USER:
                        
                        switch mSectionSetting
                        {
                        case .SECTION_TOP:
                            self.setWindowVisibilty(false)
                            self.setRisingVisibilty(true, table: tableView, indexPath: indexPath)
                            
                        case .SECTION_USER:
                            print("tap at same selection")
                            
                        case .SECTION_HOT:
                            self.setRisingVisibilty(true, table: tableView, indexPath: indexPath)
                            
                        }
                    }
                    
                    mSectionSetting = sectionSetting
                    mUrlSection = mSectionSettingArray[mSectionSetting.rawValue].mValue
                }
                else
                {
                    assert(false, "undefined SectionSetting enum")
                }
                
            case .URL_SETTING_SORT:
                self.updateSortSelection(indexPath, tableView: tableView)
                
            case .URL_SETTING_WINDOW:
                
                if let windowSetting = WindowSetting(rawValue: mWindowSettingArray[indexPath.row].mId)
                {
                    var cell : UITableViewCell? = tableView.cellForRowAtIndexPath(indexPath)
                    cell?.accessoryType = .Checkmark
                    
                    cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: mWindowSetting.rawValue, inSection: indexPath.section))
                    cell?.accessoryType = .None
                    
                    mWindowSetting = windowSetting
                    mUrlWindow = mWindowSettingArray[mWindowSetting.rawValue].mValue
                }
                else
                {
                    assert(false, "undefined WindowSetting enum")
                }
                
            case .URL_SETTING_FLAG:
                let cell : UITableViewCell? = tableView.cellForRowAtIndexPath(indexPath)
                mIsViral = !mIsViral
                if mIsViral
                {
                    cell?.accessoryType = .Checkmark
                    mUrlViral = "?showViral=true"
                }
                else
                {
                    cell?.accessoryType = .None
                    mUrlViral = ""
                }
                
            case .URL_SETTING_ABOUT:
                print("Shall update nothing")
            }
        }
        else
        {
            assert(false, "undefined UrlSettingSection enum")
        }
    }
    
    
    func getUrlString() -> String
    {
        var urlString = "\(mUrlSection)/\(mUrlSort)/"
        
        if mSectionSetting == SectionSetting.SECTION_TOP
        {
            urlString += "\(mUrlWindow)/"
        }
        
        urlString += "0.json"
        
        if mIsViral
        {
            urlString += mUrlViral
        }
        
        return urlString
    }
    
    
    func updateSortSelection(indexPath : NSIndexPath, tableView : UITableView ) -> Void
    {
        if let sortSetting = SortSetting(rawValue: mSortSettingArray[indexPath.row].mId)
        {
            var cell : UITableViewCell? = tableView.cellForRowAtIndexPath(indexPath)
            cell?.accessoryType = .Checkmark
            
            cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: mSortSetting.rawValue, inSection: indexPath.section))
            cell?.accessoryType = .None
            
            mSortSetting = sortSetting
            
            mUrlSort = mSortSettingArray[mSortSetting.rawValue].mValue
        }
        else
        {
            assert(false, "undefined SortSetting enum")
        }
    }
    
    
    func setRisingVisibilty(isVisible : Bool, table : UITableView, indexPath : NSIndexPath) -> Void
    {
        if isVisible
        {
            mSortSettingArray.append(OptionObject(mId: SortSetting.SORT_RISING.rawValue, mTitle: "Rising", mValue: "rising"))
        }
        else
        {
            mSortSettingArray.removeLast()
            
            if mSortSetting == SortSetting.SORT_RISING
            {
                self.updateSortSelection(NSIndexPath(forRow:0, inSection: indexPath.section), tableView: table)
            }
        }
    }
    
    
    func setWindowVisibilty(isVisible : Bool) -> Void
    {
        if isVisible
        {
            mSectionTypeArray.insert(OptionObject(mId: UrlSettingSection.URL_SETTING_WINDOW.rawValue, mTitle: "Window", mValue: ""), atIndex: 1)
        }
        else
        {
            mSectionTypeArray.removeAtIndex(1)
        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell\(indexPath.section)#\(indexPath.row)")
        
        if cell == nil
        {
            cell = UITableViewCell(style:.Default, reuseIdentifier:"cell")
            cell?.selectionStyle = .None
        }
        
        if let sectionType = UrlSettingSection(rawValue: mSectionTypeArray[indexPath.section].mId)
        {
            switch sectionType
            {
            case .URL_SETTING_SECTION:
                if indexPath.row < mSectionTypeArray.count
                {
                    cell?.textLabel?.text = mSectionSettingArray[indexPath.row].mTitle
                    
                    if indexPath.row == mSectionSetting.rawValue
                    {
                        cell?.accessoryType = .Checkmark
                    }
                    else
                    {
                        cell?.accessoryType = .None
                    }
                }
                else
                {
                    print("ERROR: out of index mSectionTypeArray")
                }
                
            case .URL_SETTING_WINDOW:
                if indexPath.row < mWindowSettingArray.count
                {
                    cell?.textLabel?.text = mWindowSettingArray[indexPath.row].mTitle
                    if indexPath.row == mWindowSetting.rawValue
                    {
                        cell?.accessoryType = .Checkmark
                    }
                    else
                    {
                        cell?.accessoryType = .None
                    }
                }
                else
                {
                    print("ERROR: out of index mWindowSettingArray")
                }
                
            case .URL_SETTING_SORT:
                if indexPath.row < mSortSettingArray.count
                {
                    cell?.textLabel?.text = mSortSettingArray[indexPath.row].mTitle
                    if indexPath.row == mSortSetting.rawValue
                    {
                        cell?.accessoryType = .Checkmark
                    }
                    else
                    {
                        cell?.accessoryType = .None
                    }
                }
                else
                {
                    print("ERROR: out of index mSortSettingArray")
                }
                
            case .URL_SETTING_FLAG:
                cell?.textLabel?.text = "Viral"
                if mIsViral
                {
                    cell?.accessoryType = .Checkmark
                }
                else
                {
                    cell?.accessoryType = .None
                }
                
            case .URL_SETTING_ABOUT:
                cell?.textLabel?.text = "About"
            }
        }
        else
        {
            assert(false, "undefined UrlSettingSection enum")
        }
        
        return cell!
    }
    
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        var title = ""
        
        if section < mSectionTypeArray.count
        {
            title = mSectionTypeArray[section].mTitle
        }
        else
        {
            print("ERROR: out of index mSortSettingArray in titleForHeaderInSection")
        }
        
        return title
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return mSectionTypeArray.count
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        var numRow = 1
        
        if let sectionType = UrlSettingSection(rawValue: mSectionTypeArray[section].mId)
        {
            switch sectionType
            {
            case .URL_SETTING_SECTION:
                numRow = mSectionSettingArray.count
                
            case .URL_SETTING_SORT:
                numRow = mSortSettingArray.count
                
            case .URL_SETTING_WINDOW:
                numRow = mWindowSettingArray.count
                
            case .URL_SETTING_FLAG, .URL_SETTING_ABOUT:
                numRow = 1
            }
        }
        else
        {
            assert(false, "undefined UrlSettingSection enum")
        }
        
        return numRow
    }
}
