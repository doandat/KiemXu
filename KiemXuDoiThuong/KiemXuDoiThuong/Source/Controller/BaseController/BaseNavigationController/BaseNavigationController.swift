//
//  BaseNavigationController.swift
//  BaseProject
//
//  Created by Doan Dat on 8/6/16.
//  Copyright © 2016 datdv. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationBar.translucent  = false
        self.navigationBar.opaque       = true
        self.navigationBar.tintColor    = UIColor.whiteColor()
        self.navigationBar.barTintColor = UIColor.init(colorLiteralRed: 51.0/255.0, green: 85.0/255.0, blue: 187.0/255.0, alpha: 1.0)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func showShadowNav(value: Bool)
    {
        self.navigationBar.layer.shadowColor = value ? UIColor.blackColor().CGColor : UIColor.clearColor().CGColor
        self.navigationBar.layer.shadowOffset = CGSizeMake(0.0, 1.0)
        self.navigationBar.layer.shadowOpacity = 0.5;
        
    }


}
