//
//  RVDelegate.swift
//  TestSupersonic
//
//  Created by DatDV on 11/14/16.
//  Copyright © 2016 com. All rights reserved.
//

import UIKit

class RVDelegate: UIViewController, SupersonicRVDelegate{

    var placementInfo:SupersonicPlacementInfo?
    
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
    
    func supersonicRVInitSuccess()
    {
        print("supersonicRVInitSuccess")
    }
    
    func supersonicRVInitFailedWithError(error: NSError!) {
        print("supersonicRVInitFailedWithError");
    }
    
    func supersonicRVAdAvailabilityChanged(hasAvailableAds: Bool) {
        print("hasAvailableAds:\(hasAvailableAds)")
    }

    func supersonicRVAdRewarded(placementInfo: SupersonicPlacementInfo!) {
        print("supersonicRVAdRewarded:\(supersonicRVAdRewarded)");
        self.placementInfo = placementInfo
    }
    
    
    func supersonicRVAdFailedWithError(error: NSError!) {
        print("supersonicRVAdFailedWithError")
    }
    
    func supersonicRVAdOpened() {
        print("supersonicRVAdOpened")
    }
    
    func supersonicRVAdClosed() {
        print("supersonicRVAdClosed");
        
        if self.placementInfo != nil
        {
            /////You have been rewarded
            
            
            self.placementInfo = nil;
        }
        
    }
    
    func supersonicRVAdStarted() {
        print("supersonicRVAdStarted")
    }
    
    func supersonicRVAdEnded() {
        print("supersonicRVAdEnded")
    }
    
}
