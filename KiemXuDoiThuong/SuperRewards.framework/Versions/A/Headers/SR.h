//
//  SuperRewards.h
//
//  SuperRewards iOS SDK - V2
//
//  Playerize Inc.
//  200-116 West Hastings Street,
//  Vancouver, BC, V6B 1G8
//  +1 (877) 791-8092
//
//  Copyright (c) 2011 - 2014 Playerize Inc. All rights reserved.
//
//  krys wallbank / <krys@playerize.com>
//

#import "SRGlobalParams.h"
#import "SRUserPoints.h"
#import "SROfferWebViewController.h"

@interface SR : NSObject <UIApplicationDelegate> {
	
    NSURLConnection *offerListFeedConnection;
    NSMutableData *offerListData;
    
    SROfferWebViewController *srowvc;
    
    NSURL *url;
        
    NSString *_model;
    NSString *_carrier;
    NSString *_osVersion;
    
    NSTimer *_pollingTimer;
    NSUInteger _lastInterval;
    
    id<SRUserPointsDelegate>_delegate;
}

+(id)sharedManager;

@property (nonatomic, retain) NSString *applicationId;
@property (nonatomic, retain) NSString *userId;
@property (nonatomic, retain) UIViewController *parentViewController;
@property (nonatomic, assign) NSUInteger refreshInterval;
@property (nonatomic, retain) id<SRUserPointsDelegate>delegate;

-(id)initWithAppId:(NSString *)applicationId
        withUserId:(NSString *)userId
withViewController:(UIViewController *)parentViewController;

-(void)openWall;
-(void)shutDown;
-(void)getUserPoints:(id<SRUserPointsDelegate>)delegate;
-(void)getUserPoints;

@end
