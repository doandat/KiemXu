//
//  AppDelegate.swift
//  KiemXuDoiThuong
//
//  Created by Doan Dat on 8/10/16.
//  Copyright © 2016 datdv. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin
import Alamofire
import ObjectMapper
import SVProgressHUD

import DropDown

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, AdColonyDelegate, TrialpayEventsDelegate, TrialpayRewardsDelegate
{

    var window: UIWindow?

    static var session_id: String?

    //appconfig
    static var startapp_enable: Bool?
    static var startapp_id: String?
    static var startapp_coin_install: Float?
    static var appnext_enable: Bool?
    static var appnext_id: String?
    static var appnext_coin_install_rate: Float?
    static var pollfish_enable: Bool?
    static var pollfish_id: String?
    static var pollfish_coin_completed_long_survey: Float?
    static var pollfish_coin_completed_short_survey: Float?
    static var pollfish_coin_rate: Float?
    static var trialpay_enable: Bool?
    static var trialpay_id: String?
    static var trialpay_coin_rate: Float?
    static var adcolony_enable: Bool?
    static var adcolony_app_id: String?
    static var adcolony_zone_id: String?
    static var adcolony_coin_rate: Float?
    static var adcolony_received_video_coin: Float?
    static var paypal_payment_enable: Bool?
    static var recharge_option_values: String?
    static var paypal_payment_opion_values: String?
    static var exchange_rate_usd_coin: Float?
    
    static var arrRechargeValue: [String] = []
    static var arrRechargeKey: [String] = []

    static var arrPaypalPaymentValue: [String] = []
    static var arrPaypalPaymentKey: [String] = []

    static var supersonic_app_id: String? = "5940abbd"
    static var supersonic_user_id: String? = UIDevice.currentDevice().identifierForVendor!.UUIDString


    
    var navitaion:BaseNavigationController?

    var container: MFSideMenuContainerViewController?

    var onLaunchEvent: TrialpayEvent?
    var backgroundDate: NSDate?
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        
//        AdColony.configureWithAppID(Constants.adcolonyAppID, zoneIDs: [Constants.adcolonyZoneID], delegate: self, logging: true)
//
//        
////        //check sim
////        var isSimalator:Bool = false
////        #if (arch(i386) || arch(x86_64)) && os(iOS)
////            isSimalator = true
////        #endif
////
////        if isSimalator {
////            return false
////        }
////        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
//        
//
////        NSLog("Api Version : %@", AppnextSDKApi.getApiVersion())
////        AppnextSDKApi.startSDKApi()
//
//        ////////////////////
//        
////        // initialize the SDK with your appID and devID
////        let sdk: STAStartAppSDK = STAStartAppSDK.sharedInstance();
////        sdk.appID = "208407509";
////        sdk.devID = "108578867";
////        sdk.preferences = STASDKPreferences.prefrencesWithAge(18, andGender: STAGender_Male)
//        
//        //////
//
        
        //2. SetupDropDown
        setUPDropDown()
        
        //3. getLocationUser
        getLocationOfUser()
       
        //4. SetupVC
        setupVC()

        //5. setupTrialpay
        setupTrialpay()
        
        
        //6. Initialize the SDK
        setupNativeX()
        
        //7. Supersonic
        setupSupersonic()
        
        return true
    }
    
    
    //MARK: Setup
    
    func setUPDropDown()
    {
        DropDown.startListeningToKeyboard()

    }
    
    func getLocationOfUser()
    {
        let prefs = NSUserDefaults.standardUserDefaults()
        
        if prefs.stringForKey(kStrCity) == nil
        {
            self.getLocationUser()
        }
    }
    
    func setupVC()
    {
        
        let prefs = NSUserDefaults.standardUserDefaults()
        
        if let userID = prefs.stringForKey(kStrUserId)
        {
            print("User logined: " + userID)
            self.setupContainerVC()
        }
        else{
            //Nothing stored in NSUserDefaults yet. Set a value.
            print("User not login")
            self.setupLoginVC()
            
        }

    }
    
    
    func setupNativeX()
    {
        NativeXSDK.initializeWithAppId("109622")
    }
    
    func setupSupersonic()
    {
        Supersonic.sharedInstance()
    }
    
    
    func setupAdColony()
    {
        //Configure AdColony once on app launch
        if let adcolony_appId = AppDelegate.adcolony_app_id ,
            let adcolonyZoneID =  AppDelegate.adcolony_zone_id
            {
//            AdColony.configureWithAppID(adcolony_appId, zoneIDs: [adcolonyZoneID], delegate: self, logging: true)
                AdColony.configureWithAppID(Constants.adcolonyAppID, zoneIDs: [Constants.adcolonyZoneID], delegate: self, logging: true)


        }

    }
    
    func setupTrialpay()
    {
        Trialpay.initApp("9cac0de65109c186dbd2e52da29df1bc", withSid: "userID1")
        
        Trialpay.setEventsDelegate(self)
        
        Trialpay.setRewardsDelegate(self)
        
        prepareOnLaunch()

    }
    
    func prepareOnLaunch()
    {
        // Show an offer when app starts or when we come back to foreground after 60s on background
        if (backgroundDate == nil || backgroundDate?.timeIntervalSinceNow <= -60)
        {
            // Create the event
            onLaunchEvent = TrialpayEvent(name: "OnLaunch", info: nil)
            
            let launched = NSDate()

            let block : TPStatusChangeBlock = {(event: TrialpayEvent?, status: TPEventStatus) -> Void in
                if status == TPEventStatusNewOffers && launched.timeIntervalSinceNow >= -15 {
                    event?.fire()
                    // stop listening so we dont fire again
                    event?.onStatusChange = nil
                }
            }
            
            onLaunchEvent?.onStatusChange = block
        }
        
    }
    
    
    func setupLoginVC()
    {
        let loginVC = LoginVC(nibName: nil, bundle: nil)
        
        self.window?.rootViewController = loginVC
        self.window!.makeKeyAndVisible()
    }
    
    func setupContainerVC()
    {
        //tabbar
        let tabBarController = UITabBarController()

        //get coin
        let sanXuVC = SanXuVC(nibName: nil, bundle: nil)
        let firstImage = UIImage(named: "icon_kiemxu")?.imageWithRenderingMode(UIImageRenderingMode.init(rawValue: 2)!)
        sanXuVC.tabBarItem = UITabBarItem(
            title: "GET COIN",
            image: firstImage,
            tag: 1)
        
        let navitaion1 = BaseNavigationController(nibName: "BaseNavigationController", bundle: nil)
        navitaion1 .setViewControllers([sanXuVC], animated: true)
        
        //GET MORE
        let getMoreVC = GetMoreVC(nibName: nil, bundle: nil)
        let navitaion2 = BaseNavigationController(nibName: "BaseNavigationController", bundle: nil)
        navitaion2 .setViewControllers([getMoreVC], animated: true)
        
        
        let secondImage = UIImage(named: "icon_more")
        getMoreVC.tabBarItem = UITabBarItem(
            title: "GET MORE",
            image: secondImage,
            tag:2)
        
        //rechage
        let doiQuaVC = DoiQuaVC(nibName: nil, bundle: nil)
        let navitaion3 = BaseNavigationController(nibName: "BaseNavigationController", bundle: nil)
        navitaion3 .setViewControllers([doiQuaVC], animated: true)
        
        
        let thirdImage = UIImage(named: "icon_doixu")
        
        doiQuaVC.tabBarItem = UITabBarItem(
            title: "CHANGE GIFT",
            image: thirdImage,
            tag:2)

        
        
        let controllers = [navitaion1,navitaion2,navitaion3]
        
        tabBarController.viewControllers        = controllers
        tabBarController.tabBar.barTintColor    = UIColor.init(red: 235.0, green: 235.0, blue: 235.0, alpha: 1.0)
        tabBarController.tabBar.tintColor       = UIColor.orangeColor()
        tabBarController.tabBar.layer.shadowColor = UIColor.blackColor().CGColor
        tabBarController.tabBar.layer.shadowOffset  = CGSizeMake(0.0, 1.0)
        tabBarController.tabBar.layer.shadowOpacity = 0.5;
        

        
        let sideBarVC = MoreVC(nibName: nil, bundle: nil)
        
        //        let navitaionSidebar = BaseNavigationController(nibName: nil, bundle: nil)
        //        navitaionSidebar.viewControllers = [sideBarVC]
        tabBarController.navigationController?.navigationBarHidden = true
        container = MFSideMenuContainerViewController()
        container?.leftMenuViewController   = sideBarVC
        container?.centerViewController     = tabBarController
        
        navitaion = BaseNavigationController(nibName: nil, bundle: nil)
        navitaion!.viewControllers = [container!]
        navitaion?.navigationBarHidden = true

        
        self.window?.rootViewController = navitaion
        self.window!.makeKeyAndVisible()
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        AppEventsLogger.activate(application)
           

    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return ApplicationDelegate.shared.application(application,
                                                      openURL: url,
                                                      sourceApplication: sourceApplication,
                                                      annotation: annotation)
    }

    
    //MARK: Call Get city, country
    func getLocationUser()
    {
        APIClient.sharedInstance
        
        showLoading()
        
        APIClient.sharedInstance.getLocationUser {
            [weak self] (result) in
            print("a:\(result)")
            
            if let resultString = result
            {
                let locationUser = Mapper<LocationUser>().map(resultString)
                
                let userDefaults = NSUserDefaults.standardUserDefaults()
                
                userDefaults.setValue(locationUser?.city, forKey: kStrCity)
                userDefaults.setValue(locationUser?.country, forKey: kStrCountry)
                userDefaults.setValue(locationUser?.countryCode, forKey: kStrCountryCode)
                
                if let strongSelf = self
                {                   
                    strongSelf.hideLoading()
                }
            }
        }
    }

    func showLoading()
    {
        dispatch_async(dispatch_get_main_queue(), {
            SVProgressHUD.show()
        })
    }
    
    func hideLoading()
    {
        dispatch_async(dispatch_get_main_queue(), {
            SVProgressHUD.dismiss()
        })
    }
    
    func onAdColonyV4VCReward(success: Bool, currencyName: String, currencyAmount amount: Int32, inZone zoneID: String)
    {
        NSLog("AdColony zone: %@ reward: %@ amount: %i", zoneID, success ? "YES" : "NO", amount)
        
        if success {
            //Get currency balance from persistent storage and update it
            
            callAddMoreCoin("\(amount)", work_type: kStrWorkTypeAdColony, data: "AdColony video reward")

            
            //Post a notification so the rest of the app knows the balance changed
            NSNotificationCenter.defaultCenter().postNotificationName(Constants.currencyBalanceChange, object: nil)
        }
    }
    
    //=============================================
    // MARK:- AdColony Ad Fill
    //=============================================
    
    /**
     Callback triggered when the state of ad readiness changes
     If the AdColony SDK tells us our zone either has, or doesn't have, ads, we
     need to tell our view controller to update its UI elements appropriately
     */
    func onAdColonyAdAvailabilityChange(available: Bool, inZone zoneID: String)
    {
        if available {
            NSNotificationCenter.defaultCenter().postNotificationName(Constants.zoneReady, object: nil)
        } else {
            NSNotificationCenter.defaultCenter().postNotificationName(Constants.zoneLoading, object: nil)
        }
    }
    
    
    ////////////////////////
    //MARK: TrialPay
    /////////////////////

    func trialpay(trialpay: Trialpay!, shouldOpenForEvent event: TrialpayEvent!) -> Bool {
        
        print("Trialpay: shouldOpenForEvent \(event.name)")
        
        // When return is NO it prevents opening events.
        return true
    }
    
    func trialpay(trialpay: Trialpay!, didCloseForEvent event: TrialpayEvent!) {
        print("Trialpay: didCloseForEvent \(event.name)")

    }

    func trialpay(trialpay: Trialpay!, eventIsUnavailable event: TrialpayEvent!) {
        print("Trialpay: eventIsUnavailable \(event.name)")

    }
    
  
    //MARK:  - TrialPay Rewards Delegate
    
    // When using client-side rewards this method will deliver them
    func trialpay(trialpay: Trialpay!, reward amount: Int32, rewardId: String!) {
        print("Trialpay: Got \(amount) \(rewardId) rewards")
        
        callAddMoreCoin("\(amount)", work_type: kStrWorkTypeTrialpay, data: "Trialpay reward")

    }
    
    // Rewards are announced to your app by this method, but the credits are not delivered
    // until the Trialpay rewards UI is shown:
    // * by invoking Trialpay:showRewards
    // * by setting up events to show rewards before/instead/after
    //
    // Rewards are delivered through the trialpay:reward:rewardId method.
    func trialpay(trialpay: Trialpay!, rewardsAreAvailable rewardInfo: [NSObject : AnyObject]!) {
        print("Trialpay: Rewards are available")
    }
    
    
    
    //MARK : -----------------
    
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
                        
                        strongSelf.window?.rootViewController!.presentViewController(alert, animated: true, completion: nil)
                        
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

