//
//  InstallFinishedModel.swift
//  KiemXuDoiThuong
//
//  Created by Doan Dat on 8/25/16.
//  Copyright © 2016 datdv. All rights reserved.
//

import UIKit
import ObjectMapper

class InstallFinishedModel:NSObject, Mappable
{
    var request: String?
    var function: String?
    var session_id:String?
    var parameters: InstallFinishedParameters?
    
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

class InstallFinishedParameters: NSObject, Mappable
{
    var userExecute: InstallFinishedUserExecute?
    var inputData: InstallFinishedInputData?
    
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

class InstallFinishedUserExecute: NSObject, Mappable
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

class InstallFinishedInputData: NSObject, Mappable
{
    //inputData
    var app_id: String?
    var app_code: String?
    var app_name: String?
    var os: String?
    var country: String?
    var city: String?
    var from_ads_network: String?
    var coin: String?
    var revenue_rate: String?

    override init() {
        super.init()
    }
    
    convenience required init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        app_id <- map["app_id"]
        app_code <- map["app_code"]
        app_name <- map["app_name"]
        os <- map["os"]
        country <- map["country"]
        city <- map["city"]
        from_ads_network <- map["from_ads_network"]
        coin <- map["coin"]
        revenue_rate <- map["revenue_rate"]

    }
}


//MARK: Result

class InstallFinishedResult: NSObject, Mappable
{
    //inputData
    var status: String?
    var message: String?
    var account: Account?
    
    required init?(_ map: Map){
        
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        message <- map["message"]
        account <- map["account"]
    }
}



