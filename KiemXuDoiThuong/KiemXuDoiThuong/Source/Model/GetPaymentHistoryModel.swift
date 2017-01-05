//
//  GetPaymentHistoryModel.swift
//  KiemXuDoiThuong
//
//  Created by Doan Dat on 8/25/16.
//  Copyright © 2016 datdv. All rights reserved.
//

import UIKit
import ObjectMapper

class GetPaymentHistoryModel:NSObject, Mappable
{
    var request: String?
    var function: String?
    var session_id:String?
    var parameters: GetPaymentHistoryParameters?
    
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

class GetPaymentHistoryParameters: NSObject, Mappable
{
    var userExecute: GetPaymentHistoryUserExecute?
    var inputData: GetPaymentHistoryInputData?
    
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

class GetPaymentHistoryUserExecute: NSObject, Mappable
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

class GetPaymentHistoryInputData: NSObject, Mappable
{
    //inputData
    
    override init() {
        super.init()
    }
    
    convenience required init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
    }
}


//MARK: Result

class GetPaymentHistoryResult: NSObject, Mappable
{
    //inputData
    var status: String?
    var message: String?
    var data: DataGetPaymentHistoryResult?
    
    required init?(_ map: Map){
        
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        message <- map["message"]
        data <- map["data"]
    }
}


class DataGetPaymentHistoryResult: NSObject, Mappable
{
    //inputData
    var payment_history: [DataPaymentHistoryResult]?
    
    override init() {
        super.init()
    }
    
    convenience required init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        payment_history <- map["payment_history"]
    }
}

class DataPaymentHistoryResult: NSObject, Mappable
{
    var trans_id: String?
    var payment_type: String?
    var currency: String?
    var amount: String?
    var date: String?
    var received_acc: String?
    var minus_coin: String?

    override init() {
        super.init()
    }
    
    convenience required init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        trans_id <- map["trans_id"]
        payment_type <- map["payment_type"]
        currency <- map["currency"]
        amount <- map["amount"]
        date <- map["date"]
        received_acc <- map["received_acc"]
        minus_coin <- map["minus_coin"]

    }
}

