//
//  Test.swift
//  BaseProject
//
//  Created by Doan Dat on 8/10/16.
//  Copyright © 2016 datdv. All rights reserved.
//

import Foundation
import ObjectMapper

class Test: Mappable {
    
    var success: String?
    
    var categoryItem: [ThemeList]?
    
    required init?(_ map: Map){
    
    }
    
    func mapping(map: Map) {
        categoryItem <- map["theme_list"]
        success <- map["success"];
    }
}

class ThemeList: NSObject,Mappable {
    var link: String?
    var id: Int?
    var thumb: String?
    var page: String?
    var category_id: String?
    
//    required init?(_ map: Map){
//        
//    }
    
    override init() {
        super.init()
    }
    
    convenience required init?(_ map: Map) {
        self.init()
    }
    
    
    func mapping(map: Map) {
        link <- map["link"]
        id <- map["id"]
        thumb <- map["thumb"]
    }
    
    func toDictionaty() -> [String: String]?
    {
        let pageStr = (self.page != nil ? self.page! : "")
        let category_id = (self.category_id != nil ? self.category_id! : "")
        return [
            "page": pageStr,
            "category_id": category_id
        ]
    }
}
