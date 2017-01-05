//
//  Trialpay.h
//
//  Created by TrialPay Inc.
//  Copyright (c) 2013 TrialPay, Inc. All Rights Reserved.
//

#import <Foundation/Foundation.h>


#import "TrialpayEvent.h"
#import "TPState.h"


#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_1
#error Evergreen SDK requires the target version to be higher or equal to 7.1
#endif

@class TPEvent;
@class TPState;

@protocol TrialpayEventsDelegate;
@protocol TrialpayRewardsDelegate;
@class TPCommerceEvent;
@class TPGameEvent;

/*!
 * @brief Manages all interactions with TrialPay Evergreen SDK.
 *
 * * Initilize the SDK (app key + user id).
 * * Setup Delegates (events and rewards).
 * * Rewards (availability & show).
 * * Test mode.
 *
 * @see @ref tutorial TrialpayEventsDelegate TrialpayRewardsDelegate
*/

@interface Trialpay : NSObject 

/// Delegate for events.
@property (strong, nonatomic) id<TrialpayEventsDelegate> eventsDelegate;
/// Delegate for rewards.
@property (strong, nonatomic) id<TrialpayRewardsDelegate> rewardsDelegate;

/// Holds a persistent state of TrialPay settings (age, level, gender, payer profile).
@property (strong, nonatomic) TPState *state;

+ (void)setEventsDelegate:(id<TrialpayEventsDelegate>)delegate; 
+ (void)setRewardsDelegate:(id<TrialpayRewardsDelegate>)delegate; 

/*!
    Delegate for Offer Wall close events and Balance update events, See TrialpayEventsDelegate, TrialpayRewardsDelegate.
*/

#pragma mark - Register App

/*!
    @brief Initialize TrialPay with an app key.
    @param appKey The app key.
 */
+ (void)initApp:(NSString*)appKey;

/*!
 @brief Initialize TrialPay with an app key and user id.
 @param appKey The app key.
 @param sid The user id (alpha-numeric).
 */
+ (void)initApp:(NSString*)appKey withSid:(NSString*)sid;

#pragma mark - State

/*!
 * @brief Holds a persistent state of TrialPay settings (age, level, gender, payer profile).
 * @return The object that represents TrialPay state.
 */
///
+ (TPState *)state;

#pragma mark - Info
/*!
 * @brief Get the version of the SDK.
 * @return The SDK Version.
 */
+ (NSString*)sdkVersion;

#pragma mark - Setup

/*!
 * @brief Sets the (alpha-numeric) user identification.
 *
 * The SID is a unique user id for each device user.
 * It will be used to uniquely identify your user within the TrialPay system for monetization and customer support purposes.
 * If you do not maintain a unique user id one will be auto-generated.
 *
 * @note Not setting an sid prevents matching your users to users within TrialPay.
 * @param sid The user identifier (alpha-numeric).
*/
+ (void)setSid:(NSString *)sid;

/*!
 * @brief Return the SID (user identification).
 * @return The user identifier.
*/
+ (NSString *)sid;

/*!
 * @brief Retrieve the App key.
 * @return The application key with TrialPay.
 */
+ (NSString *)appId;

/*!
 * @internal
 * @brief Set a custom user ID for use with the AdColony SDK, if you've included the AdColony SDK in your app.
 * @param customUserID The custom user ID to be passed to the AdColony SDK.
*/
+ (void)setAdColonyCustomUserID:(NSString *)customUserID; 

#pragma mark - Events

/*!
    @brief Show rewards if any.
    @return TRUE if UI will open (rewards are available)
 */
+ (void)showRewards;


/*!
  @brief Return the rewards availability.
  @return TRUE if rewards are available.
  */
+ (BOOL)hasRewards;

#pragma mark - Debug

/*!
 * @brief Test mode makes all events to be available and open a simple UI.
 */
+ (void)enableTestMode;

@end
