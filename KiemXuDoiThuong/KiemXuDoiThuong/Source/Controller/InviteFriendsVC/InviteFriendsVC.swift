//
//  InviteFriendsVC.swift
//  KiemXuDoiThuong
//
//  Created by Doan Dat on 9/13/16.
//  Copyright © 2016 datdv. All rights reserved.
//

import UIKit
import FacebookShare
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit

class InviteFriendsVC: BaseViewController {

    @IBOutlet weak var lbCode: UILabel!
    
    @IBOutlet weak var btnShare: UIButton!
    
    @IBOutlet weak var btnShareOther: UIButton!
    
    
    var referralCode:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let prefs = NSUserDefaults.standardUserDefaults()
        
        guard let referralCode = prefs.stringForKey(kStrReferralCode) else {
            print("kStrReferralCode not found")
            return
        }
        
        self.referralCode = referralCode
        
        self.lbCode.text = self.referralCode
        
        self.setupUI()

    }
    
    func setupUI()
    {
        self.lbCode.layer.cornerRadius = 5.0
        
        self.btnShare.setShadowHidden(false)
        
        self.btnShareOther.setShadowHidden(false)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.showBackButtonNavigationBarTypePop()
        
        self.navigationController?.navigationBarHidden = false

    }
    
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        
        self.navigationController?.navigationBarHidden = true

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /// IBAction
    
    @IBAction func actionShare(sender: AnyObject)
    {
        // text to share
        
        let messageShare = "Appstore link: https://play.google.com/store/apps/details?id=moneyapp.com.earnmoney_in, install app and and enter referral code: \(self.referralCode!) to get 100 coin"
        
        let text = self.referralCode ?? "Code"
//        let url = NSURL(fileURLWithPath: "http://google.com")
        
        let content: FBSDKShareLinkContent = FBSDKShareLinkContent()
        content.contentTitle = text
        content.contentDescription = text
        content.quote =  messageShare
        content.imageURL = NSURL(string: "https://play.google.com/store/apps/details?id=moneyapp.com.earnmoney_in")
        content.contentURL = NSURL(string: "https://play.google.com/store/apps/details?id=moneyapp.com.earnmoney_in")
        
        FBSDKShareDialog.showFromViewController(self, withContent: content, delegate: nil)
        

    }

    
    @IBAction func actionShareOther(sender: AnyObject)
    {
         //set up activity view controller
        let text = self.referralCode ?? "Code"
        let url = NSURL(string: "https://play.google.com/store/apps/details?id=moneyapp.com.earnmoney_in")

        
         let objectsToShare: [AnyObject] = [ text , url! ]
         let activityViewController = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
         activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
         // exclude some activity types from the list (optional)
         activityViewController.excludedActivityTypes = [ UIActivityTypePostToFacebook ]
        
         // present the view controller
         self.presentViewController(activityViewController, animated: true, completion: nil)

    }
    
}
