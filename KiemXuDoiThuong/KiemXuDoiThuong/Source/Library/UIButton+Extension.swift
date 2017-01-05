//
//  UIButton+Extension.swift
//  KiemXuDoiThuong
//
//  Created by DatDV on 9/15/16.
//  Copyright © 2016 datdv. All rights reserved.
//

import Foundation

import UIKit


extension UIButton
{

    func setShadowHidden(isHidden:Bool){
        if !isHidden {
            self.layer.shadowColor = UIColor.blackColor().CGColor
            self.layer.shadowOpacity = 0.3;
            self.layer.shadowRadius = 1.5;
            self.layer.shadowOffset = CGSizeMake(3.0,3.0);
        } else {
            self.layer.shadowColor = UIColor.clearColor().CGColor;
        }
    }
}