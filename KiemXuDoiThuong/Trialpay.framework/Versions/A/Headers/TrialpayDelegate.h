//
// Created by Trialpay, Inc. on 10/24/13.
// Copyright (c) 2013 TrialPay Inc. All rights reserved.
//

#ifndef __TrialpayDelegate_H_
#define __TrialpayDelegate_H_

@class Trialpay;
@class TrialpayEvent;

/*!
 * @brief Events delegate.
 * 
 * Defines the interface used to notify open, close and unavailable events.
 *
 * Once an event is fired, it will open unless:
 * * there are no offers - so its unavailable
 * * the method shouldOpenForEvent returns NO - preventing the event from opening
 *
 * @see @ref events
 */
@protocol TrialpayEventsDelegate
@optional

/*!
 * @brief Announces that a view was open.
 * @param trialpay the Trialpay singleton
 * @param event the TrialpayEvent that triggered the view to open
 * @return YES if the view should open.
 */
- (BOOL)trialpay:(Trialpay *)trialpay shouldOpenForEvent:(TrialpayEvent *)event;

/*!
 * @brief Announces that a view was closed.
 * @param trialpay the Trialpay singleton
 * @param event the TrialpayEvent that triggered the view to close
 */
- (void)trialpay:(Trialpay *)trialpay didCloseForEvent:(TrialpayEvent *)event;

/*!
 * @brief Announces that the event was unavailable.
 * @param trialpay the Trialpay singleton
 * @param event the TrialpayEvent that is unavailable
 */
- (void)trialpay:(Trialpay *)trialpay eventIsUnavailable:(TrialpayEvent *)event;

/*!
 * @brief Announces that a flow/UI should be opened by the app.
 *
 * The Evergreen SDK can be configured to open dialogs to select between multiple flows.
 * For the choices that result in TrialPay flows, nothing will be announced.
 * For the choices that result in customer flows, this delegate method will be invoked, so that the appropriate
 * action can be taken by the app.
 *
 * @param trialpay the Trialpay singleton
 * @param event the TrialpayEvent that triggered this flow
 * @param flowId the name of the flow configured on the merchant panel.
 */
- (void)trialpay:(Trialpay *)trialpay event:(TrialpayEvent*)event openFlow:(NSString *)flowId;
@end

/*!
 * @brief Rewards Delegate.
 *
 * Defines the interface for notifications on rewards available and rewards crediting.
 *
 * When rewards are credited by TrialPay they will usually result in a notification of availability of rewards.
 * This notification does not have any details on the amount, currency or product.
 *
 * Once rewards are available, its necessary to open a flow (TrialpayEvent::fire), which will open the
 * Trialpay Rewards UI, and at that point, rewards will be credited to the delegate.
 *
 * @see @ref getRewards
 */
@protocol TrialpayRewardsDelegate
/*!
     @brief Announces that rewards are now available.
     @param trialpay the Trialpay singleton
     @param amount the amount of credits
     @param rewardId the reward name that should be credited
*/
- (void)trialpay:(Trialpay *)trialpay reward:(int)amount rewardId:(NSString *)rewardId;

@optional

/*!
 @brief Announces that rewards are now available.
 @param trialpay the Trialpay singleton
 @param rewardInfo information that is exposed related to this rewards
 */
- (void)trialpay:(Trialpay *)trialpay rewardsAreAvailable:(NSDictionary *)rewardInfo;

@end

#endif //__TrialpayDelegate_H_
