//
//  GetMoreVC.swift
//  KiemXuDoiThuong
//
//  Created by Doan Dat on 10/24/16.
//  Copyright © 2016 datdv. All rights reserved.
//

import UIKit

class GetMoreVC: BaseViewController,AdColonyAdDelegate, UITableViewDelegate, UITableViewDataSource,NativeXAdEventDelegate, NativeXRewardDelegate {

    @IBOutlet weak var tbGetMore: UITableView!
    
    var checkInitPollFish:Bool = false

    var offerWallEvent:TrialpayEvent?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupTableView()
        
        
        if self.navigationController != nil
        {
            self.showMenuButtonNavigationBar()
        }
                
        //Adconoly
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(GetMoreVC.addObservers), name: UIApplicationWillEnterForegroundNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(GetMoreVC.removeObservers), name: UIApplicationDidEnterBackgroundNotification, object: nil)
        self.addObservers()
     
        
        // fetch using a predefined placement name
//        [NativeXSDK fetchAdsAutomaticallyWithPlacement:kAdPlacementGameLaunch];
        
        NativeXSDK.fetchAdsAutomaticallyWithPlacement(kAdPlacementGameLaunch)
        
        // fetch using a custom placement name from Self Service
//        [NativeXSDK fetchAdsAutomaticallyWithName:@"Level Completed"];
        NativeXSDK.fetchAdsAutomaticallyWithName("Level Completed")
        
        
        ///setupSupersonic
        self.setupSupersonic()
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
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(GetMoreVC.pollfishNotAvailable) , name:
            "PollfishSurveyNotAvailable", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(GetMoreVC.pollfishReceived) , name:
            "PollfishSurveyReceived", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(GetMoreVC.pollfishOpened) , name:
            "PollfishOpened", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(GetMoreVC.pollfishClosed) , name:
            "PollfishClosed", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(GetMoreVC.pollfishUsernotEligible) , name:
            "PollfishUserNotEligible", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(GetMoreVC.pollfishCompleted) , name:
            "PollfishSurveyCompleted", object: nil)
        
        //        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(GetMoreVC.rotateApp) , name:
        //            UIDeviceOrientationDidChangeNotification, object: nil)
        
        //Hide PollFish
//        if (AppDelegate.pollfish_enable != nil && AppDelegate.pollfish_enable!)
//        {
//            self.btnPollFish.hidden = false
//        }
//        else
//        {
//            self.btnPollFish.hidden = true
//        }
//        
//        //btnTrialpay
//        if (AppDelegate.trialpay_enable != nil && AppDelegate.trialpay_enable!)
//        {
//            self.btnTrialpay.hidden = false
//        }
//        else
//        {
//            self.btnTrialpay.hidden = true
//        }
//        
//        //adcolony_enable
//        if (AppDelegate.adcolony_enable != nil && AppDelegate.adcolony_enable!)
//        {
//            self.btnAdcolony.hidden = false
//        }
//        else
//        {
//            self.btnAdcolony.hidden = true
//        }
        
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
    

    func setupTableView()
    {
        self.tbGetMore.delegate     = self
        self.tbGetMore.dataSource   = self
        self.tbGetMore.separatorStyle = .None
        self.tbGetMore.allowsSelection = false
        
        let nib = UINib(nibName: String(GetMoreCell), bundle: nil)
        self.tbGetMore.registerNib(nib, forCellReuseIdentifier: String(GetMoreCell))
    }
    
    func setupSupersonic()
    {
        print(Supersonic.sharedInstance().getVersion())
        
        SUSupersonicAdsConfiguration.getConfiguration().useClientSideCallbacks = NSNumber(bool: true)
        
        SupersonicEventsReporting.reportAppStarted()
        
        
        Supersonic.sharedInstance().setRVDelegate(RVDelegate.init(nibName: nil, bundle: nil, viewController: self))
        
        Supersonic.sharedInstance().setOWDelegate(OWdelegate.init(nibName: nil, bundle: nil, viewController: self))

        
        Supersonic.sharedInstance().initRVWithAppKey(AppDelegate.supersonic_app_id!, withUserId: AppDelegate.supersonic_user_id!)

        Supersonic.sharedInstance().initOWWithAppKey(AppDelegate.supersonic_app_id!, withUserId: AppDelegate.supersonic_user_id!)
        
    }
    
    
    //=============================
    // MARK: - tableViewDataSource
    //=============================
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 6
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        return self.cellForRowAtIndexPath(indexPath)
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 90
    }
    
    func cellForRowAtIndexPath(indexPath: NSIndexPath) -> UITableViewCell
    {
        switch indexPath.section
        {
        case 0:
            
            return self.dailyLoginCellAtIndexpath(indexPath)
            
        case 1:

            return self.adcolonyCellAtIndexpath(indexPath)

        case 2:

            return self.trialpayCellAtIndexpath(indexPath)
            
        case 3:

            return self.nativeXCellAtIndexpath(indexPath)
            
        case 4:
            
            return self.supersonicCellAtIndexpath(indexPath)
            
        case 5:
            
            return self.supersonicOfferwallCellAtIndexpath(indexPath)
            
            
        default:
            
            return self.supersonicOfferwallCellAtIndexpath(indexPath)
        }
    }
    
    
    //MARK: custom cell
    func polishCellAtIndexpath(indexPath: NSIndexPath) -> GetMoreCell
    {
        let pCell = self.tbGetMore.dequeueReusableCellWithIdentifier(String(GetMoreCell)) as! GetMoreCell
        
        pCell.indexPath = indexPath
        
//        pCell.btnCell.setTitle(self.getTitleButtonAtIndex(indexPath.section), forState: UIControlState.Normal)
        
        
        pCell.clickSelectButtonEvent = {
            [weak self](idxPath : NSIndexPath) -> Void  in
            
            print("index:\(idxPath.section)")
            
            if let strongSelf = self
            {
//                strongSelf.addActionAtIndex(indexPath.section)
            }
            
        }
        
        return pCell

    }
    
    func dailyLoginCellAtIndexpath(indexPath: NSIndexPath) -> GetMoreCell
    {
        let pCell = self.tbGetMore.dequeueReusableCellWithIdentifier(String(GetMoreCell)) as! GetMoreCell
        
        pCell.indexPath = indexPath
        
        pCell.lbTitle.text = "Daily Login"
        
        pCell.lbDes.text = "Earn Coins every day! Daily Login Bonus."
        
        pCell.imv_Des.image = UIImage(named: "img_calendar.png")
        
        pCell.lbCoin.text = "+100 COINS"
        
        pCell.clickSelectButtonEvent = {
            [weak self](idxPath : NSIndexPath) -> Void  in
            
            print("index:\(idxPath.section)")
            
            if let strongSelf = self
            {
                strongSelf.actionDailyLogin()
            }
            
        }
        
        return pCell
        
    }
    
    
    func adcolonyCellAtIndexpath(indexPath: NSIndexPath) -> GetMoreCell
    {
        let pCell = self.tbGetMore.dequeueReusableCellWithIdentifier(String(GetMoreCell)) as! GetMoreCell
        
        pCell.indexPath = indexPath
        
        pCell.lbTitle.text = "Watch Video"
        
        pCell.lbDes.text = "Watch Videos to get Coin."
        
        pCell.imv_Des.image = UIImage(named: "img_adColony.jpg")
        
        pCell.lbCoin.text = "EARN COINS"

        pCell.clickSelectButtonEvent = {
            [weak self](idxPath : NSIndexPath) -> Void  in
            
            print("index:\(idxPath.section)")
            
            if let strongSelf = self
            {
                strongSelf.actionAdcolony()
            }
            
        }
        
        return pCell
        
    }
    
    
    func supersonicCellAtIndexpath(indexPath: NSIndexPath) -> GetMoreCell
    {
        let pCell = self.tbGetMore.dequeueReusableCellWithIdentifier(String(GetMoreCell)) as! GetMoreCell
        
        pCell.indexPath = indexPath
        
        pCell.lbTitle.text = "Watch Video"
        
        pCell.lbDes.text = "Watch Videos to get Coin."
        
        pCell.imv_Des.image = UIImage(named: "img_supersonic.png")
        
        pCell.lbCoin.text = "EARN COINS"

        pCell.clickSelectButtonEvent = {
            [weak self](idxPath : NSIndexPath) -> Void  in
            
            print("index:\(idxPath.section)")
            
            if let strongSelf = self
            {
                strongSelf.actionSupersonic()
            }
            
        }
        
        return pCell
        
    }

    func supersonicOfferwallCellAtIndexpath(indexPath: NSIndexPath) -> GetMoreCell
    {
        let pCell = self.tbGetMore.dequeueReusableCellWithIdentifier(String(GetMoreCell)) as! GetMoreCell
        
        pCell.indexPath = indexPath
        
        pCell.lbTitle.text = "Supersonic Offerwall"
        
        pCell.lbDes.text = "Watch Videos to get Coin."
        
        pCell.imv_Des.image = UIImage(named: "img_supersonic.png")
        
        pCell.lbCoin.text = "EARN COINS"
        
        pCell.clickSelectButtonEvent = {
            [weak self](idxPath : NSIndexPath) -> Void  in
            
            print("index:\(idxPath.section)")
            
            if let strongSelf = self
            {
                strongSelf.actionSupersonicOfferwall()
            }
            
        }
        
        return pCell
        
    }

    
    func nativeXCellAtIndexpath(indexPath: NSIndexPath) -> GetMoreCell
    {
        let pCell = self.tbGetMore.dequeueReusableCellWithIdentifier(String(GetMoreCell)) as! GetMoreCell
        
        pCell.indexPath = indexPath
        
        pCell.lbTitle.text = "Nativex"
        
        pCell.lbDes.text = "Watch Videos to get Coin."
        
        pCell.imv_Des.image = UIImage(named: "img_nativex.jpg")
        
        pCell.lbCoin.text = "EARN COINS"
        
        pCell.clickSelectButtonEvent = {
            [weak self](idxPath : NSIndexPath) -> Void  in
            
            print("index:\(idxPath.section)")
            
            if let strongSelf = self
            {
                strongSelf.actionNativeX()
            }
            
        }
        
        return pCell
        
    }

    func trialpayCellAtIndexpath(indexPath: NSIndexPath) -> GetMoreCell
    {
        let pCell = self.tbGetMore.dequeueReusableCellWithIdentifier(String(GetMoreCell)) as! GetMoreCell
        
        pCell.indexPath = indexPath
        
        pCell.lbTitle.text = "Trialpay"
        
        pCell.lbDes.text = "Watch Videos to get Coin."
        
        pCell.imv_Des.image = UIImage(named: "img_trialpay.jpg")
        
        pCell.lbCoin.text = "EARN COINS"
        
        pCell.clickSelectButtonEvent = {
            [weak self](idxPath : NSIndexPath) -> Void  in
            
            print("index:\(idxPath.section)")
            
            if let strongSelf = self
            {
                strongSelf.actionTrialpay()
            }
            
        }
        
        return pCell
        
    }

    
    
    
    //MARK: Action
    func actionDailyLogin()
    {
//        let sr = SR.sharedManager().in
//        
//        sr.openWall()
        
        let pVC = DailyLoginVC(nibName: nil, bundle: nil)
        
        self.navigationController?.pushViewController(pVC, animated: true)
        
        
    }

    
    func actionTrialpay()
    {
        offerWallEvent?.fire()
        
    }
    
    func actionAdcolony()
    {
        //AdColony.playVideoAdForZone("vzf8fb4670a60e4a139d01b5", withDelegate: nil)
        //        AdColony.playVideoAdForZone("vzf8fb4670a60e4a139d01b5", withDelegate: self, withV4VCPrePopup: true, andV4VCPostPopup: true)
        //        AdColony.playVideoAdForZone(AppDelegate.adcolony_zone_id ?? "", withDelegate: nil, withV4VCPrePopup: true, andV4VCPostPopup: true)
        
        AdColony.playVideoAdForZone(Constants.adcolonyZoneID, withDelegate: self, withV4VCPrePopup: true, andV4VCPostPopup: true)
        
        
    }
    
    
    func actionNativeX()
    {
        if(NativeXSDK.isAdFetchedWithName("Game Launch") )
        {
            //            NativeXAdInfo *info = [NativeXSDK getAdInfoWithName:placement];
            
            let info = NativeXSDK.getAdInfoWithName("Game Launch")
            
            // Before we show an ad, we want to make sure that the music is paused.
            // Let's check the AdInfo object to see the details for this ad.
            
            //            [NativeXSDK showAdWithName:placement andShowDelegate:self];
            
            NativeXSDK.showAdWithName("Game Launch", andShowDelegate: self)
            
        }
        
    }
    
    
    func actionSupersonic()
    {
        Supersonic.sharedInstance().showRV()
    }
    
    func actionSupersonicOfferwall()
    {
        Supersonic.sharedInstance().showOW()
        
    }

    
    
    
    //MARK: Setup 
    
    func addObservers()
    {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(GetMoreVC.updateCurrencyBalance), name: Constants.currencyBalanceChange, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(GetMoreVC.zoneReady), name: Constants.zoneReady, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(GetMoreVC.zoneOff), name: Constants.zoneOff, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(GetMoreVC.zoneLoading), name: Constants.zoneLoading, object: nil)
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
        
    }
    
    
    //MARK: End Pollfish
    
    //MARK: IBAction
    
    func getTitleButtonAtIndex(indexButton : Int) -> String
    {
        if indexButton == 0
        {
            return "Polish";
        }
        
        if indexButton == 1
        {
            return "AdColony";
        }
        
        if indexButton == 2
        {
            return "Tripay";
        }
        
        if indexButton == 3
        {
            return "NativeX";
        }
        
        if indexButton == 4
        {
            return "Suppersonic";
        }
        
        if indexButton == 5
        {
            return "Offerwall";
        }
        
        if indexButton == 0
        {
            return "Polish";
        }
        
        return "Polish";

    }

    
    /*
    func addActionAtIndex(indexButton : Int)
    {
        switch indexButton {
        case 0:
            actionPolish()
            
            break
        case 1:
            actionAdcolony()
            
            break
        case 2:
            actionTrialpay()
            
            break
            
        case 3:
            actionNativeX()
            
            break
            
        case 4:
            actionSupersonic()
            
            break
           
        case 5:
            actionSupersonicOfferwall()
            
            break

            
        default:
            break
        }
    }
    
    */
    
    
    func onAdColonyAdAttemptFinished(shown: Bool, inZone zoneID: String)
    {
        if !shown && AdColony.zoneStatusForZone(Constants.adcolonyZoneID) != ADCOLONY_ZONE_STATUS.ACTIVE {
            //        if !shown && AdColony.zoneStatusForZone(AppDelegate.adcolony_zone_id ?? "") != ADCOLONY_ZONE_STATUS.ACTIVE {
            self.zoneLoading()
        } else if !shown {
            self.zoneReady()
        }
    }
    
    
    func actionPolish()
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
            
            Pollfish.show()
        }
        else
        {
            print("don't not pollfishId")
        }
    }
    
    /*
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
    */
    
    
}
