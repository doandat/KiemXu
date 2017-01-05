//
//  ReferralCodeModel.swift
//  KiemXuDoiThuong
//
//  Created by Doan Dat on 8/25/16.
//  Copyright © 2016 datdv. All rights reserved.
//

import UIKit
import ObjectMapper

class ReferralCodeModel:NSObject, Mappable
{
    var request: String?
    var function: String?
    var session_id:String?
    var parameters: ReferralCodeParameters?
    
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

class ReferralCodeParameters: NSObject, Mappable
{
    var userExecute: ReferralCodeUserExecute?
    var inputData: ReferralCodeInputData?
    
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

class ReferralCodeUserExecute: NSObject, Mappable
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

class ReferralCodeInputData: NSObject, Mappable
{
    //inputData
    var referral_code: String?
    
    override init() {
        super.init()
    }
    
    convenience required init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map)
    {
        referral_code <- map["referral_code"]
    }
}


//MARK: Result

class ReferralCodeResult: NSObject, Mappable
{
    //inputData
    var status: String?
    var message: String?
    var data: DataReferralCodeResult?
    
    required init?(_ map: Map){
        
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        message <- map["message"]
        data <- map["data"]
    }
}

class DataReferralCodeResult: NSObject, Mappable
{
    //inputData
    var account: Account?
    
    required init?(_ map: Map){
        
    }
    
    func mapping(map: Map)
    {
        account <- map["account"]
    }
}
