//
//  SROfferWebViewController.h
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

@class SRNavBar;

@interface SROfferWebViewController : UIViewController <UIWebViewDelegate> {
    
    UIWebView *srWebView;
    NSURL *_url;
    
    BOOL _authed;
    
    NSString *_loadingPage;
    
    UIView *_navBar;
    
    UIActivityIndicatorView *_activityView;
    
    BOOL _falsePositive;
    NSString *_lastURL;
    NSString *_currentURL;
    
}
@property (nonatomic, retain) UIWebView *srWebView;
@property (nonatomic, assign) BOOL authed;
@property (nonatomic,retain) UIActivityIndicatorView *loadingIndicator;

-(id)initWithUrl:(NSURL*)url;

@end
