//
//  OWdelegate.swift
//  KiemXuDoiThuong
//
//  Created by DatDV on 11/14/16.
//  Copyright © 2016 datdv. All rights reserved.
//

import UIKit

class OWdelegate: UIViewController, SupersonicOWDelegate {

    var viewController:GetMoreVC?

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!, viewController: GetMoreVC!)
    {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.viewController = viewController
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func supersonicOWInitSuccess()
    {
        print("supersonicOWInitSuccess:showOWButton setEnabled:YES")
    }
    
    func supersonicOWShowSuccess() {
        print("supersonicOWShowSuccess")
    }

    func supersonicOWInitFailedWithError(error: NSError!) {
        print("supersonicOWInitFailedWithError")
    }
    
    func supersonicOWShowFailedWithError(error: NSError!) {
        print("supersonicOWShowFailedWithError")
    }
    
    func supersonicOWAdClosed() {
        print("supersonicOWAdClosed");
    }
    
    func supersonicOWDidReceiveCredit(creditInfo: [NSObject : AnyObject]!) -> Bool {
        print("supersonicOWDidReceiveCredit")
    
        return true;
    }
    
    func supersonicOWFailGettingCreditWithError(error: NSError!) {
        print("supersonicOWFailGettingCreditWithError")
    }
}
