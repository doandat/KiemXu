//
//  PopupInstallAppView.swift
//  KiemXuDoiThuong
//
//  Created by Doan Dat on 8/19/16.
//  Copyright © 2016 datdv. All rights reserved.
//

import UIKit
import QuartzCore
import Alamofire
import ObjectMapper

class PopupInstallAppView: UIView {
    
    var systemAds :DataSystemAdsResult? = nil;

    var backgroundView :UIView? = nil
    
    @IBOutlet weak var btnInstall: UIButton!
    
    @IBOutlet weak var btnBack: UIButton!
    
    @IBOutlet weak var lbCoin: UILabel!
    
    @IBOutlet weak var imgApp: UIImageView!
    
    @IBOutlet weak var lbTitleApp: UILabel!
    
    @IBOutlet weak var lbStep: UILabel!
  
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
        let view = NSBundle.mainBundle().loadNibNamed( String(PopupInstallAppView), owner: self, options: nil).first as! UIView
        //        guard let content = contentView else { return }
        view.frame = self.bounds
        view.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        self.addSubview(view)
        
        self.btnBack.layer.cornerRadius = 5.0
        self.btnInstall.layer.cornerRadius = 5.0
        
        self.lbCoin.layer.masksToBounds = true
        self.lbCoin.layer.backgroundColor  = UIColor.redColor().CGColor

        self.lbCoin.layer.cornerRadius = 5.0

        
    }

    init(frame: CGRect, systemAds: DataSystemAdsResult) {
        super.init(frame: frame)
        self.commonInit()

        self.systemAds = systemAds
        
        self.lbCoin.text = systemAds.coin
        self.lbTitleApp.text = systemAds.app_name
        self.lbStep.text = "Hướng dẫn:\nB1: Install App\nB2: Open App\nB3: Take Coin";
        self.imgApp.sd_setImageWithURL(NSURL(string: systemAds.app_icon_url!), placeholderImage: UIImage(named: "img_avatar_blank"))

    }
    
    func show()
    {
        let width = UIScreen.mainScreen().bounds.size.width
        let height = UIScreen.mainScreen().bounds.size.height

        self.center = CGPointMake(width*0.5, height*0.5)
        
        self.transform = CGAffineTransformMakeScale(0, 0)
        
        UIView.animateWithDuration(1.0, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                self.transform = CGAffineTransformIdentity
            }, completion: nil)
        
        let pRootWindow = ((UIApplication.sharedApplication().delegate?.window)!)! as UIWindow
        
        self.backgroundView = UIView.init(frame: UIScreen.mainScreen().bounds)
        self.backgroundView?.backgroundColor = UIColor.blackColor()
        self.backgroundView?.alpha = 0.5
        
        pRootWindow.addSubview(self.backgroundView!)
        pRootWindow.addSubview(self)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(PopupInstallAppView.closeView))
        self.backgroundView!.addGestureRecognizer(tapGesture)

    }

    func closeView()
    {
        self.backgroundView?.removeFromSuperview()
        self.backgroundView = nil
        self.removeFromSuperview()
    }
    
    
    //MARK: IBAction
    
    @IBAction func actionInstall(sender: AnyObject)
    {
//        UIApplication.sharedApplication().openURL(NSURL(string: (self.systemAds?.app_url)!)!)
        self.callInstallFinished()
    }
    
    
    
    @IBAction func actionBack(sender: AnyObject)
    {
        self.closeView()
    }
 
    
    //MARK - Call Api InstallFinished
    func callInstallFinished()
    {
        let prefs = NSUserDefaults.standardUserDefaults()
        
        guard let userID = prefs.stringForKey(kStrUserId) else {
            print("UserId not found")
            return
        }
        
        let installFinishedInputData = InstallFinishedInputData()

        installFinishedInputData.app_id = "213"
        installFinishedInputData.app_code = self.systemAds?.app_code ?? ""
        installFinishedInputData.coin = "23400000"

        
//        installFinishedInputData.app_id = self.systemAds?.app_id ?? ""
//        installFinishedInputData.app_code = self.systemAds?.app_code ?? ""
        installFinishedInputData.app_name = self.systemAds?.app_name ?? ""
        installFinishedInputData.os = self.systemAds?.os ?? ""
        installFinishedInputData.country =  ""
        installFinishedInputData.city = ""
        installFinishedInputData.from_ads_network = "system"
//        installFinishedInputData.coin = self.systemAds?.coin ?? ""
        installFinishedInputData.revenue_rate = "1"
        
        
        //        let navigationController = self.pRootWindow.rootViewController as! BaseNavigationController
        //
        //        let activeViewCont = navigationController.visibleViewController as! BaseViewController
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        appDelegate.showLoading()
        
        APIClient.sharedInstance
        
        APIClient.sharedInstance.callInstallFinished(installFinishedInputData, user_id: userID, completion: {
            [weak self] (result) in
            
            print("a:\(result)")
            
            if let strongSelf = self
            {
                strongSelf.closeView()
            }
            
            if let resultString = result
            {
                appDelegate.hideLoading()
                
                let installFinishedResult = Mapper<InstallFinishedResult>().map(resultString)
                
                if let strongSelf = self
                {
                    
                    let navigationController = strongSelf.pRootWindow.rootViewController as! BaseNavigationController
                    
                    let activeViewCont = navigationController.visibleViewController
                    
                    let alert = UIAlertController(title: "EarnMoney", message: installFinishedResult?.message ?? "", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                    
                    activeViewCont!.presentViewController(alert, animated: true, completion: nil)
                    
                    
                    if ((installFinishedResult?.account?.balance) != nil)
                    {
                        let userDefaults = NSUserDefaults.standardUserDefaults()
                        
                        userDefaults.setValue(installFinishedResult?.account?.balance, forKey: kStrbalance)
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






