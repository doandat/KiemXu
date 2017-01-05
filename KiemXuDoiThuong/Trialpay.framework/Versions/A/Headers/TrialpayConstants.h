//
//  TrialpayConstants.h
//  SDK3UnitTests
//
//  Created by Daniel Togni on 1/16/15.
//  Copyright (c) 2015 TrialPay Inc. All rights reserved.
//

#ifndef SDK3UnitTests_TrialpayConstants_h
#define SDK3UnitTests_TrialpayConstants_h

// API Constants to define Gender
typedef enum {
    TP_Gender_Unknown = 0,
    TP_Gender_Male = 1,
    TP_Gender_Female = 2
} TPGender;

// API Enum for payer profiles
typedef enum {
    TP_PayerProfile_Unknown = 0,
    TP_PayerProfile_NonPayer = 1,
    TP_PayerProfile_Payer = 2,
    TP_PayerProfile_Whale = 3,
} TPPayerProfile;

#endif
