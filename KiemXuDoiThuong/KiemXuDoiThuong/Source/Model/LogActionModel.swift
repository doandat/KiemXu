//
//  LogActionModel.swift
//  KiemXuDoiThuong
//
//  Created by Doan Dat on 8/25/16.
//  Copyright © 2016 datdv. All rights reserved.
//

import UIKit
import ObjectMapper

class LogActionModel:NSObject, Mappable
{
    var request: String?
    var function: String?
    var session_id:String?
    var parameters: LogActionParameters?
    
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

class LogActionParameters: NSObject, Mappable
{
    var userExecute: LogActionUserExecute?
    var inputData: LogActionInputData?
    
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

class LogActionUserExecute: NSObject, Mappable
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

class LogActionInputData: NSObject, Mappable
{
    //inputData
    var action_code: String?
    
    override init() {
        super.init()
    }
    
    convenience required init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map)
    {
        action_code <- map["action_code"]
    }
}


//MARK: Result

class LogActionResult: NSObject, Mappable
{
    //inputData
    var status: String?
    var message: String?
    var data: DataLogActionResult?
    
    required init?(_ map: Map){
        
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        message <- map["message"]
        data <- map["data"]
    }
}

class DataLogActionResult: NSObject, Mappable
{
    required init?(_ map: Map){
        
    }
    
    func mapping(map: Map)
    {
    }
}
