//
//  InstalledHistoryVC.swift
//  KiemXuDoiThuong
//
//  Created by DatDV on 9/6/16.
//  Copyright © 2016 datdv. All rights reserved.
//
import UIKit
import Alamofire
import ObjectMapper

class InstalledHistoryVC: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tbInstalledHistory: UITableView!
    
    
    
    var pHeader : HistoryCollectionCell? = nil
    
    let kHeightHeader : CGFloat = 50.0
    
    var currentCellOffsetX:CGFloat = 0.0
    
    var arrInstallHistory : [DataInstallAppsHistoryResult]? = []
    
    let kWDate:CGFloat      = 180.0
    let kWPackage:CGFloat   = 240.0
    let kWCoin:CGFloat      = 100.0

    let arrTitle = ["Date","Package","Coin"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.setupTableView()
        
        self.showBackButtonNavigationBarTypePop()
        
        self.navigationController?.navigationBarHidden = false
        
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.getInstallHistory()
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        
        self.navigationController?.navigationBarHidden = true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Private method
    
    func setupTableView()
    {
        self.tbInstalledHistory.delegate          = self
        self.tbInstalledHistory.dataSource        = self
        self.tbInstalledHistory.allowsSelection   = false
        self.tbInstalledHistory.separatorStyle    = UITableViewCellSeparatorStyle.None
        
        let nib = UINib(nibName: String(HistoryCollectionCell), bundle: nil)
        self.tbInstalledHistory.registerNib(nib, forCellReuseIdentifier: String(HistoryCollectionCell))
    }
    
    // MARK: - tableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (self.arrInstallHistory != nil) ? self.arrInstallHistory!.count : 0
//        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let pCell = tableView.dequeueReusableCellWithIdentifier(String(HistoryCollectionCell)) as! HistoryCollectionCell
        
        self.addDataForInforCell(pCell, indexPath: indexPath)
        
        pCell.updateOffsetX = {
            [weak self] (offsetX : CGFloat) -> Void  in
            
            if let strongSelf = self
            {
                strongSelf.currentCellOffsetX = offsetX;
                
                let arrVisibleCell = strongSelf.tbInstalledHistory.visibleCells as! [HistoryCollectionCell]
                
                for historyCollectionCell1 in arrVisibleCell {
                    historyCollectionCell1.collectionView.contentOffset = CGPointMake(strongSelf.currentCellOffsetX, pCell.collectionView.contentOffset.y)
                }
                
                strongSelf.pHeader?.collectionView.contentOffset = CGPointMake(strongSelf.currentCellOffsetX, pCell.collectionView.contentOffset.y)
                
            }
        }
        
        
        pCell.configLayoutCollectionCell = {
            [weak self] (indexPath : NSIndexPath) -> CGSize  in
            if let strongSelf = self {
                if indexPath.row == 0
                {
                    return CGSizeMake(strongSelf.kWDate, CGRectGetHeight(pCell.frame))
                    
                }
                if indexPath.row == 1
                {
                    return CGSizeMake(strongSelf.kWPackage, CGRectGetHeight(pCell.frame))
                }
                if indexPath.row == 2
                {
                    return CGSizeMake(strongSelf.kWCoin, CGRectGetHeight(pCell.frame))
                }
            }
            
            return CGSizeMake(100, CGRectGetHeight(pCell.frame))
        }
        
        return pCell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        print("You selected cell #\(indexPath.row)!")
        
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        if self.pHeader != nil {
            return pHeader
        }
        
        pHeader = tableView.dequeueReusableCellWithIdentifier(String(HistoryCollectionCell)) as? HistoryCollectionCell
        
        pHeader!.wConstraintViewTitle.constant = 0.0 // hide view title
        
        pHeader!.textContents = arrTitle
        
        pHeader!.lbCount.backgroundColor = UIColor.lightGrayColor()
        pHeader!.titleContainerView.backgroundColor = UIColor.grayColor()
        pHeader!.colorView = UIColor.lightGrayColor()
        
        pHeader!.collectionView.contentOffset.x = self.currentCellOffsetX
        
        pHeader!.updateOffsetX = {
            [weak self] (offsetX : CGFloat) -> Void  in
            
            if let strongSelf = self
            {
                strongSelf.currentCellOffsetX = offsetX;
                
                let arrVisibleCell = strongSelf.tbInstalledHistory.visibleCells as! [HistoryCollectionCell]
                
                for historyCollectionCell1 in arrVisibleCell {
                    historyCollectionCell1.collectionView.contentOffset = CGPointMake(strongSelf.currentCellOffsetX, strongSelf.pHeader!.collectionView.contentOffset.y)
                }
                
            }
        }
        
        
        pHeader!.configLayoutCollectionCell = {
            [weak self] (indexPath : NSIndexPath) -> CGSize  in
            if let strongSelf = self {
                if indexPath.row == 0
                {
                    return CGSizeMake(strongSelf.kWDate, strongSelf.kHeightHeader)
                }
                if indexPath.row == 1
                {
                    return CGSizeMake(strongSelf.kWPackage, strongSelf.kHeightHeader)
                }
                if indexPath.row == 2
                {
                    return CGSizeMake(strongSelf.kWCoin, strongSelf.kHeightHeader)
                }
                
            }
            
            return CGSizeMake(100, 50)
            
        }
        
        return pHeader!
    }
    
    //    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    //        return UITableViewAutomaticDimension
    //    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 50.0
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return kHeightHeader
    }
    
    
    func addDataForInforCell(pCell :HistoryCollectionCell, indexPath: NSIndexPath)
    {
        pCell.wConstraintViewTitle.constant = 0.0 // hide view title
        
        let pHistory = self.arrInstallHistory![indexPath.row]

        
        pCell.textContents = [pHistory.date ?? "", pHistory.app_name ?? "", (pHistory.added_coin != nil) ? "+\(pHistory.added_coin!)": ""]
        
        pCell.lbCount.text = "\(indexPath.row + 1)"
        
        pCell.collectionView.contentOffset.x = self.currentCellOffsetX
    }

    //MARK - Call Api GetSystemAds
    func getInstallHistory()
    {
        let prefs = NSUserDefaults.standardUserDefaults()
        
        guard let userID = prefs.stringForKey(kStrUserId) else {
            print("UserId not found")
            return
        }
        
        let installAppsHistoryInputData = GetInstallAppsHistoryInputData()
        
        
//        self.showLoading()
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        appDelegate.showLoading()

        
        APIClient.sharedInstance
        
        APIClient.sharedInstance.callGetInstallAppsHistory(installAppsHistoryInputData, user_id: userID) { 
            [weak self] (result) in
            
            print("a:\(result)")
            if let resultString = result
            {
                let pData = Mapper<GetInstallAppsHistoryResult>().map(resultString)
                
                if let strongSelf = self
                {
                    strongSelf.arrInstallHistory = pData?.data?.install_apps_history;
//                    strongSelf.hideLoading()
                    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    
                    appDelegate.hideLoading()

                    strongSelf.tbInstalledHistory.reloadData()
                }
            }
            else
            {
                if let strongSelf = self
                {
//                    strongSelf.hideLoading()
                    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    
                    appDelegate.hideLoading()

                }
            }
            
        }
    }
    
    
    
}