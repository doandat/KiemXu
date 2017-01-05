//
//  ReportErrorRechargeModel.swift
//  KiemXuDoiThuong
//
//  Created by Doan Dat on 8/25/16.
//  Copyright © 2016 datdv. All rights reserved.
//

import UIKit
import ObjectMapper

class ReportErrorRechargeModel:NSObject, Mappable
{
    var request: String?
    var function: String?
    var session_id:String?
    var parameters: ReportErrorRechargeParameters?
    
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

class ReportErrorRechargeParameters: NSObject, Mappable
{
    var userExecute: ReportErrorRechargeUserExecute?
    var inputData: ReportErrorRechargeInputData?
    
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

class ReportErrorRechargeUserExecute: NSObject, Mappable
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

class ReportErrorRechargeInputData: NSObject, Mappable
{
    //inputData
    var trans_id: String?
    var message: String?
    
    override init() {
        super.init()
    }
    
    convenience required init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map)
    {
        trans_id <- map["trans_id"]
        message <- map["message"]
    }
}


//MARK: Result

class ReportErrorRechargeResult: NSObject, Mappable
{
    //inputData
    var status: String?
    var message: String?
    
    required init?(_ map: Map){
        
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        message <- map["message"]
    }
}
