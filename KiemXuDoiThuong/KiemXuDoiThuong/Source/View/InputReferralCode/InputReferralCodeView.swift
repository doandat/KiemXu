//
//  InputReferralCodeView.swift
//  KiemXuDoiThuong
//
//  Created by Doan Dat on 9/11/16.
//  Copyright © 2016 datdv. All rights reserved.
//

import UIKit
import QuartzCore
import Alamofire
import ObjectMapper

class InputReferralCodeView: UIView {
    
    @IBOutlet weak var tfInputReferralCode: UITextField!
    
    @IBOutlet weak var btnCancel: UIButton!
    
    @IBOutlet weak var btnOK: UIButton!
    
    @IBOutlet weak var lbMessage: UILabel!
    
    let messageErr:String = "Please input referral code"

    
    var backgroundView :UIView? = nil
    
    let pRootWindow = ((UIApplication.sharedApplication().delegate?.window)!)! as UIWindow

    override init(frame: CGRect) { // for using CustomView in code
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) { // for using CustomView in IB
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        let view = NSBundle.mainBundle().loadNibNamed( String(InputReferralCodeView), owner: self, options: nil).first as! UIView
        //        guard let content = contentView else { return }
        view.frame = self.bounds
        view.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        self.addSubview(view)
        
    }
    
    init(frame: CGRect, referralCode: String?) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    func show()
    {
        let width = UIScreen.mainScreen().bounds.size.width
        let height = UIScreen.mainScreen().bounds.size.height
        
        self.center = CGPointMake(width*0.5, height*0.5)
        
        self.transform = CGAffineTransformMakeScale(0, 0)
        
        UIView.animateWithDuration(1.0, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.transform = CGAffineTransformIdentity
            }, completion: nil)
        
//        let pRootWindow = ((UIApplication.sharedApplication().delegate?.window)!)! as UIWindow
        
        self.backgroundView = UIView.init(frame: UIScreen.mainScreen().bounds)
        self.backgroundView?.backgroundColor = UIColor.blackColor()
        self.backgroundView?.alpha = 0.5
        
        pRootWindow.addSubview(self.backgroundView!)
        pRootWindow.addSubview(self)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(InputReferralCodeView.closeView))
        self.backgroundView!.addGestureRecognizer(tapGesture)
        
    }
    
    func closeView()
    {
        self.backgroundView?.removeFromSuperview()
        self.backgroundView = nil
        self.removeFromSuperview()
    }
    
    @IBAction func actionCancel(sender: AnyObject)
    {
        self.closeView()
    }
    
    @IBAction func actionOK(sender: AnyObject)
    {
        if self.validateInput()
        {
            self.inputReferralCode()
        }
    }
    
    //MARK - private
    func validateInput() -> Bool
    {
        if self.tfInputReferralCode.text == ""
        {
            self.lbMessage.text = self.messageErr
            
            return false
        }
        return true
    }
    
    
    //MARK - Call Api InputReferralCode
    func inputReferralCode()
    {
        let prefs = NSUserDefaults.standardUserDefaults()
        
        guard let userID = prefs.stringForKey(kStrUserId) else {
            print("UserId not found")
            return
        }
        
        let referralCodeInputData = ReferralCodeInputData()
        referralCodeInputData.referral_code = self.tfInputReferralCode.text
        
        
//        let navigationController = self.pRootWindow.rootViewController as! BaseNavigationController
//        
//        let activeViewCont = navigationController.visibleViewController as! BaseViewController

        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

        appDelegate.showLoading()
        
        APIClient.sharedInstance
        
        APIClient.sharedInstance.callInputReferralCode(referralCodeInputData, user_id: userID, completion:{
            [weak self] (result) in
            
            print("a:\(result)")
            
            if let strongSelf = self
            {
                strongSelf.closeView()
            }

            if let resultString = result
            {
                appDelegate.hideLoading()

                let resultFeedBack = Mapper<ReferralCodeResult>().map(resultString)
                
                if let strongSelf = self
                {
                    
                    let navigationController = strongSelf.pRootWindow.rootViewController as! BaseNavigationController
                    
                    let activeViewCont = navigationController.visibleViewController

                    let alert = UIAlertController(title: "EarnMoney", message: resultFeedBack?.message ?? "", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                    
                    activeViewCont!.presentViewController(alert, animated: true, completion: nil)
                    
                    if(resultFeedBack?.status != nil && resultFeedBack?.status == "0")
                    {
                        let userDefaults = NSUserDefaults.standardUserDefaults()
                        
                        userDefaults.setValue(true, forKey: kStrInputedReferralCode)

                        NSNotificationCenter.defaultCenter().postNotificationName(kNotificationCenterInputedCode, object: nil)

                        
                    }
                    
                    if ((resultFeedBack?.data?.account?.balance) != nil)
                    {
                        let userDefaults = NSUserDefaults.standardUserDefaults()
                        
                        userDefaults.setValue(resultFeedBack?.data?.account?.balance, forKey: kStrbalance)
                        
                        NSNotificationCenter.defaultCenter().postNotificationName(kNotificationCenterChangeCoin, object: nil)

                    }
                }
            }
            else
            {
                if self != nil
                {
                    appDelegate.hideLoading()
                }
            }
            
            })
    }

    
}