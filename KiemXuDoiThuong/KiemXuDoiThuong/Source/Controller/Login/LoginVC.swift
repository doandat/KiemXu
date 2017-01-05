//
//  LoginVC.swift
//  KiemXuDoiThuong
//
//  Created by Doan Dat on 8/14/16.
//  Copyright © 2016 datdv. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin
import Alamofire
import ObjectMapper
import SwiftyJSON

class LoginVC: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // Add a custom login button to your app        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK - IBAction
    
    @IBAction func actionLoginFacebook(sender: AnyObject)
    {
        self.loginButtonClicked()
    }
    
    @IBAction func skipLogin(sender: AnyObject)
    {
        self.setupContainerVC()
    }
    

    // Once the button is clicked, show the login dialog
    func loginButtonClicked()
    {
        
        let loginManager = LoginManager()
        
        loginManager.logIn([.PublicProfile, .UserFriends, .Email], viewController: self)
        { result in
            self.loginManagerDidComplete(result)
        }
        
//        loginManager.logIn([.PublishActions], viewController: self) { result in
//           self.loginManagerDidComplete(result)
//        }
    }
    
    func loginManagerDidComplete(result: LoginResult) {
        switch result {
        case .Cancelled:
            
            print("cancel login")
            
            break;
            
        case .Failed(let error):
            
            let alertController: UIAlertController = UIAlertController(title: "Login Fail", message: "Login failed with error \(error)", preferredStyle: UIAlertControllerStyle.Alert)
            self.presentViewController(alertController, animated: true, completion: nil)
            
        case .Success( _, _,let token):
            
            print("\n\nUserID:\(token.userId)\n:\n\(token.appId)")
            
            let userDefaults = NSUserDefaults.standardUserDefaults()
            
            if let userId = token.userId
            {
                userDefaults.setValue(userId, forKey: kStrThirdPartyId)
            }
            
            userDefaults.setValue(token.appId, forKey: kStrAppId)
            userDefaults.setValue(token.authenticationToken, forKey: kStrAuthenticationToken)
            
            self.getInfoFacebookUser()
            
            break;

        }
    }
    
    func getInfoFacebookUser()
    {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        appDelegate.showLoading()

        
        let request = GraphRequest(graphPath: "/me",
                                   parameters: [ "fields" : "id, name, first_name, last_name, age_range, gender,email" ],
                                   httpMethod: .GET)
        request.start { httpResponse, result in
            switch result {
            case .Success(let response):
                print("Graph Request Succeeded: \(response)")
                
                let result = response.dictionaryValue!
                
                let json = JSON(result)
               
                let userDefaults = NSUserDefaults.standardUserDefaults()
                
                userDefaults.setValue(json["name"].stringValue, forKey: kStrUserName)
                userDefaults.setValue(json["first_name"].stringValue+json["last_name"].stringValue, forKey: kStrFullName)
                userDefaults.setValue(json["age_range"]["min"].numberValue, forKey: kStrAge)
                userDefaults.setValue(json["gender"].stringValue, forKey: kStrSex)
                userDefaults.setValue(json["email"].stringValue, forKey: kStrEmail)

                //Call Api Create User
                self.createUSer()
                
            case .Failed(let error):
                print("Graph Request Failed: \(error)")
            }
            
        }
        
        let requestFriend = GraphRequest(graphPath: "/me/friends",
                                         parameters: ["fields": ""],
                                         httpMethod: .GET)
        requestFriend.start { httpResponse, result in
            switch result {
            case .Success(let response):
                print("Graph Request Succeeded: \(response)")
            case .Failed(let error):
                print("Graph Request Failed: \(error)")
            }
            
        }
    }
    
    
    func setupLoginVC()  {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.setupLoginVC();
    }
    
    func setupContainerVC()
    {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.setupContainerVC();
//        let window :UIWindow = UIApplication.sharedApplication().keyWindow!
//        window.rootViewController = appDelegate.container
//        window.makeKeyAndVisible()

    }
    
    //MARK: Call API
    func createUSer()
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
        createAccountInputData.user_id  = ""
        createAccountInputData.username = prefs.stringForKey(kStrUserName)
        createAccountInputData.full_name = prefs.stringForKey(kStrFullName)
        createAccountInputData.country = prefs.stringForKey(kStrCountry) ?? ""
        createAccountInputData.city = prefs.stringForKey(kStrCity) ?? ""
        createAccountInputData.language = NSLocale.preferredLanguages()[0] ?? ""
        createAccountInputData.avatar_url = url_avatar
        createAccountInputData.desCription = ""
        createAccountInputData.email = prefs.stringForKey(kStrEmail)
        createAccountInputData.phone = ""
        createAccountInputData.os = "ios"
        createAccountInputData.devices_type_using = UIDevice.currentDevice().localizedModel
        createAccountInputData.sex = prefs.stringForKey(kStrSex)
        createAccountInputData.age = prefs.stringForKey(kStrAge)
        createAccountInputData.fiends_list = ""
        createAccountInputData.third_party_id = pUserID
//        createAccountInputData.device_id = UIDevice.currentDevice().identifierForVendor!.UUIDString
        
        createAccountInputData.device_id = deviceID

        APIClient.sharedInstance

        APIClient.sharedInstance.createAccountUsingFacebook(createAccountInputData) {
            
            [weak self] (result) in
              print("a:\(result)")
            
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
                    
                    NSNotificationCenter.defaultCenter().postNotificationName(kNotificationCenterChangeCoin, object: nil)
                    
                    print(userData?.data)
                    
                    if let strongSelf = self
                    {
                        strongSelf.setupContainerVC()
                        
                        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                        
                        appDelegate.hideLoading()

                    }
   
                }
            }
        }
    }
    
        
}
