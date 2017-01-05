//
//  SystemAdsModel.swift
//  KiemXuDoiThuong
//
//  Created by Doan Dat on 8/25/16.
//  Copyright © 2016 datdv. All rights reserved.
//

import UIKit
import ObjectMapper

class SystemAdsModel:NSObject, Mappable
{
    var request: String?
    var function: String?
    var session_id:String?
    //        = "User.createAccountUsingFacebook"
    var parameters: SystemAdsParameters?
        
    override init()
    {
        super.init()
    }
    
    convenience required init?(_ map: Map)
    {
        self.init()
    }
    
    func mapping(map: Map)
    {
        request <- map["request"]
        function <- map["function"]
        session_id <- map["session_id"]
        parameters <- map["parameters"]
    }
}

class SystemAdsParameters: NSObject, Mappable
{
    var userExecute: SystemAdsUserExecute?
    var inputData: SystemAdsInputData?
    
    override init()
    {
        super.init()
    }
    
    convenience required init?(_ map: Map)
    {
        self.init()
    }
    
    func mapping(map: Map)
    {
        userExecute <- map["userExecute"]
        inputData <- map["inputData"]
    }
    
}

class SystemAdsUserExecute: NSObject, Mappable
{
    var user_id: String?

    override init()
    {
        super.init()
    }
    
    convenience required init?(_ map: Map)
    {
        self.init()
    }
    
    func mapping(map: Map)
    {
        user_id <- map["user_id"]
    }
    
}

class SystemAdsInputData: NSObject, Mappable
{
    //inputData
    var country: String?
    var city: String?
    var language: String?
    var os: String?
    
    override init() {
        super.init()
    }
    
    convenience required init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        country <- map["country"]
        city <- map["city"]
        language <- map["language"]
        os <- map["os"]
    }
}


//MARK: Result

class SystemAdsResult: NSObject, Mappable
{
    //inputData
    var status: String?
    var message: String?
    var data: [DataSystemAdsResult]?
    
    required init?(_ map: Map){
        
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        message <- map["message"]
        data <- map["data"]
    }
}


class DataSystemAdsResult: NSObject, Mappable
{
    //inputData
    var app_url: String?
    var os: String?
    var app_code: String?
    var app_title: String?
    var partner_name: String?
    var desCription: String?
    var app_icon_url: String?
    var available_city: String?
    var app_name: String?
    var available_country: String?
    var app_id: String?
    var app_description: String?
    var coin: String?
    
    override init() {
        super.init()
    }
    
    convenience required init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        app_url <- map["app_url"]
        os <- map["os"]
        app_code <- map["app_code"]
        app_title <- map["app_title"]
        partner_name <- map["partner_name"]
        desCription <- map["description"]
        app_icon_url <- map["app_icon_url"]
        available_city <- map["available_city"]
        app_name <- map["app_name"]
        available_country <- map["available_country"]
        app_id <- map["app_id"]
        app_description <- map["app_description"]
        coin <- map["coin"]
    }
}
