//
//  AddMoreCoin.swift
//  KiemXuDoiThuong
//
//  Created by DatDV on 9/15/16.
//  Copyright © 2016 datdv. All rights reserved.
//


import UIKit
import ObjectMapper

class AddMoreCoinModel:NSObject, Mappable
{
    var request: String?
    var function: String?
    var session_id:String?
    var parameters: AddMoreCoinParameters?
    
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

class AddMoreCoinParameters: NSObject, Mappable
{
    var userExecute: AddMoreCoinUserExecute?
    var inputData: AddMoreCoinInputData?
    
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

class AddMoreCoinUserExecute: NSObject, Mappable
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

class AddMoreCoinInputData: NSObject, Mappable
{
    //inputData
    var add_coin: String?
    var work_type: String?
    var data: String?

    override init() {
        super.init()
    }
    
    convenience required init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map)
    {
        add_coin <- map["add_coin"]
        work_type <- map["work_type"]
        data <- map["data"]
    }
}


//MARK: Result

class AddMoreCoinResult: NSObject, Mappable
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
        account <- map["data"]
    }
}
