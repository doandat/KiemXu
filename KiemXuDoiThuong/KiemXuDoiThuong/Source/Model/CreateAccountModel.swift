//
//  CreateAccountModel.swift
//  KiemXuDoiThuong
//
//  Created by Doan Dat on 8/23/16.
//  Copyright © 2016 datdv. All rights reserved.
//

import UIKit
import ObjectMapper

class CreateAccountModel:NSObject, Mappable
{
    var request: String?
    var function: String?
//        = "User.createAccountUsingFacebook"
    var parameters: CreateUserParameters?
    
//    //inputData
//    var user_id: String?
//    var username: String?
//    var full_name: String?
//    var country: String?
//    var city: String?
//    var language: String?
//    var desCription: String?
//    var avatar_url: String?
//    var email: String?
//    var phone: String?
//    var os: String?
//    var devices_type_using: String?
//    var sex: String?
//    var age: String?
//    var fiends_list: String?
//    var third_party_id: String?
//    var facebook_user_id: String?
    
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
        parameters <- map["parameters"]
    }
    
    
//    func toDictionaty() -> [String: AnyObject]?
//    {
//        return [
//            "request": self.request,
//            "function": self.function,
//            "parameters" : self.getParameters()
//        ]
//    }
//    
//    func getParameters() -> [String: AnyObject]
//    {
//        let pDict = [String: AnyObject]()
//        return [
//            "userExecute": pDict,
//            "inputData": self.inutDataDict()!
//        ]
//    }
//    
//    
//    func inutDataDict() -> [String: String]?
//    {
//        let user_id     = (self.user_id != nil ? self.user_id! : "")
//        let username    = (self.username != nil ? self.username! : "")
//        let full_name   = (self.full_name != nil ? self.full_name! : "")
//        let country     = (self.country != nil ? self.country! : "")
//        let city        = (self.city != nil ? self.city! : "")
//        let language    = (self.language != nil ? self.language! : "")
//        let desCription = (self.desCription != nil ? self.desCription! : "")
//        let email       = (self.email != nil ? self.email! : "")
//        let phone       = (self.phone != nil ? self.phone! : "")
//        let os          = (self.os != nil ? self.os! : "")
//        let devices_type_using       = (self.devices_type_using != nil ? self.devices_type_using! : "")
//        let sex         = (self.sex != nil ? self.sex! : "")
//        let age         = (self.age != nil ? self.age! : "")
//        let fiends_list = (self.fiends_list != nil ? self.fiends_list! : "")
//        let third_party_id  = "2"
//        let facebook_user_id = (self.facebook_user_id != nil ? self.facebook_user_id! : "")
//        
//        return
//            [
//                "user_id" : user_id,
//                "username" : username,
//                "full_name" : full_name,
//                "country" : country,
//                "city" :city,
//                "language": language,
//                "description" : desCription,
//                "email" :  email,
//                "phone" : phone,
//                "os" : os,
//                "devices_type_using" : devices_type_using,
//                "sex" : sex,
//                "age" : age,
//                "fiends_list" : fiends_list,
//                "third_party_id" : third_party_id,
//                "facebook_user_id" : facebook_user_id
//        ]
//    
//    }
}

class CreateUserParameters: NSObject, Mappable
{
    var userExecute: CreateUserExecute?
    var inputData: CreateUserInputData?
    
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

class CreateUserExecute: NSObject, Mappable
{
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
    }
    
}

class CreateUserInputData: NSObject, Mappable
{
    //inputData
    var user_id: String?
    var username: String?
    var full_name: String?
    var country: String?
    var city: String?
    var language: String?
    var desCription: String?
    var avatar_url: String?
    var email: String?
    var phone: String?
    var os: String?
    var devices_type_using: String?
    var sex: String?
    var age: String?
    var fiends_list: String?
    var third_party_id: String?
    var device_id: String?

    override init() {
        super.init()
    }
    
    convenience required init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        user_id <- map["user_id"]
        username <- map["username"]
        full_name <- map["full_name"]
        country <- map["country"]
        city <- map["city"]
        language <- map["language"]
        desCription <- map["description"]
        avatar_url <- map["avatar_url"]
        email <- map["email"]
        phone <- map["phone"]
        os <- map["os"]
        devices_type_using <- map["devices_type_using"]
        sex <- map["sex"]
        age <- map["age"]
        fiends_list <- map["fiends_list"]
        third_party_id <- map["third_party_id"]
        device_id <- map["device_id"]

    }
}


//MARK: Result

class AccountResult: NSObject, Mappable
{
    //inputData
    var status: String?
    var message: String?
    var session_id: String?
    
    var data: DataAccountResult?
    
    required init?(_ map: Map){
        
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        message <- map["message"]
        session_id <- map["session_id"]
        data <- map["data"]
    }
}


class DataAccountResult: NSObject, Mappable
{
    //inputData
    var user_id: String?
    var username: String?
    var full_name: String?
    var country: String?
    var city: String?
    var language: String?
    var desCription: String?
    var avatar_url: String?
    var email: String?
    var phone: String?
    var os: String?
    var devices_type_using: String?
    var sex: String?
    var age: String?
    var fiends_list: String?
    var third_party_id: String?
    var third_party_type: String?
    var referral_code: String?
    
    var account: Account?
    
    var app_config: AppConfig?
    
    override init() {
        super.init()
    }
    
    convenience required init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        user_id <- map["user_id"]
        username <- map["username"]
        full_name <- map["full_name"]
        country <- map["country"]
        city <- map["city"]
        language <- map["language"]
        desCription <- map["description"]
        avatar_url <- map["avatar_url"]
        email <- map["email"]
        phone <- map["phone"]
        os <- map["os"]
        devices_type_using <- map["devices_type_using"]
        sex <- map["sex"]
        age <- map["age"]
        fiends_list <- map["fiends_list"]
        third_party_id <- map["third_party_id"]
        third_party_type <- map["third_party_type"]
        referral_code <- map["referral_code"]
        account <- map["account"]
        app_config <- map["app_config"]

    }
}

class Account: NSObject, Mappable
{
    //inputData
    var user_id: String?
    var account_id: String?
    var balance: String?
    
    override init() {
        super.init()
    }
    
    convenience required init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        user_id <- map["user_id"]
        account_id <- map["account_id"]
        balance <- map["balance"]
    }
}


class AppConfig: NSObject, Mappable
{
    //inputData
    var startapp_enable: Bool?
    var startapp_id: String?
    var startapp_coin_install: Float?
    var appnext_enable: Bool?
    var appnext_id: String?
    var appnext_coin_install_rate: Float?
    var pollfish_enable: Bool?
    var pollfish_id: String?
    var pollfish_coin_completed_long_survey: Float?
    var pollfish_coin_completed_short_survey: Float?
    var pollfish_coin_rate: Float?
    var trialpay_enable: Bool?
    var trialpay_id: String?
    var trialpay_coin_rate: Float?
    var adcolony_enable: Bool?
    var adcolony_app_id: String?
    var adcolony_zone_id: String?
    var adcolony_coin_rate: Float?
    var adcolony_received_video_coin: Float?
    var paypal_payment_enable: Bool?
    var recharge_option_values: String?
    var paypal_payment_opion_values: String?
    var exchange_rate_usd_coin: Float?

    override init() {
        super.init()
    }
    
    convenience required init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        startapp_enable <- map["startapp_enable"]
        startapp_id <- map["startapp_id"]
        startapp_coin_install <- map["startapp_coin_install"]
        appnext_enable <- map["appnext_enable"]
        appnext_id <- map["appnext_id"]
        appnext_coin_install_rate <- map["appnext_coin_install_rate"]
        pollfish_enable <- map["pollfish_enable"]
        pollfish_id <- map["pollfish_id"]
        pollfish_coin_completed_long_survey <- map["pollfish_coin_completed_long_survey"]
        pollfish_coin_completed_short_survey <- map["pollfish_coin_completed_short_survey"]
        pollfish_coin_rate <- map["pollfish_coin_rate"]
        trialpay_enable <- map["trialpay_enable"]
        trialpay_id <- map["trialpay_id"]
        trialpay_coin_rate <- map["trialpay_coin_rate"]
        adcolony_enable <- map["adcolony_enable"]
        adcolony_app_id <- map["adcolony_app_id"]
        adcolony_zone_id <- map["adcolony_zone_id"]
        adcolony_coin_rate <- map["adcolony_coin_rate"]
        adcolony_received_video_coin <- map["adcolony_received_video_coin"]
        paypal_payment_enable <- map["paypal_payment_enable"]
        recharge_option_values <- map["recharge_option_values"]
        paypal_payment_opion_values <- map["paypal_payment_opion_values"]
        exchange_rate_usd_coin <- map["exchange_rate_usd_coin"]

    }
}