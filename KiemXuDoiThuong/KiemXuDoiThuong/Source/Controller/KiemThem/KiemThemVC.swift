//
//  KiemThemVC.swift
//  KiemXuDoiThuong
//
//  Created by Doan Dat on 8/12/16.
//  Copyright © 2016 datdv. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper

class KiemThemVC: BaseViewController, AdColonyAdDelegate {

    var checkInitPollFish:Bool = false
    
    @IBOutlet weak var btnPollFish: UIButton!
    
    @IBOutlet weak var btnTrialpay: UIButton!
    
    @IBOutlet weak var btnAdcolony: UIButton!
    
    var offerWallEvent:TrialpayEvent?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if self.navigationController != nil
        {
            self.showMenuButtonNavigationBar()
        }
        
        self.configButton()
        
        //Adconoly
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(KiemThemVC.addObservers), name: UIApplicationWillEnterForegroundNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(KiemThemVC.removeObservers), name: UIApplicationDidEnterBackgroundNotification, object: nil)
        self.addObservers()

    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle
    {
        return UIStatusBarStyle.LightContent
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask
    {
        return UIInterfaceOrientationMask.All
    }
    
    override func shouldAutorotate() -> Bool
    {
        return true
    }

    override func viewWillAppear(animated: Bool)
    {
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(KiemThemVC.pollfishNotAvailable) , name:
            "PollfishSurveyNotAvailable", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(KiemThemVC.pollfishReceived) , name:
            "PollfishSurveyReceived", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(KiemThemVC.pollfishOpened) , name:
            "PollfishOpened", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(KiemThemVC.pollfishClosed) , name:
            "PollfishClosed", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(KiemThemVC.pollfishUsernotEligible) , name:
            "PollfishUserNotEligible", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(KiemThemVC.pollfishCompleted) , name:
            "PollfishSurveyCompleted", object: nil)
        
//        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(KiemThemVC.rotateApp) , name:
//            UIDeviceOrientationDidChangeNotification, object: nil)
        
        //Hide PollFish
        if (AppDelegate.pollfish_enable != nil && AppDelegate.pollfish_enable!)
        {
            self.btnPollFish.hidden = false
        }
        else
        {
            self.btnPollFish.hidden = true
        }
        
        //btnTrialpay
        if (AppDelegate.trialpay_enable != nil && AppDelegate.trialpay_enable!)
        {
            self.btnTrialpay.hidden = false
        }
        else
        {
            self.btnTrialpay.hidden = true
        }
        
        //adcolony_enable
        if (AppDelegate.adcolony_enable != nil && AppDelegate.adcolony_enable!)
        {
            self.btnAdcolony.hidden = false
        }
        else
        {
            self.btnAdcolony.hidden = true
        }
        
        offerWallEvent = TrialpayEvent(name: "OfferWall", info: nil)

        offerWallEvent?.onStatusChange = {(event: TrialpayEvent?, status: TPEventStatus) -> Void in
            print("OFFERWALL STATUS CHANGED TO \(status)")
        }
        
    }
    
    override func viewWillDisappear(animated:Bool) {
        super.viewWillDisappear(animated)
        print("viewWillDisappear()")
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func addObservers()
    {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(KiemThemVC.updateCurrencyBalance), name: Constants.currencyBalanceChange, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(KiemThemVC.zoneReady), name: Constants.zoneReady, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(KiemThemVC.zoneOff), name: Constants.zoneOff, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(KiemThemVC.zoneLoading), name: Constants.zoneLoading, object: nil)
    }
    
    func removeObservers()
    {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: Constants.zoneLoading, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: Constants.zoneOff, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: Constants.zoneReady, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: Constants.currencyBalanceChange, object: nil)
    }
    
    func zoneReady()
    {
        
    }
    
    func zoneOff()
    {
        
    }
    
    func zoneLoading()
    {
        
    }
    
    
    func updateCurrencyBalance()
    {
        //Get currency balance from persistent storage and display it
        if let wrappedBalance = NSUserDefaults.standardUserDefaults().objectForKey(Constants.currencyBalance) as! NSNumber? {
            
        } else {
            
        }
    }

    
    //MARK: Private method

    func configButton()
    {
        self.btnAdcolony.setShadowHidden(false)
        self.btnPollFish.setShadowHidden(false)
        self.btnTrialpay.setShadowHidden(false)
        
    }
    

    //MARK: - POLLFISH
    
    func pollfishNotAvailable() {
        print("pollfishNotAvailable")
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        appDelegate.hideLoading()
        

//        loggingLabel.text="Pollfish - Survey Not Available"
    }
    
    func pollfishReceived() {
        print("pollfishReceived")
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        appDelegate.hideLoading()

//        loggingLabel.text="Pollfish - Survey Received"
    }
    
    func pollfishOpened() {
        print("pollfishOpened")
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        appDelegate.hideLoading()

//        loggingLabel.text="Pollfish - Pollfish Panel Opened"
    }
    
    func pollfishClosed() {
        print("pollfishClosed")
        
//        loggingLabel.text="Pollfish - Pollfish Panel Closed"
    }
    
    func pollfishUsernotEligible() {
        print("pollfishUsernotEligible")
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        appDelegate.hideLoading()

//        loggingLabel.text="Pollfish - User Not Eligible"
    }
    
    func pollfishCompleted() {
        print("pollfishCompleted")
        
        self.callAddMoreCoin("100", work_type: kStrWorkTypePollFish, data: "Completed PollFish Survey")
    }
    //MARK: End Pollfish
    
   //MARK: IBAction
    
    @IBAction func actionPollfish(sender: AnyObject)
    {
        if (AppDelegate.pollfish_id != nil)
        {
            if !self.checkInitPollFish
            {
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                
                appDelegate.showLoading()
                

                Pollfish.initAtPosition( Int32(PollfishPosition.PollFishPositionMiddleRight.rawValue), withPadding: 0, andDeveloperKey: AppDelegate.pollfish_id, andDebuggable: true, andCustomMode: false)
                
                self.checkInitPollFish = true
            }
            
            Pollfish.show();
        }
        else
        {
            print("don't not pollfishId")
        }
    }

    @IBAction func actionTrialpay(sender: AnyObject)
    {
        offerWallEvent?.fire()

    }
    
    @IBAction func actionAdcolony(sender: AnyObject)
    {
        //AdColony.playVideoAdForZone("vzf8fb4670a60e4a139d01b5", withDelegate: nil)
//        AdColony.playVideoAdForZone("vzf8fb4670a60e4a139d01b5", withDelegate: self, withV4VCPrePopup: true, andV4VCPostPopup: true)
//        AdColony.playVideoAdForZone(AppDelegate.adcolony_zone_id ?? "", withDelegate: nil, withV4VCPrePopup: true, andV4VCPostPopup: true)

        AdColony.playVideoAdForZone(Constants.adcolonyZoneID, withDelegate: self, withV4VCPrePopup: true, andV4VCPostPopup: true)


    }
    
    func onAdColonyAdAttemptFinished(shown: Bool, inZone zoneID: String)
    {
        if !shown && AdColony.zoneStatusForZone(Constants.adcolonyZoneID) != ADCOLONY_ZONE_STATUS.ACTIVE {
//        if !shown && AdColony.zoneStatusForZone(AppDelegate.adcolony_zone_id ?? "") != ADCOLONY_ZONE_STATUS.ACTIVE {
            self.zoneLoading()
        } else if !shown {
            self.zoneReady()
        }
    }
    
    
    @IBAction func actionInviteFriends(sender: AnyObject)
    {
        let prefs = NSUserDefaults.standardUserDefaults()
        
        guard let referralCode = prefs.stringForKey(kStrReferralCode) else {
            print("kStrReferralCode not found")
            return
        }
        
        let popUp = InviteFriendsView(frame: CGRectMake(0, 70, 300, 300),referralCode: referralCode)
        popUp.show()

    }
    
    //MARK: - Call Api AddMoreCoin
    func callAddMoreCoin(add_coin:String, work_type:String, data:String)
    {
        let prefs = NSUserDefaults.standardUserDefaults()
        
        guard let userID = prefs.stringForKey(kStrUserId) else {
            print("UserId not found")
            return
        }
        
        let addMoreCoinInputData = AddMoreCoinInputData()
        addMoreCoinInputData.add_coin = add_coin ?? "1"
        addMoreCoinInputData.work_type = work_type ?? ""
        addMoreCoinInputData.data = data ?? ""
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        appDelegate.showLoading()
        
        APIClient.sharedInstance
        
        APIClient.sharedInstance.callAddMoreCoin(addMoreCoinInputData, user_id: userID, completion: {
            [weak self] (result) in
            
            if let strongSelf = self
            {
                
            }
            
            
            print("a:\(result)")
            if let resultString = result
            {
                let userData = Mapper<AddMoreCoinResult>().map(resultString)
                
                if let strongSelf = self
                {
                    if ((userData?.account?.balance) != nil)
                    {
                        let userDefaults = NSUserDefaults.standardUserDefaults()
                        
                        userDefaults.setValue(userData?.account?.balance, forKey: kStrbalance)
                        NSNotificationCenter.defaultCenter().postNotificationName(kNotificationCenterChangeCoin, object: nil)
                        
                        let alert = UIAlertController(title: "EarnMoney", message: "You added coin", preferredStyle: UIAlertControllerStyle.Alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                        
                        self!.presentViewController(alert, animated: true, completion: nil)

                    }

                    
//                    strongSelf.hideLoading()
                    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    
                    appDelegate.hideLoading()

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
            
            })
    }

}
