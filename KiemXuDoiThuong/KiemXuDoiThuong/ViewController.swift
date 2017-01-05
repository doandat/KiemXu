//
//  ViewController.swift
//  KiemXuDoiThuong
//
//  Created by Doan Dat on 8/10/16.
//  Copyright © 2016 datdv. All rights reserved.
//

import UIKit

class ViewController: UIViewController, AdColonyAdDelegate{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.updateCurrencyBalance()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.addObservers), name: UIApplicationWillEnterForegroundNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.removeObservers), name: UIApplicationDidEnterBackgroundNotification, object: nil)
        self.addObservers()
    }
    
    override func viewWillDisappear(animated:Bool) {
        super.viewWillDisappear(animated)
        print("viewWillDisappear()")
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //=============================================
    // MARK:- UI Updates
    //=============================================
    
    func addObservers()
    {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.updateCurrencyBalance), name: Constants.currencyBalanceChange, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.zoneReady), name: Constants.zoneReady, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.zoneOff), name: Constants.zoneOff, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.zoneLoading), name: Constants.zoneLoading, object: nil)
    }
    
    func removeObservers()
    {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: Constants.zoneLoading, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: Constants.zoneOff, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: Constants.zoneReady, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: Constants.currencyBalanceChange, object: nil)
    }
    
    func zoneReady()
    {
        
    }
    
    func zoneOff()
    {
        
    }
    
    func zoneLoading()
    {
        
    }
    
    
    func updateCurrencyBalance()
    {
        //Get currency balance from persistent storage and display it
        if let wrappedBalance = NSUserDefaults.standardUserDefaults().objectForKey(Constants.currencyBalance) as! NSNumber? {
            
        } else {
            
        }
    }
    
    
    @IBAction func actionButton(sender: AnyObject)
    {
        AdColony.playVideoAdForZone(Constants.adcolonyZoneID, withDelegate: self, withV4VCPrePopup: true, andV4VCPostPopup: true)
        
    }
    
    func onAdColonyAdAttemptFinished(shown: Bool, inZone zoneID: String)
    {
        if !shown && AdColony.zoneStatusForZone(Constants.adcolonyZoneID) != ADCOLONY_ZONE_STATUS.ACTIVE {
            self.zoneLoading()
        } else if !shown {
            self.zoneReady()
        }
    }
}