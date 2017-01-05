//
//  RechargeByPaypalVC.swift
//  KiemXuDoiThuong
//
//  Created by Doan Dat on 9/11/16.
//  Copyright © 2016 datdv. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import DropDown

class RechargeByPaypalVC: BaseViewController {

    @IBOutlet weak var tfPaypalId: UITextField!
    
    @IBOutlet weak var btnPayment: UIButton!
    
    @IBOutlet weak var viewAmount: UIView!
    
    @IBOutlet weak var lbAmountValue: UILabel!
    
    @IBOutlet weak var lbCurrentCoin: UILabel!
    
    
    
    let messagePaypalIdErr = "Please input paypalId"
    
    let messageAmountErr = "Please input Amount"

    
    var indexSelectPaypal: Int?

    let dropDownPaypal = DropDown()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.configLeftBarButton()
     
        self.btnPayment.setShadowHidden(false)
        
        setUpUI()
        
        addEvent()
        
        setupDropDownPaypal()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpUI()
    {
        self.viewAmount.layer.borderWidth = 1.0
        self.viewAmount.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.viewAmount.layer.cornerRadius = 5
        
        let prefs = NSUserDefaults.standardUserDefaults()
        
        let currentCoin = (prefs.stringForKey(kStrbalance)  != nil) ? prefs.stringForKey(kStrbalance):"0"
        
        self.lbCurrentCoin.text = "Your Current Coins: \(currentCoin!) Coins"


    }
    
    func addEvent()
    {
        let tapGesturePayment = UITapGestureRecognizer(target: self, action: #selector(RechargeByPaypalVC.actionSelectPayment))
        self.viewAmount!.addGestureRecognizer(tapGesturePayment)
    }
    
    func setupDropDownPaypal()
    {
        dropDownPaypal.anchorView = viewAmount
        
        dropDownPaypal.bottomOffset = CGPoint(x: 0, y: viewAmount.bounds.height)
        
        // You can also use localizationKeysDataSource instead. Check the docs.
        //        dropDownPackage.dataSource = arrReCharge
        dropDownPaypal.dataSource = AppDelegate.arrPaypalPaymentKey
        
        // Action triggered on selection
        dropDownPaypal.selectionAction = {
            [unowned self] (index, item) in
            
            self.lbAmountValue.text = AppDelegate.arrPaypalPaymentKey[index]
            self.indexSelectPaypal = index;
        }
        
    }

    
    func actionSelectPayment()
    {
        
        dropDownPaypal.show()
    }
    
    //=====================================
    //MARK: private method
    
    private func validateInput() ->Bool
    {
        if (self.tfPaypalId?.text == "")
        {
            let alert = UIAlertController(title: "EarnMoney", message: messagePaypalIdErr, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return false
        }
        
        if self.indexSelectPaypal == nil
        {
            let alert = UIAlertController(title: "EarnMoney", message: messageAmountErr, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)

            return false
        }
        
        //default
        return true
    }
    

    //=====================================
    //MARK: IBAction
    
    @IBAction func actionPayment(sender: AnyObject)
    {
        self.view.endEditing(true)
        
        if self.validateInput()
        {
            self.paypalPayment()
        }
    }
    

    //MARK - Call Api Account.PaypalPayment
    func paypalPayment()
    {
        let prefs = NSUserDefaults.standardUserDefaults()
        
        guard let userID = prefs.stringForKey(kStrUserId) else {
            print("UserId not found")
            return
        }
        
        let paypalPaymentInputData = PaypalPaymentInputData()
        paypalPaymentInputData.paypal_id = self.tfPaypalId.text
        paypalPaymentInputData.amount = AppDelegate.arrPaypalPaymentValue[indexSelectPaypal!]
        
        
//        self.showLoading()

        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        appDelegate.showLoading()

        APIClient.sharedInstance
        
        APIClient.sharedInstance.callPaypalPayment(paypalPaymentInputData, user_id: userID, completion:{
            [weak self] (result) in
            
            print("a:\(result)")
            if let resultString = result
            {
                let userData = Mapper<PaypalPaymentResult>().map(resultString)
                
                if let strongSelf = self
                {
//                    strongSelf.hideLoading()
                    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    
                    appDelegate.hideLoading()

                    
                    if userData?.message == "OK"
                    {
                        userData?.message = "Successfull"
                    }
                    
                    let alert = UIAlertController(title: "EarnMoney", message: userData?.message ?? "", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {
                        (alert: UIAlertAction!) in
                        
                        strongSelf.navigationController?.popViewControllerAnimated(true)
                        
                    }))
                    
                    if ((userData?.account?.balance) != nil)
                    {
                        let userDefaults = NSUserDefaults.standardUserDefaults()
                        
                        userDefaults.setValue(userData?.account?.balance, forKey: kStrbalance)
                     
                        NSNotificationCenter.defaultCenter().postNotificationName(kNotificationCenterChangeCoin, object: nil)

                    }
                    
                    strongSelf.presentViewController(alert, animated: true, completion: nil)

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
