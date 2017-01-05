//
//  Constants.swift
//  KiemXuDoiThuong
//
//  Created by Doan Dat on 8/15/16.
//  Copyright © 2016 datdv. All rights reserved.
//

import Foundation

let kNotificationCenterCallApiErr   = "NotificationCenterCallApiErr"
let kNotificationCenterChangeCoin   = "NotificationCenterChangeCoin"
let kNotificationCenterInputedCode  = "NotificationCenterInputedCode"

let kStrUserId:String               = "user_id"
let kStrAppId:String                = "appId"
let kStrAuthenticationToken:String  = "authenticationToken"
let kStrUserName:String             = "username"
let kStrFullName:String             = "full_name"
let kStrCountry:String              = "country"
let kStrCountryCode:String          = "country_code"
let kStrCity:String                 = "city"
let kStrLanguage:String             = "language"
let kStrAvatarUrl:String            = "avatar_url"
let kStrEmail:String                = "email"
let kStrPhone:String                = "phone"
let kStrDevicesTypeUsing:String     = "devices_type_using"
let kStrSex:String                  = "sex"
let kStrAge:String                  = "age"
let kStrFiendsList:String           = "fiends_list"
let kStrThirdPartyId:String         = "third_party_id"
let kStrReferralCode                = "referral_code"
let kStrbalance                     = "balance"
let kStrInputedReferralCode         = "InputedReferralCode"


let kStrWorkTypePollFish            = "Completed_PollFish_Survey"
let kStrWorkTypeAdColony            = "AdColony_video_reward"
let kStrWorkTypeTrialpay            = "Trialpay_reward"



//let kUrlApi: String = "https://192.99.69.89/EarnMoneyServices/api.jsp?data="

let kUrlApi: String = "http://inearnmoney.lovesound.space/EarnMoneyServices/api.jsp?data="
let kUrlIP: String = "http://ip-api.com/json"

let arrCategoryPhone = ["Prepaid","PostPaid"]

//let arrReCharge = ["1000Rs","5000Rs","10000Rs"];
//
//let arrReChargeKey = ["1000","5000","10000"];
//

let arrPrepaidValue:[String] = ["AIRTEL", "BSNL","BSNL SPECIAL","IDEA (B2B)","IDEA (B2C)","VODAFONE","RELIANCE CDMA","RELIANCE GSM","UNINOR","UNINOR SPECIAL","MTS","AIRCEL","TATA DOCOMO GSM","TATA DOCOMO GSM SPECIAL","TATA INDICOM (CDMA)","MTNL DELHI","MTNL DELHI SPECIAL","MTNL MUMBAI","MTNL MUMBAI SPECIAL","VIDEOCON","VIDEOCON SPECIAL","VIRGIN GSM ","VIRGIN GSM SPECIAL","VIRGIN CDMA","T24","T24 SPECIAL","TATA WALKY"]

let arrPrepaid:[(String, String)] = [("AIRTEL", "AT"),("BSNL","BS"),("BSNL SPECIAL","BSS"),("IDEA (B2B)","IDX"),("IDEA (B2C)","IDY"),("VODAFONE","VF"),("RELIANCE CDMA","RL"),("RELIANCE GSM","RG"),("UNINOR","UN"),("UNINOR SPECIAL","UNS"),("MTS","MS"),("AIRCEL","AL"),("TATA DOCOMO GSM","TD"),("TATA DOCOMO GSM SPECIAL","TDS"),("TATA INDICOM (CDMA)","TI"),("MTNL DELHI","MTD"),("MTNL DELHI SPECIAL","MTDS"),("MTNL MUMBAI ","MTM"),("MTNL MUMBAI SPECIAL","MTMS"),("VIDEOCON","VD"),("VIDEOCON SPECIAL","VDS"),("VIRGIN GSM ","VG"),("VIRGIN GSM SPECIAL","VGS"),("VIRGIN CDMA","VC"),("T24","T24"),("T24 SPECIAL","T24S"),("TATA WALKY","TW")]

let arrPostPaidValue:[String] = ["AIRTEL","BSNL","IDEA","VODAFONE","RELIANCE GSM","RELIANCE CDMA","TATA DOCOMO GSM","TATA INDICOM (CDMA)","AIRCEL"]


let arrPostPaid:[(String, String)] = [("AIRTEL","APOS"),("BSNL","BPOS"),("IDEA","IPOS"),("VODAFONE","VPOS"),("RELIANCE GSM","RGPOS"),("RELIANCE CDMA","RCPOS"),("TATA DOCOMO GSM","DGPOS"),("TATA INDICOM (CDMA)","DCPOS"),("AIRCEL","CPOS ")]


let deviceID = "TestDevive"


struct Constants
{
//    static let adcolonyAppID = "app8846fa689329452281"
//    static let adcolonyZoneID = "vz95800cecdca247f5aa"

//    static let adcolonyAppID = "appbdee68ae27024084bb334a"
//    static let adcolonyZoneID = "vzf8e4e97704c4445c87504e"

    static let adcolonyAppID = "app4e580e5a9941460fbd"
    static let adcolonyZoneID = "vz7806b4ba5df64f8cad"

    
    
    
    static let zoneOff = "ZoneOff"
    static let zoneLoading = "ZoneLoading"
    static let zoneReady = "ZoneReady"
    
    static let currencyBalance = "CurrencyBalance"
    static let currencyBalanceChange = "CurrencyBalanceChange"
}

