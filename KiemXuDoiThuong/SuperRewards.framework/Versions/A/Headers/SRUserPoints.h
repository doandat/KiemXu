//
//  SRUserPoints.h
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


#import <Foundation/Foundation.h>
@class SR;
@class SRUserPoints;

@protocol SRUserPointsDelegate <NSObject>
@required
-(void)userPointsLoaded:(SRUserPoints*)userPoints;
@end

@interface SRUserPoints : NSObject {
    
    SR *sr;
    
    int _pointsTotal;
    int _pointsNew;
    int _pointsPending;
    NSMutableDictionary *_errors;
    
    NSMutableData *_receivedData;
    
    NSDictionary *_apiEndPoint;
    
    id<SRUserPointsDelegate>_delegate;
	
    BOOL success;
}

@property(nonatomic, assign)int pointsTotal;
@property(nonatomic, assign)int pointsNew;
@property(nonatomic, assign)int pointsPending;
@property(nonatomic, retain)NSMutableDictionary *errors;

-(id)initWithDelegate:(id<SRUserPointsDelegate>)delegate;
-(void)getUserPoints;
@end
