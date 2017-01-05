//
// Created by Trialpay, Inc. on 9/27/13.
// Copyright (c) 2013 TrialPay, Inc. All Rights Reserved.
//

#import <Foundation/Foundation.h>
// Added import to prevent compilation erros on Adobe - INTERNAL
#import <CoreGraphics/CoreGraphics.h>

@class TPURL;

@protocol TPURLTracker
- (void)logURL:(TPURL*)url;
@end

@interface TPUrlManager : NSObject
+ (void)clearHTTPCache;

+ (TPURL *)buildURLWithName:(NSString *)name;

+ (TPURL *)buildURL:(NSDictionary *)urlDict;
@end
