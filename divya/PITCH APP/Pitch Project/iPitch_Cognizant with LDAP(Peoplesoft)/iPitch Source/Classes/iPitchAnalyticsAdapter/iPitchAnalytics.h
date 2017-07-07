//
//  iPitchAnalytics.h
//  iPitch V2
//
//  Created by Satheeshwaran on 3/11/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GAI.h"


typedef enum iPitchAnlyticsType {
    iPitchAnlyticsTypeGA = 0,
    iPitchAnlyticsTypeOther,
} iPitchAnlyticsType;

@interface iPitchAnalytics : NSObject

@property (nonatomic,assign) iPitchAnlyticsType currentAnalyticsEngine;
@property (nonatomic,retain) id<GAITracker> googleTracker;
@property (nonatomic,assign) BOOL showDebugLogs;
@property (nonatomic,retain) NSManagedObjectContext *managedObjectContext;

- (BOOL)trackEventForScreen:(NSString *)screenName
                 withAction:(NSString *)action
                  withLabel:(NSString *)label
                  withValue:(NSNumber *)value;
- (BOOL)trackTimingForScreen:(NSString *)screenName
                   withValue:(NSTimeInterval)time
              withEntityName:(NSString *)entityName
                   withLabel:(NSString *)label;
+(iPitchAnalytics *)sharedInstance;
-(void)setCurrentAnalyticsEngine:(iPitchAnlyticsType )engine;
-(void)trackView:(NSString *)viewName;
@end
