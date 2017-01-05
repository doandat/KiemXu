//
//  SendFeedbackModel.swift
//  KiemXuDoiThuong
//
//  Created by Doan Dat on 8/25/16.
//  Copyright © 2016 datdv. All rights reserved.
//

import UIKit
import ObjectMapper

class SendFeedbackModel:NSObject, Mappable
{
    var request: String?
    var function: String?
    var session_id:String?
    var parameters: SendFeedbackParameters?
    
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

class SendFeedbackParameters: NSObject, Mappable
{
    var userExecute: SendFeedbackUserExecute?
    var inputData: SendFeedbackInputData?
    
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

class SendFeedbackUserExecute: NSObject, Mappable
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

class SendFeedbackInputData: NSObject, Mappable
{
    //inputData
    var message: String?
    
    override init() {
        super.init()
    }
    
    convenience required init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map)
    {
        message <- map["message"]
    }
}


//MARK: Result

class SendFeedbackResult: NSObject, Mappable
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
