//
//  PaymentHistoryVC.swift
//  KiemXuDoiThuong
//
//  Created by Doan Dat on 9/4/16.
//  Copyright © 2016 datdv. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper

class PaymentHistoryVC: BaseViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tbPaymentHistory: UITableView!
    
    var isHideNavigationBar:Bool?
    
    var pHeader : HistoryCollectionCell? = nil
    
    let kHeightHeader : CGFloat = 50.0
    
    var currentCellOffsetX:CGFloat = 0.0
    
    var arrPaymentHistory : [DataPaymentHistoryResult]? = []
    
    let kWDate:CGFloat          = 200.0
    let kWContent:CGFloat       = 240.0
    let kWButtonReport:CGFloat  = 80.0

    let arrTitle = ["Date","Content", "Report"]


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.setupTableView()
        
        if (self.isHideNavigationBar != nil && self.isHideNavigationBar!)
        {
            self.showBackButtonNavigationBarTypePop()
            
            self.navigationController?.navigationBarHidden = false
        }
        else
        {
            self.configLeftBarButton()
        }

    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.getPaymentHistory()
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        
        if (self.isHideNavigationBar != nil && self.isHideNavigationBar!)
        {
            self.navigationController?.navigationBarHidden = true
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Private method
    
    func setupTableView()
    {
        self.tbPaymentHistory.delegate          = self
        self.tbPaymentHistory.dataSource        = self
        self.tbPaymentHistory.allowsSelection   = false
        self.tbPaymentHistory.separatorStyle    = UITableViewCellSeparatorStyle.None
    
        let nib = UINib(nibName: String(HistoryCollectionCell), bundle: nil)
        self.tbPaymentHistory.registerNib(nib, forCellReuseIdentifier: String(HistoryCollectionCell))
    }
    
    // MARK: - tableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.arrPaymentHistory != nil) ? self.arrPaymentHistory!.count : 0
//        return 3 //this Test
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let pCell = tableView.dequeueReusableCellWithIdentifier(String(HistoryCollectionCell)) as! HistoryCollectionCell
        
        self.addDataForInforCell(pCell, indexPath: indexPath)
        
        pCell.updateOffsetX = {
            [weak self] (offsetX : CGFloat) -> Void  in
            
            if let strongSelf = self
            {
                strongSelf.currentCellOffsetX = offsetX;
                
                let arrVisibleCell = strongSelf.tbPaymentHistory.visibleCells as! [HistoryCollectionCell]
                
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
                    return CGSizeMake(strongSelf.kWContent, CGRectGetHeight(pCell.frame))
                }
                if indexPath.row == 2
                {
                    return CGSizeMake(strongSelf.kWButtonReport, CGRectGetHeight(pCell.frame))
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
                
                let arrVisibleCell = strongSelf.tbPaymentHistory.visibleCells as! [HistoryCollectionCell]
                
                for historyCollectionCell1 in arrVisibleCell {
                    historyCollectionCell1.collectionView.contentOffset = CGPointMake(strongSelf.currentCellOffsetX, strongSelf.pHeader!.collectionView.contentOffset.y)
                }
                
            }
        }
        
        pHeader?.showButton = false
        
        pHeader!.configLayoutCollectionCell = {
            [weak self] (indexPath : NSIndexPath) -> CGSize  in
            if let strongSelf = self {
                if indexPath.row == 0
                {
                    return CGSizeMake(strongSelf.kWDate, strongSelf.kHeightHeader)
                }
                if indexPath.row == 1
                {
                    return CGSizeMake(strongSelf.kWContent, strongSelf.kHeightHeader)
                }
                if indexPath.row == 2
                {
                    return CGSizeMake(strongSelf.kWButtonReport, strongSelf.kHeightHeader)
                }
            }
            
            return CGSizeMake(100, 50)

        }
        
        return pHeader!
    }


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
        
        let pHistory = self.arrPaymentHistory![indexPath.row]

        let content = "\(pHistory.payment_type ?? "") + \(pHistory.currency ?? "") + \(pHistory.amount ?? "") + \(pHistory.minus_coin ?? "")"
        
        pCell.textContents = [pHistory.date ?? "", content]
        
        pCell.trans_id = pHistory.trans_id
        
        pCell.showButton = true
        
        pCell.indexPath = indexPath
        
        pCell.lbCount.text = "\(indexPath.row + 1)"

        pCell.collectionView.contentOffset.x = self.currentCellOffsetX
        

        //This test
//        pCell.textContents = ["21:21 PM", "Content ablc"]
//        
//        pCell.trans_id = "123"
//        
//        pCell.showButton = true
//        
//        pCell.indexPath = indexPath
//        
//        pCell.lbCount.text = "\(indexPath.row + 1)"

        
    }

    
    
    //MARK - Call Api getPaymentHistory
    func getPaymentHistory()
    {
        let prefs = NSUserDefaults.standardUserDefaults()
        
        guard let userID = prefs.stringForKey(kStrUserId) else {
            print("UserId not found")
            return
        }
        
        let paymentHistoryInputData = GetPaymentHistoryInputData()
        
        
//        self.showLoading()
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        appDelegate.showLoading()

        
        APIClient.sharedInstance
        
        APIClient.sharedInstance.callGetPaymentHistory(paymentHistoryInputData, user_id: userID) {
            [weak self] (result) in
            
            print("a:\(result)")
            if let resultString = result
            {
                let pData = Mapper<GetPaymentHistoryResult>().map(resultString)
                
                if let strongSelf = self
                {
                    strongSelf.arrPaymentHistory = pData?.data?.payment_history;
//                    strongSelf.hideLoading()
                    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    
                    appDelegate.hideLoading()

                    strongSelf.tbPaymentHistory.reloadData()
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
