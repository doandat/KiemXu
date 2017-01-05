//
//  AppnextAd.h
//  AppnextLib
//
//  Created by Eran Mausner on 11/01/2016.
//  Copyright © 2016 Appnext. All rights reserved.
//

#import "AppnextAdConfiguration.h"

@class AppnextAd;

@protocol AppnextAdDelegate <NSObject>
@optional

- (void) adLoaded:(AppnextAd *)ad;
- (void) adOpened:(AppnextAd *)ad;
- (void) adClosed:(AppnextAd *)ad;
- (void) adClicked:(AppnextAd *)ad;
- (void) adError:(AppnextAd *)ad error:(NSString *)error;

@end

@interface AppnextAd : NSObject

@property (nonatomic, weak) id<AppnextAdDelegate> delegate;

@property (nonatomic, strong) NSString *placementID;
@property (nonatomic, strong, readonly) AppnextAdConfiguration *adConfiguration;
@property (nonatomic, assign, readonly) BOOL adIsLoaded;

- (instancetype) init;
- (instancetype) initWithPlacementID:(NSString *)placement;
- (instancetype) initWithConfig:(AppnextAdConfiguration *)config;
- (instancetype) initWithConfig:(AppnextAdConfiguration *)config placementID:(NSString *)placement;
- (void) loadAd;
- (void) showAd;

#pragma mark - Setters/Getters

- (void) setCategories:(NSString *)categories;
- (NSString *) getCategories;
- (void) setPostback:(NSString *)postback;
- (NSString *) getPostback;
- (void) setButtonText:(NSString *)buttonText;
- (NSString *) getButtonText;
- (void) setButtonColor:(NSString *)buttonColor;
- (NSString *) getButtonColor;

@end
