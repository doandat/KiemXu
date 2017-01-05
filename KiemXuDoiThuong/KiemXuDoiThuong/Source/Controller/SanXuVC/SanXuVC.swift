//
//  SanXuVC.swift
//  KiemXuDoiThuong
//
//  Created by Doan Dat on 8/11/16.
//  Copyright © 2016 datdv. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper

class SanXuVC: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tbSanXu: UITableView!
    
    var arrDataSystemAds : [DataSystemAdsResult]? = [];
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if self.navigationController != nil
        {
            self.showMenuButtonNavigationBar()
        }
        
        setupTableView()

        setupData()
        
        addLoadMoreAndRefreshEvent()
        

    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setupData()
    {
        let prefs = NSUserDefaults.standardUserDefaults()
        
        if let userID = prefs.stringForKey(kStrUserId)
        {
            if AppDelegate.session_id == nil
            {
                createUser(userID)
            }
            else
            {
                getSystemAds()
            }
        }
    }
    
    
    // MARK: - Private method
    
    func setupTableView()
    {
        self.tbSanXu.delegate     = self;
        self.tbSanXu.dataSource   = self;
        self.tbSanXu.separatorStyle = UITableViewCellSeparatorStyle.None
        
        let nib = UINib(nibName: String(ShowAppCell), bundle: nil)
        self.tbSanXu.registerNib(nib, forCellReuseIdentifier: String(ShowAppCell))
    }
    
    func addLoadMoreAndRefreshEvent()
    {
        self.tbSanXu.addPullToRefreshWithActionHandler(
            {[unowned self]() -> Void in
            self.reloadSystemAds()
        })
    }
    
    
    // MARK: - tableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let countSystemAds = (self.arrDataSystemAds != nil) ? self.arrDataSystemAds!.count : 0
        
        return countSystemAds
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let pCell = tableView.dequeueReusableCellWithIdentifier(String(ShowAppCell)) as! ShowAppCell
        
        if indexPath.row <= self.arrDataSystemAds?.count
        {
            let systemAds = self.arrDataSystemAds![indexPath.row]
            pCell.lbTitleApp.text = systemAds.app_name
            pCell.lbCoin.text = systemAds.coin
            pCell.imv_appIcon.sd_setImageWithURL(NSURL(string: systemAds.app_icon_url!), placeholderImage: UIImage(named: "img_avatar_blank"))
            pCell.lbDes.text  = systemAds.app_description

        }

        return pCell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("You selected cell #\(indexPath.row)!")
        
        if indexPath.row <= self.arrDataSystemAds?.count
        {
            let systemAds = self.arrDataSystemAds![indexPath.row]
            
            let popUp = PopupInstallAppView(frame: CGRectMake(0, 70, 300, 300), systemAds: systemAds)
            popUp.show()
        }

    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    //MARK: - Call Api GetSystemAds
    func getSystemAds()
    {
        self.arrDataSystemAds?.removeAll()
        
        let prefs = NSUserDefaults.standardUserDefaults()
        
        guard let userID = prefs.stringForKey(kStrUserId) else {
            print("UserId not found")
            return
        }
        
        let systemAdsInputData = SystemAdsInputData()
        systemAdsInputData.country = prefs.stringForKey(kStrCountryCode)
        systemAdsInputData.city = prefs.stringForKey(kStrCity)
        systemAdsInputData.language = NSLocale.preferredLanguages()[0] ?? ""
//        systemAdsInputData.os = "iOS " + UIDevice.currentDevice().systemVersion ?? ""

        systemAdsInputData.os = "iOS"

        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        appDelegate.showLoading()

        APIClient.sharedInstance

        APIClient.sharedInstance.getSystemAds(systemAdsInputData, user_id: userID, completion:{ [weak self] (result) in
            
            if let strongSelf = self
            {
                strongSelf.tbSanXu.pullToRefreshView.stopAnimating()
                strongSelf.tbSanXu.showsInfiniteScrolling = true
            }

            
            print("a:\(result)")
            if let resultString = result
            {
                let userData = Mapper<SystemAdsResult>().map(resultString)
                
                if let strongSelf = self
                {
                    strongSelf.arrDataSystemAds = userData?.data
//                    strongSelf.hideLoading()
                    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    
                    appDelegate.hideLoading()

                    strongSelf.tbSanXu.reloadData()
                }
            }
            else
            {
                if let strongSelf = self
                {
                    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    
                    appDelegate.hideLoading()

                }
            }
            
        })
    }
    
    
    //MARK: Reload systemads
    func reloadSystemAds()
    {
        self.arrDataSystemAds?.removeAll()
        
        let prefs = NSUserDefaults.standardUserDefaults()
        
        guard let userID = prefs.stringForKey(kStrUserId) else {
            print("UserId not found")
            return
        }

        if AppDelegate.session_id != nil {
            self.getSystemAds()
        }
        else
        {
            self.createUser(userID)
        }
    }
    
    
    //MARK: Call API
    func createUser(userID: String?)
    {
        let prefs = NSUserDefaults.standardUserDefaults()
        
        var pUserID:String? = ""
        var url_avatar: String? = ""
        if let userID = prefs.stringForKey(kStrThirdPartyId)
        {
            url_avatar = "https://graph.facebook.com/"+userID+"picture?type=large"
            pUserID = userID
        }
        let createAccountInputData = CreateUserInputData()
        createAccountInputData.user_id  = userID ?? ""
        createAccountInputData.username = prefs.stringForKey(kStrUserName)
        createAccountInputData.full_name = prefs.stringForKey(kStrFullName)
        createAccountInputData.country = prefs.stringForKey(kStrCountry) ?? ""
        createAccountInputData.city = prefs.stringForKey(kStrCity) ?? ""
        createAccountInputData.language = NSLocale.preferredLanguages()[0] ?? ""
        createAccountInputData.avatar_url = url_avatar
        createAccountInputData.desCription = "khong co gi ahihi"
        createAccountInputData.email = prefs.stringForKey(kStrEmail)
        createAccountInputData.phone = ""
        createAccountInputData.os = "ios"
        createAccountInputData.devices_type_using = UIDevice.currentDevice().localizedModel
        createAccountInputData.sex = prefs.stringForKey(kStrSex)
        createAccountInputData.age = prefs.stringForKey(kStrAge)
        createAccountInputData.fiends_list = ""
        createAccountInputData.third_party_id = pUserID
        createAccountInputData.device_id = UIDevice.currentDevice().identifierForVendor!.UUIDString

        createAccountInputData.device_id = deviceID

        
        APIClient.sharedInstance
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        appDelegate.showLoading()
        
        APIClient.sharedInstance.createAccountUsingFacebook(createAccountInputData) {
            
            [weak self] (result) in
            print("a:\(result)")
            
            if let strongSelf = self
            {
                strongSelf.tbSanXu.pullToRefreshView.stopAnimating()
                strongSelf.tbSanXu.showsInfiniteScrolling = true
            }
            
            if let resultString = result
            {
                let userData = Mapper<AccountResult>().map(resultString)
                if userData?.status != "0"
                {
                    //error 
                    if let strongSelf = self
                    {
                        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                        
                        appDelegate.hideLoading()

                        let alert = UIAlertController(title: "Kiem Tien", message: userData?.message ?? "", preferredStyle: UIAlertControllerStyle.Alert)
                        
                        // add an action (button)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                        
                        // show the alert
                        strongSelf.presentViewController(alert, animated: true, completion: nil)

                    }
                }
                else
                {
                    AppDelegate.session_id = userData?.session_id
                    
                    //AppConfig
                    
                    AppDelegate.startapp_enable 						=  userData?.data?.app_config?.startapp_enable
                    AppDelegate.startapp_id 							=  userData?.data?.app_config?.startapp_id
                    AppDelegate.startapp_coin_install 					=  userData?.data?.app_config?.startapp_coin_install
                    AppDelegate.appnext_enable 							=  userData?.data?.app_config?.appnext_enable
                    AppDelegate.appnext_id 								=  userData?.data?.app_config?.appnext_id
                    AppDelegate.appnext_coin_install_rate 				=  userData?.data?.app_config?.appnext_coin_install_rate
                    AppDelegate.pollfish_enable 						=  userData?.data?.app_config?.pollfish_enable
                    AppDelegate.pollfish_id 							=  userData?.data?.app_config?.pollfish_id
                    AppDelegate.pollfish_coin_completed_long_survey 	=  userData?.data?.app_config?.pollfish_coin_completed_long_survey
                    AppDelegate.pollfish_coin_completed_short_survey 	=  userData?.data?.app_config?.pollfish_coin_completed_short_survey
                    AppDelegate.pollfish_coin_rate 						=  userData?.data?.app_config?.pollfish_coin_rate
                    AppDelegate.trialpay_enable 						=  userData?.data?.app_config?.trialpay_enable
                    AppDelegate.trialpay_id 							=  userData?.data?.app_config?.trialpay_id
                    AppDelegate.trialpay_coin_rate 						=  userData?.data?.app_config?.trialpay_coin_rate
                    AppDelegate.adcolony_enable 						=  userData?.data?.app_config?.adcolony_enable
                    AppDelegate.adcolony_app_id 						=  userData?.data?.app_config?.adcolony_app_id
                    AppDelegate.adcolony_zone_id 						=  userData?.data?.app_config?.adcolony_zone_id
                    AppDelegate.adcolony_coin_rate 						=  userData?.data?.app_config?.adcolony_coin_rate
                    AppDelegate.adcolony_received_video_coin 			=  userData?.data?.app_config?.adcolony_received_video_coin
                    AppDelegate.paypal_payment_enable 					=  userData?.data?.app_config?.paypal_payment_enable
                    AppDelegate.recharge_option_values 					=  userData?.data?.app_config?.recharge_option_values
                    AppDelegate.paypal_payment_opion_values 			=  userData?.data?.app_config?.paypal_payment_opion_values
                    AppDelegate.exchange_rate_usd_coin 					=  userData?.data?.app_config?.exchange_rate_usd_coin
                   
                    
                    //Rechare phone
                    
                    AppDelegate.arrRechargeValue.removeAll()
                    AppDelegate.arrRechargeKey.removeAll()

                    if let arrReChargeOption = AppDelegate.recharge_option_values?.componentsSeparatedByString(",")
                    {
                        for value in arrReChargeOption
                        {
                            AppDelegate.arrRechargeValue.append(value)
                            AppDelegate.arrRechargeKey.append("\(value)Rs")
                        }
                    }

                    
                    //Paypal
                    
                    AppDelegate.arrPaypalPaymentKey.removeAll()
                    AppDelegate.arrPaypalPaymentValue.removeAll()

                    if let arrReChargeOption = AppDelegate.paypal_payment_opion_values?.componentsSeparatedByString(",")
                    {
                        for value in arrReChargeOption
                        {
                            AppDelegate.arrPaypalPaymentValue.append(value)
                            AppDelegate.arrPaypalPaymentKey.append("\(value)Rs")
                        }
                    }
                    
                    
                    
                    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    appDelegate.setupAdColony()

                    
                    let userDefaults = NSUserDefaults.standardUserDefaults()
                    
                    userDefaults.setValue(userData?.data?.user_id, forKey: kStrUserId)
                    userDefaults.setValue(userData?.data?.referral_code, forKey: kStrReferralCode)
                    userDefaults.setValue(userData?.data?.account?.balance, forKey: kStrbalance)
                    
                    print(userData?.data)
                    
                    if let strongSelf = self
                    {                        
                        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                        
                        appDelegate.hideLoading()

                        strongSelf.getSystemAds()
                    }

                }
                
            }
            else
            {
                if let strongSelf = self
                {
                    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    
                    appDelegate.hideLoading()

                }
            }
        }
    }


    
}
