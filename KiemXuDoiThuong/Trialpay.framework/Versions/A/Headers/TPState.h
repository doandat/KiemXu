//
// Created by Daniel Togni on 8/6/14.
// Copyright (c) 2014 TrialPay Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TrialpayConstants.h"

#define __TPSTATE_H__

@class TPState;
@class TrialpayEvent;

/*!
 * @brief Holds a persistent state of custom parameters and user information 
 * (age, gender, level, payer profile, balance, custom parameters).
 */
@interface TPState : NSObject {
}

/// Age of the user.
@property (strong, nonatomic) NSNumber *age;
/// Gender of the user.
@property (assign, nonatomic) TPGender gender;
/// Current game level.
@property (strong, nonatomic) NSNumber *level;
/// Payer profile (non-payer, payer, whale)
@property (assign, nonatomic) TPPayerProfile payerProfile;

#pragma mark - Extended API

/*!
 * @brief Return the balances registered.
 * @return A dictionary with the balances
 */
- (NSDictionary*)balances;

/*!
 * @brief Set a balance.
 * @param amount the amount to be added
 * @param currency the currency to receive the balance
 */
- (void)setBalance:(int)amount forCurrency:(NSString *)currency;

/*!
 * @brief Sets custom parameters.
 *
 * All set parameters (even if they have a value of an empty string) will be passed on API calls.
 * If the value is set to nil, the passed value will be "" (empty string).
 *
 * @param value The value of the parameter.
 * @param name The name of the parameter.
*/
- (void)setCustomParamValue:(NSString *)value forName:(NSString *)name;

/*!
 * @brief Return the current custom parameters.
 * @return A dictionary with the custom parameters.
 */
- (NSDictionary*)customParams;



@end
