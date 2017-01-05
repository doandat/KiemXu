//
//  RechargeModel.swift
//  KiemXuDoiThuong
//
//  Created by Doan Dat on 8/25/16.
//  Copyright © 2016 datdv. All rights reserved.
//

import UIKit
import ObjectMapper

class RechargeModel:NSObject, Mappable
{
    var request: String?
    var function: String?
    var session_id:String?
    var parameters: RechargeParameters?
    
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

class RechargeParameters: NSObject, Mappable
{
    var userExecute: RechargeUserExecute?
    var inputData: RechargeInputData?
    
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

class RechargeUserExecute: NSObject, Mappable
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

class RechargeInputData: NSObject, Mappable
{
    //inputData
    var recharge_type: String?
    var operaTor: String?
    var subscriber_number: String?
    var amount: String?

    override init() {
        super.init()
    }
    
    convenience required init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map)
    {
        recharge_type <- map["recharge_type"]
        operaTor <- map["operator"]
        subscriber_number <- map["subscriber_number"]
        amount <- map["amount"]

    }
}


//MARK: Result

class RechargeResult: NSObject, Mappable
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
