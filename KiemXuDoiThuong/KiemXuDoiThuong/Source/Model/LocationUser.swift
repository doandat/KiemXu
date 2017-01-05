//
//  LocationUser.swift
//  KiemXuDoiThuong
//
//  Created by DatDV on 9/14/16.
//  Copyright © 2016 datdv. All rights reserved.
//

import UIKit
import ObjectMapper

class LocationUser: Mappable {
    var city: String?
    var country: String?
    var countryCode: String?
    
    required init?(_ map: Map){
        
    }
    
    func mapping(map: Map) {
        city <- map["city"]
        country <- map["country"]
        countryCode <- map["countryCode"]
    }

}
