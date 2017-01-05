//
//  ReportErrorPaypalPaymentModel.swift
//  KiemXuDoiThuong
//
//  Created by Doan Dat on 8/25/16.
//  Copyright © 2016 datdv. All rights reserved.
//

import UIKit
import ObjectMapper

class ReportErrorPaypalPaymentModel:NSObject, Mappable
{
    var request: String?
    var function: String?
    var session_id:String?
    var parameters: ReportErrorPaypalPaymentParameters?
    
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

class ReportErrorPaypalPaymentParameters: NSObject, Mappable
{
    var userExecute: ReportErrorPaypalPaymentUserExecute?
    var inputData: ReportErrorPaypalPaymentInputData?
    
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

class ReportErrorPaypalPaymentUserExecute: NSObject, Mappable
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

class ReportErrorPaypalPaymentInputData: NSObject, Mappable
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

class ReportErrorPaypalPaymentResult: NSObject, Mappable
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
