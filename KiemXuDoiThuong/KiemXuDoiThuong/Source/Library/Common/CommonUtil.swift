//
//  CommonUtil.swift
//  KiemXuDoiThuong
//
//  Created by Doan Dat on 8/23/16.
//  Copyright © 2016 datdv. All rights reserved.
//

import UIKit

class CommonUtil: NSObject {
    
    static func toBase64(let stringToEncode:String)->String{
        
        let data = stringToEncode.dataUsingEncoding(NSUTF8StringEncoding)
        
        return data!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
        
    }
}
