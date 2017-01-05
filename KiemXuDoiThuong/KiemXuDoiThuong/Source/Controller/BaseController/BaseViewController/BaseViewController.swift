//
//  BaseViewController.swift
//  BaseProject
//
//  Created by Doan Dat on 8/6/16.
//  Copyright © 2016 datdv. All rights reserved.
//

import UIKit
import SVProgressHUD
import SDWebImage

class BaseViewController: UIViewController
{

    var isShowLeftMenu: Bool?
    
    var leftBackButton: UIButton?
    
    var leftMenuButton: UIButton?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if (self.navigationController == nil) {
            return;
        }
        let baseNavigation:BaseNavigationController = self.navigationController as! BaseNavigationController
        
        baseNavigation.showShadowNav(true)
        
//        self.configLeftBarButton()
        
        self.navigationItem.title = "EarnMoney_IN"
        
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        baseNavigation.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject]

    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(BaseViewController.methodOfReceivedNotificationCallApiErr(_:)), name:kNotificationCenterCallApiErr, object: nil)

        
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: kNotificationCenterCallApiErr, object: nil)

    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    func hideButtonNavigationBar()
    {
//        self.navigationItem.setLeftBarButtonItems(nil, animated: true)
        
    }
    
    func showBackButtonNavigationBarTypePop()
    {
        leftBackButton = UIButton(type: UIButtonType.Custom)
        leftBackButton!.setImage(UIImage(named: "icon_back_button"), forState: UIControlState.Normal)
        leftBackButton!.frame = CGRectMake(0, 0, 30, 30)
        leftBackButton!.addTarget(self, action: #selector(backAction), forControlEvents: .TouchUpInside)
        
        let barButton = UIBarButtonItem(customView: leftBackButton!)
        let fixedSpace: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        fixedSpace.width = -15.0
        
        
        self.navigationItem.setLeftBarButtonItems([fixedSpace,barButton], animated: true)

    }
    
    func showBackButtonNavigationBarTypeDismiss()
    {
        leftBackButton = UIButton(type: UIButtonType.Custom)
        leftBackButton!.setImage(UIImage(named: "icon_back_button"), forState: UIControlState.Normal)
        leftBackButton!.frame = CGRectMake(0, 0, 30, 30)
        leftBackButton!.addTarget(self, action: #selector(backDismissAction), forControlEvents: .TouchUpInside)
        
        let barButton = UIBarButtonItem(customView: leftBackButton!)
        let fixedSpace: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        fixedSpace.width = -15.0
        
        
        self.navigationItem.setLeftBarButtonItems([fixedSpace,barButton], animated: true)
        
    }
    
    
    func showMenuButtonNavigationBar()
    {
        leftMenuButton = UIButton(type: UIButtonType.Custom)
        
        leftMenuButton!.setImage(UIImage(named: "btn_menu"), forState: UIControlState.Normal)
        
        leftMenuButton!.frame = CGRectMake(0, 0, 18, 30)
        
        leftMenuButton!.addTarget(self, action: #selector(menuAction), forControlEvents: .TouchUpInside)
        
        let barButton = UIBarButtonItem(customView: leftMenuButton!)
        
        self.navigationItem.setLeftBarButtonItems([barButton], animated: true)
        
    }
    
    func configLeftBarButton()
    {
        leftMenuButton = UIButton(type: UIButtonType.Custom)
        leftMenuButton!.setImage(UIImage(named: "btn_menu"), forState: UIControlState.Normal)
        leftMenuButton!.frame = CGRectMake(0, 0, 18, 30)
        leftMenuButton!.addTarget(self, action: #selector(menuAction), forControlEvents: .TouchUpInside)

        leftBackButton = UIButton(type: UIButtonType.Custom)
        leftBackButton!.setImage(UIImage(named: "icon_back_button"), forState: UIControlState.Normal)
        leftBackButton!.frame = CGRectMake(0, 0, 30, 30)
        leftBackButton!.addTarget(self, action: #selector(backAction), forControlEvents: .TouchUpInside)

        let menuButton = UIBarButtonItem(customView: leftMenuButton!)
        let backButton = UIBarButtonItem(customView: leftBackButton!)
        
        let fixedSpace: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        fixedSpace.width = -15.0
        
        let baseNavigation:BaseNavigationController = self.navigationController as! BaseNavigationController

        baseNavigation.navigationItem.setLeftBarButtonItems([fixedSpace,backButton, menuButton], animated: true)
        self.navigationController?.navigationItem.setLeftBarButtonItems([fixedSpace,backButton, menuButton], animated: true)
        self.navigationItem.setLeftBarButtonItems([fixedSpace,backButton, menuButton], animated: true)
        print("a");
    }
    
    
    // MARK: Acion Button
    
    func menuAction(sender: UIButton!) {
        print("Menu tapped")
        self.menuContainerViewController.toggleLeftSideMenuCompletion{}
        
        
    }
    
    func backAction(sender: UIButton!) {
        print("Back tapped")
        self.navigationController?.popViewControllerAnimated(true)
    }

    func backDismissAction(sender: UIButton!) {
        print("Back tapped")
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }

    
    //MARK : progressHUD
    
//    func showLoading()
//    {
//        dispatch_async(dispatch_get_main_queue(), {
//            SVProgressHUD.show()
//        })
//    }
//    
//    func hideLoading()
//    {
//        dispatch_async(dispatch_get_main_queue(), {
//            SVProgressHUD.dismiss()
//        })
//        
//    }
    
    //MARK: ReceiveNotificationCenter
    
    func methodOfReceivedNotificationCallApiErr(notification: NSNotification){
        //Take Action on Notification Call Api Err
        let message = notification.object as! String
        
        let alert = UIAlertController(title: "Kiem Tien", message: "Interrupted internet connection", preferredStyle: UIAlertControllerStyle.Alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        
        // show the alert
        self.presentViewController(alert, animated: true, completion: nil)

        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

        appDelegate.hideLoading();
        
    }

}
