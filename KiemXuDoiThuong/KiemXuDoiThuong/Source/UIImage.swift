//
//  UIImage.swift
//  KiemXuDoiThuong
//
//  Created by Doan Dat on 8/13/16.
//  Copyright © 2016 datdv. All rights reserved.
//

import Foundation

extension UIImage {
    
    class func imageWithColor(color: UIColor, size: CGSize) -> UIImage {
        let rect: CGRect = CGRectMake(0, 0, size.width, size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
}