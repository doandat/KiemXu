//
//  APIClient.swift
//  KiemXuDoiThuong
//
//  Created by Doan Dat on 8/20/16.
//  Copyright © 2016 datdv. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper

class MPResponseManager: NSObject
{
    var error: NSError?
    var isFailure: Bool?
    var debugDescriptionText: String?
    var isSuccess: Bool?
    var value: AnyObject?
    
    
    private override init()
    {
        super.init()
    }
    
    func initWithResponseData(value: AnyObject?, isFailure:Bool?, debugDescriptionText:String?, isSuccess:Bool?, err:NSError?)
    {
        self.value                  = value
        self.error                  = err
        self.isFailure              = isFailure
        self.debugDescriptionText   = debugDescriptionText
        self.isSuccess              = isSuccess
        
        
    }
    
    func messengeAlertErr() -> String? {
        if (self.error == nil) {
            return nil
        }
        
        return "error in:\(error)"
        
    }
    
}

class APIClient {
    
    static let sharedInstance: APIClient = APIClient()
    
    private init() {
        print("AAA", terminator: "")
    }
    
    // MARK: Private func GET
    private func GET(path: String, completion: (result: String?) -> Void)
    {
        let safeURL = path.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!

        Alamofire.request(.GET, safeURL).responseString
        {
            response in
                    
            if let url = response.request?.URL?.absoluteURL
            {
                print("url:\(url)")
            }
            
            if response.result.isFailure
            {
                self.sendNotifyWithResult(response.result)
            }
            
            completion(result: response.result.value)

        }
    }
    
    // MARK: Private func POST
    private func POST(path: String, parameters:[String: String]?, completion: (result: String?) -> Void)
    {
        
        let safeURL = path.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
                
        Alamofire.request(.POST, safeURL, headers: parameters).responseString
            {
                [weak self] (response) in
                if let url = response.request?.URL?.absoluteURL
                {
                    print("url:\(url)")
                }
                
                if let strongSelf = self
                {
                    if response.result.isFailure
                    {
                        strongSelf.sendNotifyWithResult(response.result)
                    }
                    
                    completion(result: response.result.value)

                }
                
        }
    }
    
    
    
    
    // MARK: Private func POST
    private func POST(path: String, parameters:[String: AnyObject]?, completion: (result: String?) -> Void)
    {
        
        let safeURL = path.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        
        Alamofire.request(.POST, safeURL, parameters: parameters).responseString
            {
                response in
                if let url = response.request?.URL?.absoluteURL
                {
                    print("url:\(url)")
                }
                
                if response.result.isFailure
                {
                    self.sendNotifyWithResult(response.result)
                }
                
                completion(result: response.result.value)
        }
    }
    
    

    
    private func sendNotifyWithResult(result: Result<String, NSError>)
    {

        print("a:\(result.debugDescription)")
        NSNotificationCenter.defaultCenter().postNotificationName(kNotificationCenterCallApiErr, object: result.debugDescription)

    }
    
    
    
    // MARK: - Public method
    
    // MARK: Get location
    
    func getLocationUser(completion: (result: String?) -> Void)
    {
        self.GET(kUrlIP, completion: completion)
    }
    
    // MARK: CreateUser
    
    func createAccountUsingFacebook(createUserInputData :CreateUserInputData, completion: (result: String?) -> Void)
    {
        let createUserExecute = CreateUserExecute()
        
        let createUserParameters = CreateUserParameters()
        createUserParameters.inputData = createUserInputData
        createUserParameters.userExecute = createUserExecute
        
        let createAccountModel = CreateAccountModel()
        
        createAccountModel.request = "api"
        createAccountModel.function = "User.createAccountUsingFacebook"
        createAccountModel.parameters = createUserParameters
        
        print("prams:\(createAccountModel.toJSONString())")
        
        let urlCreateUser = kUrlApi+CommonUtil.toBase64(createAccountModel.toJSONString()!)
        
        self.POST(urlCreateUser, parameters: nil, completion: completion)
    }
    
    //MARK - GetSystemAds
    
    func getSystemAds(systemAdsInputData :SystemAdsInputData, user_id: String!,completion: (result: String?) -> Void)
    {
        let systemAdsUserExecute = SystemAdsUserExecute()
        systemAdsUserExecute.user_id = user_id
        
        let systemAdsParameters = SystemAdsParameters()
        systemAdsParameters.inputData = systemAdsInputData
        systemAdsParameters.userExecute = systemAdsUserExecute
        
        let systemAdsModel = SystemAdsModel()
        
        systemAdsModel.request = "api"
        systemAdsModel.function = "App.getSystemAds"
        systemAdsModel.session_id = AppDelegate.session_id
        systemAdsModel.parameters = systemAdsParameters
        
        print("prams:\(systemAdsModel.toJSONString())")
        
        let urlgetSystemAds = kUrlApi+CommonUtil.toBase64(systemAdsModel.toJSONString()!)
        
//        self.POST(urlgetSystemAds, parameters: nil, completion: completion)
        self.POST(urlgetSystemAds, parameters: nil, completion: { [weak self] (result) in
            
            if let strongSelf = self
            {
                if let resultString = result
                {
                    var dicData: NSDictionary?
                    
                    //                    var error : NSError?
                    
                    let JSONData = resultString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
                    
                    if let jsonData = JSONData
                    {
                        do {
                            dicData = try NSJSONSerialization.JSONObjectWithData(jsonData, options: []) as? NSDictionary
                            
                        } catch {
                            print("error: \(error)")
                            dicData = nil
                        }
                    }
                    
                    if let dicResult = dicData
                    {
                        let status = dicResult.objectForKey("status") as? String
                        
                        let message = dicResult.objectForKey("message") as? String
                        
                        if status == "1" && message == "SESSION_INVALID: Session expired, please login again"
                        {
                            let prefs = NSUserDefaults.standardUserDefaults()
                            
                            if let userID = prefs.stringForKey(kStrUserId)
                            {
                                strongSelf.createUser(userID, completion: {
                                    
                                    systemAdsModel.session_id = AppDelegate.session_id
                                    
                                    let urlgetSystemAds2 = kUrlApi + CommonUtil.toBase64(systemAdsModel.toJSONString()!)

                                    strongSelf.POST(urlgetSystemAds2, parameters: nil, completion: completion)
                                })
                            }
                        }
                    }
                    
                }

            }
            
            
            completion(result: result)
        })

    }
    
    // InstallFinished
    func callInstallFinished(installFinishedInputData :InstallFinishedInputData, user_id: String!, completion: (result: String?) -> Void)
    {
        let installFinishedUserExecute = InstallFinishedUserExecute()
        installFinishedUserExecute.user_id = user_id
        
        let installFinishedParameters = InstallFinishedParameters()
        installFinishedParameters.inputData = installFinishedInputData
        installFinishedParameters.userExecute = installFinishedUserExecute
        
        let installFinishedModel = InstallFinishedModel()
        
        installFinishedModel.request = "api"
        installFinishedModel.function = "App.InstallFinished"
        installFinishedModel.session_id = AppDelegate.session_id
        installFinishedModel.parameters = installFinishedParameters
        
        print("prams:\(installFinishedModel.toJSONString())")
        
        let urlInstallFinished = kUrlApi+CommonUtil.toBase64(installFinishedModel.toJSONString()!)
        
        self.POST(urlInstallFinished, parameters: nil, completion: { [weak self] (result) in
            
            if let strongSelf = self
            {
                if let resultString = result
                {
                    var dicData: NSDictionary?
                    
                    //                    var error : NSError?
                    
                    let JSONData = resultString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
                    
                    if let jsonData = JSONData
                    {
                        do {
                            dicData = try NSJSONSerialization.JSONObjectWithData(jsonData, options: []) as? NSDictionary
                            
                        } catch {
                            print("error: \(error)")
                            dicData = nil
                        }
                    }
                    
                    if let dicResult = dicData
                    {
                        let status = dicResult.objectForKey("status") as? String
                        
                        let message = dicResult.objectForKey("message") as? String
                        
                        if status == "1" && message == "SESSION_INVALID: Session expired, please login again"
                        {
                            let prefs = NSUserDefaults.standardUserDefaults()
                            
                            if let userID = prefs.stringForKey(kStrUserId)
                            {
                                strongSelf.createUser(userID, completion: {
                                    
                                    installFinishedModel.session_id = AppDelegate.session_id
                                    
                                    let urlInstallFinished2 = kUrlApi + CommonUtil.toBase64(installFinishedModel.toJSONString()!)
                                    
                                    strongSelf.POST(urlInstallFinished2, parameters: nil, completion: completion)
                                })
                            }
                        }
                    }
                    
                }
                
            }

            
            completion(result: result)
        })
    }
    
    // InputReferralCode
    func callInputReferralCode(referralCodeInputData :ReferralCodeInputData, user_id: String!, completion: (result: String?) -> Void)
    {
        let referralCodeUserExecute = ReferralCodeUserExecute()
        referralCodeUserExecute.user_id = user_id
        
        let referralCodeParameters = ReferralCodeParameters()
        referralCodeParameters.inputData = referralCodeInputData
        referralCodeParameters.userExecute = referralCodeUserExecute
        
        let referralCodeModel = ReferralCodeModel()
        
        referralCodeModel.request = "api"
        referralCodeModel.function = "Account.InputReferralCode"
        referralCodeModel.session_id = AppDelegate.session_id
        referralCodeModel.parameters = referralCodeParameters
        
        print("prams:\(referralCodeModel.toJSONString())")
        
        let pURl = kUrlApi + CommonUtil.toBase64(referralCodeModel.toJSONString()!)
        
        self.POST(pURl, parameters: nil, completion: { [weak self] (result) in
            
            if let strongSelf = self
            {
                if let resultString = result
                {
                    var dicData: NSDictionary?
                    
                    //                    var error : NSError?
                    
                    let JSONData = resultString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
                    
                    if let jsonData = JSONData
                    {
                        do {
                            dicData = try NSJSONSerialization.JSONObjectWithData(jsonData, options: []) as? NSDictionary
                            
                        } catch {
                            print("error: \(error)")
                            dicData = nil
                        }
                    }
                    
                    if let dicResult = dicData
                    {
                        let status = dicResult.objectForKey("status") as? String
                        
                        let message = dicResult.objectForKey("message") as? String
                        
                        if status == "1" && message == "SESSION_INVALID: Session expired, please login again"
                        {
                            let prefs = NSUserDefaults.standardUserDefaults()
                            
                            if let userID = prefs.stringForKey(kStrUserId)
                            {
                                strongSelf.createUser(userID, completion: {
                                    
                                    referralCodeModel.session_id = AppDelegate.session_id
                                    
                                    let pURl2 = kUrlApi + CommonUtil.toBase64(referralCodeModel.toJSONString()!)
                                    
                                    strongSelf.POST(pURl2, parameters: nil, completion: completion)
                                })
                            }
                        }
                    }
                    
                }
                
            }
            
            
            completion(result: result)
            })
    }
    
    // logAction
    func callLogAction(logActionInputData :LogActionInputData, user_id: String!, completion: (result: String?) -> Void)
    {
        let logActionUserExecute = LogActionUserExecute()
        logActionUserExecute.user_id = user_id
        
        let logActionParameters = LogActionParameters()
        logActionParameters.inputData = logActionInputData
        logActionParameters.userExecute = logActionUserExecute
        
        let logActionModel = LogActionModel()
        
        logActionModel.request = "api"
        logActionModel.function = "App.logAction"
        logActionModel.session_id = AppDelegate.session_id
        logActionModel.parameters = logActionParameters
        
        print("prams:\(logActionModel.toJSONString())")
        
        let pURl = kUrlApi+CommonUtil.toBase64(logActionModel.toJSONString()!)
        
        self.POST(pURl, parameters: nil, completion: { [weak self] (result) in
            
            if let strongSelf = self
            {
                if let resultString = result
                {
                    var dicData: NSDictionary?
                    
                    //                    var error : NSError?
                    
                    let JSONData = resultString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
                    
                    if let jsonData = JSONData
                    {
                        do {
                            dicData = try NSJSONSerialization.JSONObjectWithData(jsonData, options: []) as? NSDictionary
                            
                        } catch {
                            print("error: \(error)")
                            dicData = nil
                        }
                    }
                    
                    if let dicResult = dicData
                    {
                        let status = dicResult.objectForKey("status") as? String
                        
                        let message = dicResult.objectForKey("message") as? String
                        
                        if status == "1" && message == "SESSION_INVALID: Session expired, please login again"
                        {
                            let prefs = NSUserDefaults.standardUserDefaults()
                            
                            if let userID = prefs.stringForKey(kStrUserId)
                            {
                                strongSelf.createUser(userID, completion: {
                                    
                                    logActionModel.session_id = AppDelegate.session_id
                                    
                                    let pURl2 = kUrlApi + CommonUtil.toBase64(logActionModel.toJSONString()!)
                                    
                                    strongSelf.POST(pURl2, parameters: nil, completion: completion)
                                })
                            }
                        }
                    }
                    
                }
                
            }
            
            
            completion(result: result)
            })
    }
    
    // Recharge
    func callRecharge(rechargeInputData :RechargeInputData, user_id: String!, completion: (result: String?) -> Void)
    {
        let rechargeUserExecute = RechargeUserExecute()
        rechargeUserExecute.user_id = user_id
        
        let rechargeParameters = RechargeParameters()
        rechargeParameters.inputData = rechargeInputData
        rechargeParameters.userExecute = rechargeUserExecute
        
        let rechargeModel = RechargeModel()
        
        rechargeModel.request = "api"
        rechargeModel.function = "Account.Recharge"
        rechargeModel.session_id = AppDelegate.session_id
        rechargeModel.parameters = rechargeParameters
        
        print("prams:\(rechargeModel.toJSONString())")
        
        let pURl = kUrlApi+CommonUtil.toBase64(rechargeModel.toJSONString()!)
        
        self.POST(pURl, parameters: nil, completion: { [weak self] (result) in
            
            if let strongSelf = self
            {
                if let resultString = result
                {
                    var dicData: NSDictionary?
                    
                    //                    var error : NSError?
                    
                    let JSONData = resultString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
                    
                    if let jsonData = JSONData
                    {
                        do {
                            dicData = try NSJSONSerialization.JSONObjectWithData(jsonData, options: []) as? NSDictionary
                            
                        } catch {
                            print("error: \(error)")
                            dicData = nil
                        }
                    }
                    
                    if let dicResult = dicData
                    {
                        let status = dicResult.objectForKey("status") as? String
                        
                        let message = dicResult.objectForKey("message") as? String
                        
                        if status == "1" && message == "SESSION_INVALID: Session expired, please login again"
                        {
                            let prefs = NSUserDefaults.standardUserDefaults()
                            
                            if let userID = prefs.stringForKey(kStrUserId)
                            {
                                strongSelf.createUser(userID, completion: {
                                    
                                    rechargeModel.session_id = AppDelegate.session_id
                                    
                                    let pUrl2 = kUrlApi + CommonUtil.toBase64(rechargeModel.toJSONString()!)
                                    
                                    strongSelf.POST(pUrl2, parameters: nil, completion: completion)
                                })
                            }
                        }
                    }
                    
                }
                
            }
            
            
            completion(result: result)
            })
    }

    // Paypal Payment
    func callPaypalPayment(paypalPaymentInputData :PaypalPaymentInputData, user_id: String!, completion: (result: String?) -> Void)
    {
        let paypalPaymentUserExecute = PaypalPaymentUserExecute()
        paypalPaymentUserExecute.user_id = user_id
        
        let paypalPaymentParameters = PaypalPaymentParameters()
        paypalPaymentParameters.inputData = paypalPaymentInputData
        paypalPaymentParameters.userExecute = paypalPaymentUserExecute
        
        let paypalPaymentModel = PaypalPaymentModel()
        
        paypalPaymentModel.request = "api"
        paypalPaymentModel.function = "Account.PaypalPayment"
        paypalPaymentModel.session_id = AppDelegate.session_id
        paypalPaymentModel.parameters = paypalPaymentParameters
        
        print("prams:\(paypalPaymentModel.toJSONString())")
        
        let pURl = kUrlApi+CommonUtil.toBase64(paypalPaymentModel.toJSONString()!)
        
        self.POST(pURl, parameters: nil, completion: { [weak self] (result) in
            
            if let strongSelf = self
            {
                if let resultString = result
                {
                    var dicData: NSDictionary?
                    
                    //                    var error : NSError?
                    
                    let JSONData = resultString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
                    
                    if let jsonData = JSONData
                    {
                        do {
                            dicData = try NSJSONSerialization.JSONObjectWithData(jsonData, options: []) as? NSDictionary
                            
                        } catch {
                            print("error: \(error)")
                            dicData = nil
                        }
                    }
                    
                    if let dicResult = dicData
                    {
                        let status = dicResult.objectForKey("status") as? String
                        
                        let message = dicResult.objectForKey("message") as? String
                        
                        if status == "1" && message == "SESSION_INVALID: Session expired, please login again"
                        {
                            let prefs = NSUserDefaults.standardUserDefaults()
                            
                            if let userID = prefs.stringForKey(kStrUserId)
                            {
                                strongSelf.createUser(userID, completion: {
                                    
                                    paypalPaymentModel.session_id = AppDelegate.session_id
                                    
                                    let pUrl2 = kUrlApi + CommonUtil.toBase64(paypalPaymentModel.toJSONString()!)
                                    
                                    strongSelf.POST(pUrl2, parameters: nil, completion: completion)
                                })
                            }
                        }
                    }
                    
                }
                
            }
            
            
            completion(result: result)
            })
    }
    
    // User.sendFeedback
    func callSendFeedback(sendFeedbackInputData :SendFeedbackInputData, user_id: String!, completion: (result: String?) -> Void)
    {
        let sendFeedbackUserExecute = SendFeedbackUserExecute()
        sendFeedbackUserExecute.user_id = user_id
        
        let sendFeedbackParameters = SendFeedbackParameters()
        sendFeedbackParameters.inputData = sendFeedbackInputData
        sendFeedbackParameters.userExecute = sendFeedbackUserExecute
        
        let sendFeedbackModel = SendFeedbackModel()
        
        sendFeedbackModel.request = "api"
        sendFeedbackModel.function = "User.sendFeedback"
        sendFeedbackModel.session_id = AppDelegate.session_id
        sendFeedbackModel.parameters = sendFeedbackParameters
        
        print("prams:\(sendFeedbackModel.toJSONString())")
        
        let pURl = kUrlApi+CommonUtil.toBase64(sendFeedbackModel.toJSONString()!)
        
        self.POST(pURl, parameters: nil, completion: { [weak self] (result) in
            
            if let strongSelf = self
            {
                if let resultString = result
                {
                    var dicData: NSDictionary?
                    
                    //                    var error : NSError?
                    
                    let JSONData = resultString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
                    
                    if let jsonData = JSONData
                    {
                        do {
                            dicData = try NSJSONSerialization.JSONObjectWithData(jsonData, options: []) as? NSDictionary
                            
                        } catch {
                            print("error: \(error)")
                            dicData = nil
                        }
                    }
                    
                    if let dicResult = dicData
                    {
                        let status = dicResult.objectForKey("status") as? String
                        
                        let message = dicResult.objectForKey("message") as? String
                        
                        if status == "1" && message == "SESSION_INVALID: Session expired, please login again"
                        {
                            let prefs = NSUserDefaults.standardUserDefaults()
                            
                            if let userID = prefs.stringForKey(kStrUserId)
                            {
                                strongSelf.createUser(userID, completion: {
                                    
                                    sendFeedbackModel.session_id = AppDelegate.session_id
                                    
                                    let pUrl2 = kUrlApi + CommonUtil.toBase64(sendFeedbackModel.toJSONString()!)
                                    
                                    strongSelf.POST(pUrl2, parameters: nil, completion: completion)
                                })
                            }
                        }
                    }
                    
                }
                
            }
            
            
            completion(result: result)
            })
    }
    
    // User.reportErrorRecharge
    func callReportErrorRecharge(reportErrorRechargeInputData :ReportErrorRechargeInputData, user_id: String!, completion: (result: String?) -> Void)
    {
        let reportErrorRechargeUserExecute = ReportErrorRechargeUserExecute()
        reportErrorRechargeUserExecute.user_id = user_id
        
        let reportErrorRechargeParameters = ReportErrorRechargeParameters()
        reportErrorRechargeParameters.inputData = reportErrorRechargeInputData
        reportErrorRechargeParameters.userExecute = reportErrorRechargeUserExecute
        
        let reportErrorRechargeModel = ReportErrorRechargeModel()
        
        reportErrorRechargeModel.request = "api"
        reportErrorRechargeModel.function = "User.reportErrorRecharge"
        reportErrorRechargeModel.session_id = AppDelegate.session_id
        reportErrorRechargeModel.parameters = reportErrorRechargeParameters
        
        print("prams:\(reportErrorRechargeModel.toJSONString())")
        
        let pURl = kUrlApi+CommonUtil.toBase64(reportErrorRechargeModel.toJSONString()!)
        
        self.POST(pURl, parameters: nil, completion: { [weak self] (result) in
            
            if let strongSelf = self
            {
                if let resultString = result
                {
                    var dicData: NSDictionary?
                    
                    //                    var error : NSError?
                    
                    let JSONData = resultString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
                    
                    if let jsonData = JSONData
                    {
                        do {
                            dicData = try NSJSONSerialization.JSONObjectWithData(jsonData, options: []) as? NSDictionary
                            
                        } catch {
                            print("error: \(error)")
                            dicData = nil
                        }
                    }
                    
                    if let dicResult = dicData
                    {
                        let status = dicResult.objectForKey("status") as? String
                        
                        let message = dicResult.objectForKey("message") as? String
                        
                        if status == "1" && message == "SESSION_INVALID: Session expired, please login again"
                        {
                            let prefs = NSUserDefaults.standardUserDefaults()
                            
                            if let userID = prefs.stringForKey(kStrUserId)
                            {
                                strongSelf.createUser(userID, completion: {
                                    
                                    reportErrorRechargeModel.session_id = AppDelegate.session_id
                                    
                                    let pUrl2 = kUrlApi + CommonUtil.toBase64(reportErrorRechargeModel.toJSONString()!)
                                    
                                    strongSelf.POST(pUrl2, parameters: nil, completion: completion)
                                })
                            }
                        }
                    }
                }
            }
            
            
            completion(result: result)
            })
    }
    
    // User.reportErrorPaypalPayment
    func callReportErrorPaypalPayment(reportErrorPaypalPaymentInputData :ReportErrorPaypalPaymentInputData, user_id: String!, completion: (result: String?) -> Void)
    {
        let reportErrorPaypalPaymentUserExecute = ReportErrorPaypalPaymentUserExecute()
        reportErrorPaypalPaymentUserExecute.user_id = user_id
        
        let reportErrorPaypalPaymentParameters = ReportErrorPaypalPaymentParameters()
        reportErrorPaypalPaymentParameters.inputData = reportErrorPaypalPaymentInputData
        reportErrorPaypalPaymentParameters.userExecute = reportErrorPaypalPaymentUserExecute
        
        let reportErrorPaypalPaymentModel = ReportErrorPaypalPaymentModel()
        
        reportErrorPaypalPaymentModel.request = "api"
        reportErrorPaypalPaymentModel.function = "User.reportErrorPaypalPayment"
        reportErrorPaypalPaymentModel.session_id = AppDelegate.session_id
        reportErrorPaypalPaymentModel.parameters = reportErrorPaypalPaymentParameters
        
        print("prams:\(reportErrorPaypalPaymentModel.toJSONString())")
        
        let pURl = kUrlApi+CommonUtil.toBase64(reportErrorPaypalPaymentModel.toJSONString()!)
        
        self.POST(pURl, parameters: nil, completion: { [weak self] (result) in
            
            if let strongSelf = self
            {
                if let resultString = result
                {
                    var dicData: NSDictionary?
                    
                    //                    var error : NSError?
                    
                    let JSONData = resultString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
                    
                    if let jsonData = JSONData
                    {
                        do {
                            dicData = try NSJSONSerialization.JSONObjectWithData(jsonData, options: []) as? NSDictionary
                            
                        } catch {
                            print("error: \(error)")
                            dicData = nil
                        }
                    }
                    
                    if let dicResult = dicData
                    {
                        let status = dicResult.objectForKey("status") as? String
                        
                        let message = dicResult.objectForKey("message") as? String
                        
                        if status == "1" && message == "SESSION_INVALID: Session expired, please login again"
                        {
                            let prefs = NSUserDefaults.standardUserDefaults()
                            
                            if let userID = prefs.stringForKey(kStrUserId)
                            {
                                strongSelf.createUser(userID, completion: {
                                    
                                    reportErrorPaypalPaymentModel.session_id = AppDelegate.session_id
                                    
                                    let pUrl2 = kUrlApi + CommonUtil.toBase64(reportErrorPaypalPaymentModel.toJSONString()!)
                                    
                                    strongSelf.POST(pUrl2, parameters: nil, completion: completion)
                                })
                            }
                        }
                    }
                    
                }
                
            }
            
            
            completion(result: result)
            })
    }
    
    
    // User.getPaymentHistory
    func callGetPaymentHistory(getPaymentHistoryInputData :GetPaymentHistoryInputData, user_id: String!, completion: (result: String?) -> Void)
    {
        let getPaymentHistoryUserExecute = GetPaymentHistoryUserExecute()
        getPaymentHistoryUserExecute.user_id = user_id
        
        let getPaymentHistoryParameters = GetPaymentHistoryParameters()
        getPaymentHistoryParameters.inputData = getPaymentHistoryInputData
        getPaymentHistoryParameters.userExecute = getPaymentHistoryUserExecute
        
        let getPaymentHistoryModel = GetPaymentHistoryModel()
        
        getPaymentHistoryModel.request = "api"
        getPaymentHistoryModel.function = "User.getPaymentHistory"
        getPaymentHistoryModel.session_id = AppDelegate.session_id
        getPaymentHistoryModel.parameters = getPaymentHistoryParameters
        
        print("prams:\(getPaymentHistoryModel.toJSONString())")
        
        let pURl = kUrlApi+CommonUtil.toBase64(getPaymentHistoryModel.toJSONString()!)
        
        self.POST(pURl, parameters: nil, completion: { [weak self] (result) in
            
            if let strongSelf = self
            {
                if let resultString = result
                {
                    var dicData: NSDictionary?
                    
                    //                    var error : NSError?
                    
                    let JSONData = resultString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
                    
                    if let jsonData = JSONData
                    {
                        do {
                            dicData = try NSJSONSerialization.JSONObjectWithData(jsonData, options: []) as? NSDictionary
                            
                        } catch {
                            print("error: \(error)")
                            dicData = nil
                        }
                    }
                    
                    if let dicResult = dicData
                    {
                        let status = dicResult.objectForKey("status") as? String
                        
                        let message = dicResult.objectForKey("message") as? String
                        
                        if status == "1" && message == "SESSION_INVALID: Session expired, please login again"
                        {
                            let prefs = NSUserDefaults.standardUserDefaults()
                            
                            if let userID = prefs.stringForKey(kStrUserId)
                            {
                                strongSelf.createUser(userID, completion: {
                                    
                                    getPaymentHistoryModel.session_id = AppDelegate.session_id
                                    
                                    let pUrl2 = kUrlApi + CommonUtil.toBase64(getPaymentHistoryModel.toJSONString()!)
                                    
                                    strongSelf.POST(pUrl2, parameters: nil, completion: completion)
                                })
                            }
                        }
                    }
                    
                }
                
            }
            
            
            completion(result: result)
            })
    }
    
    // User.getInstallAppsHistory
    func callGetInstallAppsHistory(getInstallAppsHistoryInputData :GetInstallAppsHistoryInputData, user_id: String!, completion: (result: String?) -> Void)
    {
        let getInstallAppsHistoryUserExecute = GetInstallAppsHistoryUserExecute()
        getInstallAppsHistoryUserExecute.user_id = user_id
        
        let getInstallAppsHistoryParameters = GetInstallAppsHistoryParameters()
        getInstallAppsHistoryParameters.inputData = getInstallAppsHistoryInputData
        getInstallAppsHistoryParameters.userExecute = getInstallAppsHistoryUserExecute
        
        let getInstallAppsHistoryModel = GetInstallAppsHistoryModel()
        
        getInstallAppsHistoryModel.request = "api"
        getInstallAppsHistoryModel.function = "User.actionGetCoinHistory"
        getInstallAppsHistoryModel.session_id = AppDelegate.session_id
        getInstallAppsHistoryModel.parameters = getInstallAppsHistoryParameters
        
        print("prams:\(getInstallAppsHistoryModel.toJSONString())")
        
        let pURl = kUrlApi+CommonUtil.toBase64(getInstallAppsHistoryModel.toJSONString()!)
        
        self.POST(pURl, parameters: nil, completion: { [weak self] (result) in
            
            if let strongSelf = self
            {
                if let resultString = result
                {
                    var dicData: NSDictionary?
                    
                    //                    var error : NSError?
                    
                    let JSONData = resultString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
                    
                    if let jsonData = JSONData
                    {
                        do {
                            dicData = try NSJSONSerialization.JSONObjectWithData(jsonData, options: []) as? NSDictionary
                            
                        } catch {
                            print("error: \(error)")
                            dicData = nil
                        }
                    }
                    
                    if let dicResult = dicData
                    {
                        let status = dicResult.objectForKey("status") as? String
                        
                        let message = dicResult.objectForKey("message") as? String
                        
                        if status == "1" && message == "SESSION_INVALID: Session expired, please login again"
                        {
                            let prefs = NSUserDefaults.standardUserDefaults()
                            
                            if let userID = prefs.stringForKey(kStrUserId)
                            {
                                strongSelf.createUser(userID, completion: {
                                    
                                    getInstallAppsHistoryModel.session_id = AppDelegate.session_id
                                    
                                    let pUrl2 = kUrlApi + CommonUtil.toBase64(getInstallAppsHistoryModel.toJSONString()!)
                                    
                                    strongSelf.POST(pUrl2, parameters: nil, completion: completion)
                                })
                            }
                        }
                    }
                    
                }
                
            }
            
            
            completion(result: result)
            })
    }

    // User.addMoreCoin
    func callAddMoreCoin(addMoreCoinInputData :AddMoreCoinInputData, user_id: String!, completion: (result: String?) -> Void)
    {
        let addMoreCoinUserExecute = AddMoreCoinUserExecute()
        addMoreCoinUserExecute.user_id = user_id
        
        let addMoreCoinParameters = AddMoreCoinParameters()
        addMoreCoinParameters.inputData = addMoreCoinInputData
        addMoreCoinParameters.userExecute = addMoreCoinUserExecute
        
        let addMoreCoinModel = AddMoreCoinModel()
        
        addMoreCoinModel.request = "api"
        addMoreCoinModel.function = "User.addMoreCoin"
        addMoreCoinModel.session_id = AppDelegate.session_id
        addMoreCoinModel.parameters = addMoreCoinParameters
        
        print("prams:\(addMoreCoinModel.toJSONString())")
        
        let pURl = kUrlApi+CommonUtil.toBase64(addMoreCoinModel.toJSONString()!)
        
        self.POST(pURl, parameters: nil, completion: { [weak self] (result) in
            
            if let strongSelf = self
            {
                if let resultString = result
                {
                    var dicData: NSDictionary?
                    
                    //                    var error : NSError?
                    
                    let JSONData = resultString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
                    
                    if let jsonData = JSONData
                    {
                        do {
                            dicData = try NSJSONSerialization.JSONObjectWithData(jsonData, options: []) as? NSDictionary
                            
                        } catch {
                            print("error: \(error)")
                            dicData = nil
                        }
                    }
                    
                    if let dicResult = dicData
                    {
                        let status = dicResult.objectForKey("status") as? String
                        
                        let message = dicResult.objectForKey("message") as? String
                        
                        if status == "1" && message == "SESSION_INVALID: Session expired, please login again"
                        {
                            let prefs = NSUserDefaults.standardUserDefaults()
                            
                            if let userID = prefs.stringForKey(kStrUserId)
                            {
                                strongSelf.createUser(userID, completion: {
                                    
                                    addMoreCoinModel.session_id = AppDelegate.session_id
                                    
                                    let pUrl2 = kUrlApi + CommonUtil.toBase64(addMoreCoinModel.toJSONString()!)
                                    
                                    strongSelf.POST(pUrl2, parameters: nil, completion: completion)
                                })
                            }
                        }
                    }
                    
                }
                
            }
            
            completion(result: result)
        })
    }

    
    /////////////
    
    //MARK: Call API
    func createUser(userID: String?, completion: () -> Void)
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
//        createAccountInputData.device_id = UIDevice.currentDevice().identifierForVendor!.UUIDString
        createAccountInputData.device_id = deviceID
        
        APIClient.sharedInstance
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        appDelegate.showLoading()
        
        //        self.showLoading()
        
        
        APIClient.sharedInstance.createAccountUsingFacebook(createAccountInputData) {
            
            [weak self] (result) in
            print("a:\(result)")
            
            if let strongSelf = self
            {
                
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
                        
                        //                        strongSelf.hideLoading()
                        let alert = UIAlertController(title: "Kiem Tien", message: userData?.message ?? "", preferredStyle: UIAlertControllerStyle.Alert)
                        
                        // add an action (button)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                        
                        // show the alert
//                        strongSelf.presentViewController(alert, animated: true, completion: nil)
                        
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
                        //                        strongSelf.hideLoading()
                        
                        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                        
                        appDelegate.hideLoading()
                        
//                        strongSelf.getSystemAds()
                    }
                    
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
            
            completion()
            
        }
    }
}