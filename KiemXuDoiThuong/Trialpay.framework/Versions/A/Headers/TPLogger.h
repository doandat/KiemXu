//
//  TPLogger.h
//  SDK3UnitTests
//
//  Created by Konstantin Polin on 04.09.14.
//  Copyright (c) 2014 TrialPay Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@class TPConfiguration;
@class TPJSCore;
@class TPDataStore;

typedef enum {
    TPLogLevelSensitive = 0,
    TPLogLevelInfo = 1,
    TPLogLevelWarn = 2,
    TPLogLevelError = 3,
} TPLogLevel;

#define TPLogAttributedFormat(tag, level, format, ...) TPLogAttributedMessage(__FILE__, __LINE__, __PRETTY_FUNCTION__, tag, level, format, ##__VA_ARGS__);
#define TPLog(format, ...) TPLogLine(nil, TPLogLevelInfo, format, ##__VA_ARGS__)
#define TPLogSensitive(format, ...) TPLogLine(nil, TPLogLevelSensitive, format, ##__VA_ARGS__)
#define TPLogEnter TPLogSensitive(@"%s enter", __FUNCTION__)
#define TPLogFlow(format, ...) { TPLog(@"\n*********************\nTPFLOW %@\n*********************", [NSString stringWithFormat:format, ##__VA_ARGS__]); }
#define TPLogExit TPLogSensitive(@"%s exit", __FUNCTION__)
#define TPLogStackTrace TPLogAttributedFormat(@"StackTrace", TPLogLevelSensitive, @"\n***** STACKTRACE *****\n%@\n***** STACKTRACE END *****", [NSThread callStackSymbols]);
#define TPWarn(format, ...) TPLogLine(nil, TPLogLevelWarn, format, ##__VA_ARGS__)
extern BOOL _exceptionOnError;
#define TPError(_format_, ...) TPLogLine(nil, TPLogLevelError, _format_, ##__VA_ARGS__); if (_exceptionOnError) { [NSException raise:@"TPERROR" format:@"TPERROR: %s", [[NSString stringWithFormat:NSLocalizedString(_format_, [TPUtils createLocalizedFromFormat:localized]), ##__VA_ARGS__] UTF8String]]; }

#define TPLogLine(tag, level, format, ...) TPLogAttributedFormat(tag, level, format, ##__VA_ARGS__);

#ifdef TEST
extern BOOL _exceptionOnCustomerError;

// Customer logging
#import <Foundation/Foundation.h>

#define TPCustomerLog(format, ...) TPLogAttributedFormat(@"Customer", TPLogLevelInfo, format, ##__VA_ARGS__);
#define TPCustomerWarning(format, ...) TPLogAttributedFormat(@"Customer", TPLogLevelWarn, format, ##__VA_ARGS__);
#define TPCustomerError(_format_, ...) {NSString *str; TPLogAttributedFormat(@"Customer", TPLogLevelError, _format_, ##__VA_ARGS__); if (_exceptionOnCustomerError) { [NSException raise:@"TPCustomerError" format:@"UT ERROR: Trialpay: %s", [str = [NSString stringWithFormat:NSLocalizedString(_format_, [TPUtils createLocalizedFromFormat:localized]), ##__VA_ARGS__] UTF8String]]; }}

FOUNDATION_EXPORT NSMutableArray *getErrors();

#else

// Customer logging
#define TPCustomerLog(format, ...){ NSLog(@"Trialpay: %s", [[NSString stringWithFormat:NSLocalizedString(format, [TPUtils createLocalizedFromFormat:localized]), ##__VA_ARGS__] UTF8String]); TPLogAttributedFormat(@"Customer", TPLogLevelInfo, format, ##__VA_ARGS__); };
#define TPCustomerWarning(format, ...){ NSLog(@"WARN: Trialpay: %s", [[NSString stringWithFormat:NSLocalizedString(format, [TPUtils createLocalizedFromFormat:localized]), ##__VA_ARGS__] UTF8String]); TPLogAttributedFormat(@"Customer", TPLogLevelWarn, format, ##__VA_ARGS__); };
#define TPCustomerError(format, ...) { NSLog(@"ERROR: Trialpay: %s", [[NSString stringWithFormat:NSLocalizedString(format, [TPUtils createLocalizedFromFormat:localized]), ##__VA_ARGS__] UTF8String]); TPLogAttributedFormat(@"Customer", TPLogLevelError, format, ##__VA_ARGS__); };

#endif



#define TPLoggerIncludeCurrentFileLogs TPLoggerIncludeFileLogs([[NSString stringWithFormat:@"%s", __FILE__] lastPathComponent]);
#define TPLoggerIncludeCurrentFunctionLogs TPLoggerIncludeFunctionLogs([NSString stringWithFormat:@"%s", __PRETTY_FUNCTION__]);

void TPLogAttributedMessage(const char *file, int line, const char *function, NSString *tag, int level, NSString * format, ... ) NS_FORMAT_FUNCTION(6, 7);


@interface TPLogger : NSObject 

+ (TPLogger *)sharedInstance __attribute__((const));

+ (BOOL) verboseLogging;
+ (void) setVerboseLogging:(BOOL)verbose;
+ (void) setVerbosityLevel:(NSInteger)verbosityLevel;

void TPLoggerResetFileFilter();
void TPLoggerIncludeFileLogs(NSString *file);
void TPLoggerIncludeFunctionLogs(NSString *function);

#ifdef TEST
+ (void) initTestLogging;
+ (void) clear;

+ (NSArray *) logs;
+ (NSArray *) warns;
+ (NSArray *) errors;

+ (void) flushLogsToFile:(NSString *)path;
#endif
- (void)onConfigInitWithConfig:(TPConfiguration *)config jsCore:(TPJSCore *)jsCore;

- (void)notifyAppDidEnterBackground;
- (void)notifyAppWillTerminate;

- (void)notifyConfigUpdated;
- (void)notifyAppDidBecomeActive;

- (void)logResponse:(NSString*)key data:(NSData*)data error:(NSError*)error;
- (void)loadLoggingParamsFromConfig;

@end
