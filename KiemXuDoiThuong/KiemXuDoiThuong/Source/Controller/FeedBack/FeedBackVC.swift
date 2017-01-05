//
//  FeedBackVC.swift
//  KiemXuDoiThuong
//
//  Created by Doan Dat on 9/12/16.
//  Copyright © 2016 datdv. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper

class FeedBackVC: BaseViewController {

    @IBOutlet weak var tvMessage: UITextView!
    
    @IBOutlet weak var btnSend: UIButton!
    
    let messageEmpty = "Message content is empty"

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.showBackButtonNavigationBarTypePop()
        
        self.navigationController?.navigationBarHidden = false
        
        self.tvMessage.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.tvMessage.layer.borderWidth = 1.0
        
        self.btnSend.setShadowHidden(false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        
        self.navigationController?.navigationBarHidden = true
        
    }

    //MARK- Private Method
    func validateInput() -> Bool
    {
        if self.tvMessage.text == ""
        {
            let alert = UIAlertController(title: "EarnMoney", message: messageEmpty, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            
            self.presentViewController(alert, animated: true, completion: nil)
            
            return false
        }
        return true
    }
    
    
    //MARK - IBAction
    
    @IBAction func actionSend(sender: AnyObject)
    {
        self.view.endEditing(true)
        
        if self.validateInput()
        {
            self.sendFeedBack()
        }
    }
    
    //MARK - Call Api SendFeedBack
    func sendFeedBack()
    {
        let prefs = NSUserDefaults.standardUserDefaults()
        
        guard let userID = prefs.stringForKey(kStrUserId) else {
            print("UserId not found")
            return
        }
        
        let sendFeedbackInputData = SendFeedbackInputData()
        sendFeedbackInputData.message = self.tvMessage.text
        
        
//        self.showLoading()
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        appDelegate.showLoading()

        
        APIClient.sharedInstance
        
        APIClient.sharedInstance.callSendFeedback(sendFeedbackInputData, user_id: userID, completion:{
            [weak self] (result) in
            
            print("a:\(result)")

            if let strongSelf = self
            {
//                strongSelf.hideLoading()
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                
                appDelegate.hideLoading()

            }
            
            if let resultString = result
            {
                let resultFeedBack = Mapper<SendFeedbackResult>().map(resultString)
                
                if let strongSelf = self
                {
                    let alert = UIAlertController(title: "EarnMoney", message: "Thank for feed back", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {
                        (alert: UIAlertAction!) in
                        
                        strongSelf.navigationController?.popViewControllerAnimated(true)
                        
                    }))
                    
                    strongSelf.presentViewController(alert, animated: true, completion: nil)

                }
            }
            else
            {
                
            }
            
            })
    }

    
}
