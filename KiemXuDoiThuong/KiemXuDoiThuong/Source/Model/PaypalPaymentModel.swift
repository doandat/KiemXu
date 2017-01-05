//
//  PaypalPaymentModel.swift
//  KiemXuDoiThuong
//
//  Created by Doan Dat on 8/25/16.
//  Copyright © 2016 datdv. All rights reserved.
//

import UIKit
import ObjectMapper

class PaypalPaymentModel:NSObject, Mappable
{
    var request: String?
    var function: String?
    var session_id:String?
    var parameters: PaypalPaymentParameters?
    
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

class PaypalPaymentParameters: NSObject, Mappable
{
    var userExecute: PaypalPaymentUserExecute?
    var inputData: PaypalPaymentInputData?
    
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

class PaypalPaymentUserExecute: NSObject, Mappable
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

class PaypalPaymentInputData: NSObject, Mappable
{
    //inputData
    var paypal_id: String?
    var amount: String?

    override init() {
        super.init()
    }
    
    convenience required init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map)
    {
        paypal_id <- map["paypal_id"]
        amount <- map["amount"]
    }
}


//MARK: Result

class PaypalPaymentResult: NSObject, Mappable
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
