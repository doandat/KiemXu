//
//  MoreVC.swift
//  KiemXuDoiThuong
//
//  Created by Doan Dat on 8/12/16.
//  Copyright © 2016 datdv. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin
import FacebookShare

class MoreVC: BaseViewController,UITableViewDelegate, UITableViewDataSource {

    let arrTitleDisovery: [String] = ["Input Referral code","Invite Friends","Send Feed Back","Payment History", "Get Coin History", "Rating App"]
    
    let arrTitleMoreInfo = ["Instruction", "Contact", "Introduction"]
    
    @IBOutlet weak var img_avatar: UIImageView!
    
    @IBOutlet weak var lbUserName: UILabel!
    
    @IBOutlet weak var tbSideBar: UITableView!
    
    @IBOutlet weak var lbReferralCode: UILabel!
    
    @IBOutlet weak var lbCoin: UILabel!
    
    @IBOutlet weak var lbEmail: UILabel!
    
    
    var showInputReferralCode:Bool = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.setupTableView()
        
        self.loadAvatar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MoreVC.methodOfReceivedNotificationChangeCoin(_:)), name:kNotificationCenterChangeCoin, object: nil)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MoreVC.methodOfReceivedNotificationInputedCode(_:)), name:kNotificationCenterInputedCode, object: nil)

        self.loadCoin()
        
        let prefs = NSUserDefaults.standardUserDefaults()
        
        if prefs.stringForKey(kStrInputedReferralCode) != nil
        {
            showInputReferralCode = true
        }

    }
    
    override func viewWillDisappear(animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    

    func setupTableView()
    {
        self.tbSideBar.delegate     = self
        self.tbSideBar.dataSource   = self
        self.tbSideBar.separatorStyle = .None
        
        
        let nib = UINib(nibName: String(MoreCell), bundle: nil)
        self.tbSideBar.registerNib(nib, forCellReuseIdentifier: String(MoreCell))
    }
    
    func loadAvatar()
    {
        self.img_avatar.clipsToBounds = true
        self.img_avatar.layer.cornerRadius = 30
        
        let prefs = NSUserDefaults.standardUserDefaults()
        
        if let userID = prefs.stringForKey(kStrThirdPartyId)
        {
            let url = NSURL(string:  "https://graph.facebook.com/\(userID)/picture?type=large")
            
            self.img_avatar.sd_setImageWithURL(url, placeholderImage: UIImage(named: "img_avatar_blank"))
        }
        
        self.lbUserName.text = (prefs.stringForKey(kStrUserName)  != nil) ? prefs.stringForKey(kStrUserName):"Guest"

        self.lbEmail.text = (prefs.stringForKey(kStrEmail)  != nil) ? prefs.stringForKey(kStrEmail):""

        
        self.lbReferralCode.text = (prefs.stringForKey(kStrReferralCode)  != nil) ? prefs.stringForKey(kStrReferralCode):""
    }
    
    func loadCoin()
    {
        let prefs = NSUserDefaults.standardUserDefaults()

        self.lbCoin.text = (prefs.stringForKey(kStrbalance)  != nil) ? prefs.stringForKey(kStrbalance):"0"
    }
    
    //MARK: ReceiveNotificationCenter
    
    func methodOfReceivedNotificationChangeCoin(notification: NSNotification){
        //Take Action on Notification Call Api Err
        self.loadCoin()
    }
    
    func methodOfReceivedNotificationInputedCode(notification: NSNotification)
    {
        showInputReferralCode = true
        
        self.tbSideBar.reloadData()
    }

    
    //=============================
    // MARK: - tableViewDataSource
    //=============================

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if section == 0
        {
            return self.arrTitleDisovery.count
        }
        
        return self.arrTitleMoreInfo.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier(String(MoreCell)) as! MoreCell
        
        if showInputReferralCode && indexPath.section == 0 && indexPath.row == 0
        {
            cell.btnImage.setImage(UIImage(), forState: UIControlState.Normal)
            cell.lbTitle.text = ""
            
            return cell
        }
        
        cell.btnImage.setImage(UIImage(named: "icon_share.png"), forState: UIControlState.Normal)
        
        if indexPath.section == 0
        {
            cell.lbTitle.text = self.arrTitleDisovery[indexPath.row]
            
            if(indexPath.row == 0 || indexPath.row == 1)
            {
                cell.lbExtend.text = "(+100 Coin)"
            }
            else
            {
                cell.lbExtend.text = ""
            }
            
        }
        else
        {
            cell.lbTitle.text = self.arrTitleMoreInfo[indexPath.row]
        }
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        print("You selected cell #\(indexPath.row)!")
        if indexPath.section == 0
        {
            if indexPath.row == 0
            {
                self.menuContainerViewController.menuState = MFSideMenuStateClosed

                let popUp = InputReferralCodeView(frame: CGRectMake(0, 70, 300, 179))
                popUp.show()
            }
            else if indexPath.row == 1
            {
                self.menuContainerViewController.menuState = MFSideMenuStateClosed
                
                let inviteFriendsVC = InviteFriendsVC(nibName: nil, bundle: nil)
                
                
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                
                let baseNavigation = appDelegate.navitaion
                
                baseNavigation?.pushViewController(inviteFriendsVC, animated: true)

            }
            else if indexPath.row == 2
            {
                self.menuContainerViewController.menuState = MFSideMenuStateClosed
                
                let feedBackVC = FeedBackVC(nibName: nil, bundle: nil)
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                
                let baseNavigation = appDelegate.navitaion
                
                baseNavigation?.pushViewController(feedBackVC, animated: true)
            }
            else if indexPath.row == 3
            {
                self.menuContainerViewController.menuState = MFSideMenuStateClosed
                
                let paymentHistoryVC = PaymentHistoryVC(nibName: nil, bundle: nil)
                
                paymentHistoryVC.isHideNavigationBar = true
                
                //            let navigation = BaseNavigationController(rootViewController: paymentHistoryVC)
                //
                //            self.presentViewController(navigation, animated: true, completion: nil)
                
                
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                
                //            let baseNavigation = appDelegate.container?.centerViewController as! BaseNavigationController
                let baseNavigation = appDelegate.navitaion
                
                baseNavigation?.pushViewController(paymentHistoryVC, animated: true)
                
            }
                
            else if indexPath.row == 4
            {
                self.menuContainerViewController.menuState = MFSideMenuStateClosed
                
                let installedHistoryVC = InstalledHistoryVC(nibName: nil, bundle: nil)
                
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                
                let baseNavigation = appDelegate.navitaion
                
                baseNavigation?.pushViewController(installedHistoryVC, animated: true)
                
            }

        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if showInputReferralCode && indexPath.section == 0 && indexPath.row == 0
        {
            return 0
        }
        return 50
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 40))
        let label = UILabel(frame: CGRect(x: 20, y: 0, width: tableView.frame.size.width - 20, height: 40))
        label.textAlignment = .Left
        label.font = label.font.fontWithSize(20)
        if section == 0
        {
            label.text = "Discovery"
        }
        else
        {
            label.text = "More information"
        }
        
        label.textColor = UIColor.blackColor()
        
        view.addSubview(label)
        view.backgroundColor = UIColor.whiteColor()
        return view
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }

}
