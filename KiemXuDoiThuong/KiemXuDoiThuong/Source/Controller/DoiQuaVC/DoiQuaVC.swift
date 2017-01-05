//
//  DoiQuaVC.swift
//  KiemXuDoiThuong
//
//  Created by Doan Dat on 8/11/16.
//  Copyright © 2016 datdv. All rights reserved.
//

import UIKit

class DoiQuaVC: BaseViewController {
    
    @IBOutlet weak var btnRechargePhone: UIButton!
    
    @IBOutlet weak var btnPaypal: UIButton!
    
    @IBOutlet weak var btnPaymentHistory: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if self.navigationController != nil
        {
            self.showMenuButtonNavigationBar()
        }
        
        self.configButton()
        
    }
    
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        if (AppDelegate.paypal_payment_enable != nil && AppDelegate.paypal_payment_enable!)
        {
            self.btnPaypal.hidden = false
        }
        else
        {
            self.btnPaypal.hidden = true
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Private method
    
    func configButton()
    {
        self.btnPaypal.setShadowHidden(false)
        self.btnRechargePhone.setShadowHidden(false)
        self.btnPaymentHistory.setShadowHidden(false)

    }
    
    //MARK - Action
    
    @IBAction func actionRechagePhone(sender: AnyObject)
    {
        let pVC = ReChangePhoneVC(nibName: nil,bundle: nil)
        self.navigationController?.pushViewController(pVC, animated: true)
    }

    @IBAction func actionRechagePaypal(sender: AnyObject)
    {
        let pVC = RechargeByPaypalVC(nibName: nil,bundle: nil)
        self.navigationController?.pushViewController(pVC, animated: true)

    }


    @IBAction func actionPaymentHistory(sender: AnyObject)
    {
        let pVC = PaymentHistoryVC(nibName: nil,bundle: nil)
        self.navigationController?.pushViewController(pVC, animated: true)

    }
    
    
    
}
