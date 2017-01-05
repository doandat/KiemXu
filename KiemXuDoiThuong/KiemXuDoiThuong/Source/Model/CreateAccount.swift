//
//  CreateAccount.swift
//  KiemXuDoiThuong
//
//  Created by Doan Dat on 8/21/16.
//  Copyright © 2016 datdv. All rights reserved.
//

import UIKit
import ObjectMapper

class CreateAccount: NSObject,Mappable {

    let request = "api"
    let function = "User.createAccountUsingFacebook"
    
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
    var facebook_user_id: String?
    
    override init() {
        super.init()
    }
    
    convenience required init?(_ map: Map) {
        self.init()
    }
    
    
    func mapping(map: Map) {
//        link <- map["link"]
//        id <- map["id"]
//        thumb <- map["thumb"]
    }
    
    func toDictionaty() -> [String: AnyObject]?
    {
        return [
            "request": self.request,
            "function": self.function,
            "parameters" : self.getParameters()
        ]
    }
    
    func getParameters() -> [String: AnyObject]
    {
        let pDict = [String: AnyObject]()
        return [
            "userExecute": pDict,
            "inputData": self.inutDataDict()!
        ]
    }
    
    
    func inutDataDict() -> [String: String]?
    {
        let user_id     = (self.user_id != nil ? self.user_id! : "")
        let username    = (self.username != nil ? self.username! : "")
        let full_name   = (self.full_name != nil ? self.full_name! : "")
        let country     = (self.country != nil ? self.country! : "")
        let city        = (self.city != nil ? self.city! : "")
        let language    = (self.language != nil ? self.language! : "")
        let desCription = (self.desCription != nil ? self.desCription! : "")
        let email       = (self.email != nil ? self.email! : "")
        let phone       = (self.phone != nil ? self.phone! : "")
        let os          = (self.os != nil ? self.os! : "")
        let devices_type_using       = (self.devices_type_using != nil ? self.devices_type_using! : "")
        let sex         = (self.sex != nil ? self.sex! : "")
        let age         = (self.age != nil ? self.age! : "")
        let fiends_list = (self.fiends_list != nil ? self.fiends_list! : "")
        let third_party_id  = "2"
        let facebook_user_id = (self.facebook_user_id != nil ? self.facebook_user_id! : "")

        return
            [
                "user_id" : user_id,
                "username" : username,
                "full_name" : full_name,
                "country" : country,
                "city" :city,
                "language": language,
                "description" : desCription,
                "email" :  email,
                "phone" : phone,
                "os" : os,
                "devices_type_using" : devices_type_using,
                "sex" : sex,
                "age" : age,
                "fiends_list" : fiends_list,
                "third_party_id" : third_party_id,
                "facebook_user_id" : facebook_user_id
        ]
        
    }
    
}


