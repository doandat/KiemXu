//
//  GetInstallAppsHistoryModel.swift
//  KiemXuDoiThuong
//
//  Created by Doan Dat on 8/25/16.
//  Copyright © 2016 datdv. All rights reserved.
//

import UIKit
import ObjectMapper

class GetInstallAppsHistoryModel:NSObject, Mappable
{
    var request: String?
    var function: String?
    var session_id:String?
    var parameters: GetInstallAppsHistoryParameters?
    
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

class GetInstallAppsHistoryParameters: NSObject, Mappable
{
    var userExecute: GetInstallAppsHistoryUserExecute?
    var inputData: GetInstallAppsHistoryInputData?
    
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

class GetInstallAppsHistoryUserExecute: NSObject, Mappable
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

class GetInstallAppsHistoryInputData: NSObject, Mappable
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

class GetInstallAppsHistoryResult: NSObject, Mappable
{
    //inputData
    var status: String?
    var message: String?
    var data: DataGetInstallAppsHistoryResult?
    
    required init?(_ map: Map){
        
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        message <- map["message"]
        data <- map["data"]
    }
}


class DataGetInstallAppsHistoryResult: NSObject, Mappable
{
    //inputData
    var install_apps_history: [DataInstallAppsHistoryResult]?
    
    override init() {
        super.init()
    }
    
    convenience required init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        install_apps_history <- map["getCoin_history"]
    }
}

class DataInstallAppsHistoryResult: NSObject, Mappable
{
    //inputData
    var date: String?
    var app_name: String?
    var app_code: String?
    var app_icon_url: String?
    var added_coin: String?
    
    override init() {
        super.init()
    }
    
    convenience required init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        date <- map["date"]
        app_name <- map["app_name"]
        app_code <- map["app_code"]
        app_icon_url <- map["app_icon_url"]
        added_coin <- map["added_coin"]
        
    }
}

