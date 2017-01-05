//
//  ReChangePhoneVC.swift
//  KiemXuDoiThuong
//
//  Created by Doan Dat on 9/2/16.
//  Copyright © 2016 datdv. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import DropDown

class ReChangePhoneVC: BaseViewController, UITextFieldDelegate {
    
    @IBOutlet weak var viewSubscriptionType: UIView!
    
    @IBOutlet weak var lbSubsciptionType: UILabel!
    
    @IBOutlet weak var viewNetworking: UIView!
    
    @IBOutlet weak var lbNetworking: UILabel!
    
    @IBOutlet weak var viewRechargePacket: UIView!
    
    @IBOutlet weak var lbRechargePacket: UILabel!
    
    @IBOutlet weak var lbCurrentCoin: UILabel!
    
    
    @IBOutlet weak var tfPhone: UITextField!
    
    @IBOutlet weak var btnRecharge: UIButton!
    
    
    let strMessageSelectSubcripType = "Please select Subcription Type"
    
    let strMessageSelectFirstSubcripType = "Please select Subcription Type first"
    
    let strMessageSelectNetwork = "Please select Networking"

    let strMessageSelectPackage = "Please select Recharge Package"

    let strMessageInputPhone = "Please Input phone number"

    let strMessageInputPhoneLarge = "Phone number largest is 15 number. Please input again"

    var indexSelectType: Int?
    
    var indexSelecNetwork : Int?
    
    var indexSelectPackage : Int?
    
    
    let dropDownSubscription = DropDown()
    
    let dropDownNetwork = DropDown()
    
    let dropDownPackage = DropDown()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setUpUI()
        
        self.addEvent()
        
        self.configLeftBarButton()
        
        self.setupDropDownSubscription()
        
        self.setupDropDownPackage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK: Private method
    
    func setUpUI()
    {
        self.viewSubscriptionType.layer.borderWidth = 1.0
        self.viewSubscriptionType.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.viewSubscriptionType.layer.cornerRadius = 5
        
        self.viewNetworking.layer.borderWidth = 1.0
        self.viewNetworking.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.viewNetworking.layer.cornerRadius = 5
        
        self.viewRechargePacket.layer.borderWidth = 1.0
        self.viewRechargePacket.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.viewRechargePacket.layer.cornerRadius = 5

        self.tfPhone.delegate = self
        
        self.btnRecharge.setShadowHidden(false)
        
        let prefs = NSUserDefaults.standardUserDefaults()
        
        let currentCoin = (prefs.stringForKey(kStrbalance)  != nil) ? prefs.stringForKey(kStrbalance):"0"
        
        self.lbCurrentCoin.text = "Your Current Coins: \(currentCoin!) Coins"
        
    }
    
    func addEvent()
    {
        let tapGestureSubscription = UITapGestureRecognizer(target: self, action: #selector(ReChangePhoneVC.actionSubscription))
        self.viewSubscriptionType!.addGestureRecognizer(tapGestureSubscription)

        
        let tapGestureNetwork = UITapGestureRecognizer(target: self, action: #selector(ReChangePhoneVC.actionNetworking))
        self.viewNetworking!.addGestureRecognizer(tapGestureNetwork)

        
        let tapGestureRechargePackage = UITapGestureRecognizer(target: self, action: #selector(ReChangePhoneVC.actionRechargePackage))
        self.viewRechargePacket!.addGestureRecognizer(tapGestureRechargePackage)

    }
    
    func setupDropDownSubscription()
    {
        dropDownSubscription.anchorView = viewSubscriptionType
        
        dropDownSubscription.bottomOffset = CGPoint(x: 0, y: viewSubscriptionType.bounds.height)
        
        // You can also use localizationKeysDataSource instead. Check the docs.
        dropDownSubscription.dataSource = arrCategoryPhone
        
        // Action triggered on selection
        dropDownSubscription.selectionAction = { [unowned self] (index, item) in
//            self.lbSubsciptionType.text = item
            if index != self.indexSelectType
            {
                self.lbSubsciptionType.text = arrCategoryPhone[index]
                
                self.indexSelectType = index;
            
                self.indexSelecNetwork = nil
                
                self.lbNetworking.text = "Choose ..."
                
                self.setupDropDownNetwork(index)
            }
        }

    }
    
    func setupDropDownNetwork(type:Int)
    {
        dropDownNetwork.anchorView = viewNetworking
        
        dropDownNetwork.bottomOffset = CGPoint(x: 0, y: viewNetworking.bounds.height)
        
        if type == 0
        {
            dropDownNetwork.dataSource = arrPrepaidValue
        }
        else
        {
            dropDownNetwork.dataSource = arrPostPaidValue
        }
        
        
        // Action triggered on selection
        dropDownNetwork.selectionAction = { [unowned self] (index, item) in

            if self.indexSelectType == 0
            {
                self.lbNetworking.text = arrPrepaid[index].0
                self.indexSelecNetwork = index;

            }
            else
            {
                self.lbNetworking.text = arrPostPaid[index].0
                self.indexSelecNetwork = index;

            }
        }
        
    }
    
    func setupDropDownPackage()
    {
        dropDownPackage.anchorView = viewRechargePacket
        
        dropDownPackage.bottomOffset = CGPoint(x: 0, y: viewRechargePacket.bounds.height)
        
        // You can also use localizationKeysDataSource instead. Check the docs.
//        dropDownPackage.dataSource = arrReCharge
        dropDownPackage.dataSource = AppDelegate.arrRechargeKey
        
        // Action triggered on selection
        dropDownPackage.selectionAction = {
            [unowned self] (index, item) in
            
            self.lbRechargePacket.text = AppDelegate.arrRechargeKey[index]
            self.indexSelectPackage = index;
        }
        
    }
    
    
    
    func validateSelect() -> Bool
    {
        if self.indexSelectType == nil
        {
            let alert = UIAlertController(title: "EarnMoney", message: strMessageSelectSubcripType, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return false
        }
        
        if self.indexSelecNetwork == nil
        {
            let alert = UIAlertController(title: "EarnMoney", message: strMessageSelectNetwork, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return false
        }
        
        if self.indexSelectPackage == nil
        {
            let alert = UIAlertController(title: "EarnMoney", message: strMessageSelectPackage, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return false
        }
        
        
        if self.tfPhone.text == ""
        {
            let alert = UIAlertController(title: "EarnMoney", message: strMessageInputPhone, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return false
        }
        
        if self.tfPhone.text?.characters.count > 15 {
            let alert = UIAlertController(title: "EarnMoney", message: strMessageInputPhoneLarge, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return false

        }
        
        return true
    }
    
    //==========================
    //MARK : Action
    //==========================

    func actionSubscription()
    {
        
        dropDownSubscription.show()
        
//        let customPickerView = CustomPickerView(frame: CGRectMake(0, 70, 300, 300), arrData: arrCategoryPhone)
//        
//        customPickerView.dismisViewEvent = {
//            [unowned self](index : Int) -> Void  in
//            print(index)
//            
//            if index != self.indexSelectType
//            {
//                self.lbSubsciptionType.text = arrCategoryPhone[index]
//                self.indexSelectType = index;
//                
//                self.indexSelecNetwork = nil
//                
//                self.lbNetworking.text = "Choose ..."
//            }
//            
//            
//        }
//        customPickerView.show()

    }
    
    func actionNetworking()
    {
//        if self.indexSelectType == 0
//        {
//            let customPickerView = CustomPickerView(frame: CGRectMake(0, 70, 300, 300), arrData: arrPrepaid)
//            
//            customPickerView.dismisViewEvent = {
//                [unowned self] (index : Int) -> Void  in
//                print(index)
//                
//                self.lbNetworking.text = arrPrepaid[index].0
//                self.indexSelecNetwork = index;
//
//                
//            }
//            customPickerView.show()
//
//        }
//        else if self.indexSelectType == 1
//        {
//            let customPickerView = CustomPickerView(frame: CGRectMake(0, 70, 300, 300), arrData: arrPostPaid)
//            
//            customPickerView.dismisViewEvent = {
//                [unowned self] (index : Int) -> Void  in
//                print(index)
//                self.lbNetworking.text = arrPostPaid[index].0
//                self.indexSelecNetwork = index;
//            }
//            customPickerView.show()
//
//        }
        if self.indexSelectType == nil
        {
            let alert = UIAlertController(title: "EarnMoney", message: strMessageSelectFirstSubcripType, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
            return
        }
        
        dropDownNetwork.show()
    }
    
    func actionRechargePackage()
    {
//        let customPickerView = CustomPickerView(frame: CGRectMake(0, 70, 300, 300), arrData: arrReCharge)
//        
//        customPickerView.dismisViewEvent = {
//            [unowned self] (index : Int) -> Void  in
//            print(index)
//            self.lbRechargePacket.text = arrReCharge[index]
//            self.indexSelectPackage = index;
//        }
//        customPickerView.show()
        dropDownPackage.show()
    }
    
    //MARK: Textfield delegate
    func textFieldDidEndEditing(textField: UITextField)
    {
        
    }
    
    //MARK: IBAction
    
    @IBAction func actionRecharge(sender: AnyObject)
    {
        self.view.endEditing(true)
        
        if self.validateSelect()
        {
            self.recharge()
        }
    }
    
    
    
    //MARK - Call Api recharge
    func recharge()
    {
        let prefs = NSUserDefaults.standardUserDefaults()
        
        guard let userID = prefs.stringForKey(kStrUserId) else {
            print("UserId not found")
            return
        }
        
        let rechargeInputData = RechargeInputData()
        rechargeInputData.recharge_type = arrCategoryPhone[self.indexSelectType!]
        rechargeInputData.subscriber_number = self.tfPhone.text ?? ""
        rechargeInputData.amount = AppDelegate.arrRechargeValue[self.indexSelectPackage!]
        
//        rechargeInputData.amount = "20"
        
        if self.indexSelectType == 0
        {
            rechargeInputData.operaTor = arrPrepaid[self.indexSelecNetwork!].1
        }
        else
        {
            rechargeInputData.operaTor = arrPostPaid[self.indexSelecNetwork!].1
        }
        
//        self.showLoading()
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        appDelegate.showLoading()

        
        APIClient.sharedInstance
        
        APIClient.sharedInstance.callRecharge(rechargeInputData, user_id: userID, completion:{
            [weak self] (result) in
            
            print("a:\(result)")
            if let resultString = result
            {
                let userData = Mapper<RechargeResult>().map(resultString)
                
                if let strongSelf = self
                {
//                    strongSelf.hideLoading()
                    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    
                    appDelegate.hideLoading()

                    let alert = UIAlertController(title: "EarnMoney", message: userData?.message ?? "", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                    strongSelf.presentViewController(alert, animated: true, completion: nil)

                    if ((userData?.account?.balance) != nil)
                    {
                        let userDefaults = NSUserDefaults.standardUserDefaults()
                        
                        userDefaults.setValue(userData?.account?.balance, forKey: kStrbalance)
                        NSNotificationCenter.defaultCenter().postNotificationName(kNotificationCenterChangeCoin, object: nil)

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
            
        })
    }


}
