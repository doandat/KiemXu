//
// Created by Daniel Togni on 11/3/14.
// Copyright (c) 2014 TrialPay Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


// moving away from isAvailable to status updates
typedef enum {
    TPEventStatusNoOffers = 2,
    TPEventStatusNewOffers = 3
} TPEventStatus;

#define TPEventStatusInvalidated (TPEventStatus)1

@class TrialpayEvent;
typedef void (^TPStatusChangeBlock)(TrialpayEvent*,TPEventStatus);

/*!
 * @brief The event object.
 * 
 * Provides the core event functionality.
 *
 * @see @ref events
 */
@interface TrialpayEvent : NSObject {

}

/// The full name of the event (Deprecated)
@property (nonatomic, readonly, copy) NSString *fullName DEPRECATED_MSG_ATTRIBUTE("Use name instead");
/// The name of the event (ex: show_ui, button_clicked, game_paused)
@property (nonatomic, copy) NSString *name;
/// A dictionary with information about this event
@property (nonatomic, strong) NSDictionary *eventInfo;
/// The current selected offer index (@see offerBrowsing)
@property (nonatomic, readonly, assign) NSUInteger offerIndex;

/*!
 * A callback for event status changes.
 *
 * Use this callback when there is a need to update the UI based on the availability of offers.
 *
 * @see @ref isAvailable
 */
@property (nonatomic, strong) TPStatusChangeBlock onStatusChange;

/*!
 * @brief Create a custom event.
 * @param eventName The name of the event.
 * @return A new event.
 */
+ (TrialpayEvent *)eventWithName:(NSString *)eventName;

/*!
 * @brief Create a custom event.
 * @param name The name of the event.
 * @param info A dictionary with information associated with this event.
 * @return A new event.
 */
- (id)initWithName:(NSString *)name info:(NSDictionary *)info;

/*!
 * @brief Create a custom event.
 * @param eventName name
 * @param info The event info (optional).
 * @return An TrialpayEvent.
 */
+ (TrialpayEvent *)eventWithName:(NSString *)eventName info:(NSDictionary *)info;

/*!
 * @brief Checks if there are offers available for this event.
 *
 * Most TrialPay code runs on a separate thread, which requires some processes to be dispatched.
 * This makes the response of the availability call to be asynchronous. Once the availability is calculated
 * on TrialPay thread, the response is provided using a callback method.
 *
 * @deprecated Use onStatusChange property for status notifications instead of polling for availability.
 *
 * @param block The block of code to execute when the response is calculated.
 *
 * @return YES if there are offers available
 *
 * @see @ref isAvailable
 */
- (void)isAvailable:(void (^)(BOOL isAvailable))block __deprecated_msg("Replaced by onStatusChange");

/*!
 * @brief Executes the action assigned for this event.
 */
- (void)fire;

/*!
 * @brief Executes the action assigned for this event, presenting on a given view controller.
 * @param viewController The view controller where the TrialPay UI will be pushed to.
 */
- (void)fireOnViewController:(UIViewController*)viewController;

/*!
 * @brief Get the native offer information for creating customized UI for this event.
 * @see @ref nativeOffers
 * @returns an array with the Native Offers data.
 */
- (NSDictionary *)touchpointInfo;

/*!
 * @brief Fire a pixel to TrialPay letting us know that you've displayed a TrialPay offer via touchpointInfo.
 *
 * This allows TrialPay to track and optimize offer performance.
 *
 * @deprecated Use fireImpression instead.
 */
- (void)registerOfferImpression __deprecated_msg("Replaced by fireImpression");

/*!
 * @brief Fire a pixel to TrialPay letting us know that you've displayed a TrialPay offer via touchpointInfo.
 *
 * This allows TrialPay to track and optimize offer performance.
 */
- (void)fireImpression;

/*!
 * @brief Rotate to the next offer.
 *
 * Used with Native API, it allows rotating offer.
 * @see @ref offerBrowsing
 *
 * @return the offer index
 */
- (NSUInteger)nextOffer;

/*!
 * @brief Rotate to the previous offer.
 *
 * Used with Native API, it allows rotating offer.
 * @see @ref offerBrowsing
 *
 * @return the offer index
 */
- (NSUInteger)previousOffer;

/*!
 * @brief Return the offer count.
 *
 * Used with Native API, it returns the amount of offers available for this event.
 * @see @ref offerBrowsing
 *
 * @return the offer count
 */
- (NSUInteger)offerCount;

@end
