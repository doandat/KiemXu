//
//  InputMessageReportView.swift
//  KiemXuDoiThuong
//
//  Created by Doan Dat on 10/2/16.
//  Copyright © 2016 datdv. All rights reserved.
//

import UIKit
import QuartzCore
import Alamofire
import ObjectMapper

class InputMessageReportView: UIView {
    
    @IBOutlet weak var tvInputMessage: UITextView!

    @IBOutlet weak var btnCancel: UIButton!
    
    @IBOutlet weak var btnOK: UIButton!
    
    @IBOutlet weak var lbMessage: UILabel!
    
    var trans_id: String? = nil
    
    let messageErr:String = "Please input message!"
    
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
        let view = NSBundle.mainBundle().loadNibNamed( String(InputMessageReportView), owner: self, options: nil).first as! UIView
        //        guard let content = contentView else { return }
        tvInputMessage.layer.borderWidth = 1.0
        tvInputMessage.layer.borderColor = UIColor.grayColor().CGColor
        view.frame = self.bounds
        view.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        self.addSubview(view)
        
    }
    
    init(frame: CGRect, trans_id: String?) {
        super.init(frame: frame)
        
        self.trans_id = trans_id
        
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
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(InputMessageReportView.closeView))
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
        if self.validateInput() && self.trans_id != nil
        {
            
            self.callReportErrorPaypalPayment(self.trans_id!, message: self.tvInputMessage.text)
        
        }
    }
    
    //MARK - private
    func validateInput() -> Bool
    {
        if self.tvInputMessage.text == ""
        {
            self.lbMessage.text = self.messageErr
            
            return false
        }
        return true
    }
    
    //MARK - Call Api ReportErrorRecharge
    func callReportErrorRecharge(trans_id: String, message: String)
    {
        let prefs = NSUserDefaults.standardUserDefaults()
        
        guard let userID = prefs.stringForKey(kStrUserId) else {
            print("UserId not found")
            return
        }
        
        let reportErrorRechargeInputData = ReportErrorRechargeInputData()
        reportErrorRechargeInputData.trans_id = trans_id
        reportErrorRechargeInputData.message = message
        
        
        //        self.showLoading()
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        appDelegate.showLoading()
        
        
        APIClient.sharedInstance.callReportErrorRecharge(reportErrorRechargeInputData, user_id: userID) {
            
            [weak self] (result) in
            
            print("a:\(result)")
            if let resultString = result
            {
                let pData = Mapper<ReportErrorRechargeResult>().map(resultString)
                
                if let strongSelf = self
                {
                    strongSelf.closeView()
                }
                
                if let strongSelf = self
                {
                    
                    let navigationController = strongSelf.pRootWindow.rootViewController as! BaseNavigationController
                    
                    let activeViewCont = navigationController.visibleViewController
                    
                    let alert = UIAlertController(title: "EarnMoney", message: pData?.message ?? "", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                    
                    activeViewCont!.presentViewController(alert, animated: true, completion: nil)
                    
                    
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
    
    //MARK - Call Api ReportErrorPaypalPayment
    func callReportErrorPaypalPayment(trans_id: String, message: String)
    {
        let prefs = NSUserDefaults.standardUserDefaults()
        
        guard let userID = prefs.stringForKey(kStrUserId) else {
            print("UserId not found")
            return
        }
        
        let reportErrorPaypalPaymentInputData = ReportErrorPaypalPaymentInputData()
        reportErrorPaypalPaymentInputData.trans_id = trans_id
        reportErrorPaypalPaymentInputData.message = message
        
        
        //        self.showLoading()
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        appDelegate.showLoading()
        
        
        APIClient.sharedInstance.callReportErrorPaypalPayment(reportErrorPaypalPaymentInputData, user_id: userID) {
            
            [weak self] (result) in
            
            print("a:\(result)")
            if let resultString = result
            {
                let pData = Mapper<ReportErrorPaypalPaymentResult>().map(resultString)
                
                if let strongSelf = self
                {
                    strongSelf.closeView()
                }
                
                if let strongSelf = self
                {
                    
                    let navigationController = strongSelf.pRootWindow.rootViewController as! BaseNavigationController
                    
                    let activeViewCont = navigationController.visibleViewController
                    
                    let alert = UIAlertController(title: "EarnMoney", message: pData?.message ?? "", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                    
                    activeViewCont!.presentViewController(alert, animated: true, completion: nil)
                    
                }
                
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                
                appDelegate.hideLoading()

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
