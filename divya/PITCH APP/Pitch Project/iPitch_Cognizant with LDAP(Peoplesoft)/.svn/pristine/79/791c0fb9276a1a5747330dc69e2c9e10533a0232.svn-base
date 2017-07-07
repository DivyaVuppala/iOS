//
//  iPitchAnalytics.m
//  iPitch V2
//
//  Created by Satheeshwaran on 3/11/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//

#import "iPitchAnalytics.h"
#import "Analytics.h"
#import "AppDelegate.h"
#import "UIDevice+IdentifierAddition.h"
#import "SFHFKeychainUtils.h"
#import "Utils.h"
#import "iPitchConstants.h"

#define SAppDelegateObject ((AppDelegate *)[[UIApplication sharedApplication] delegate])


@implementation iPitchAnalytics
@synthesize currentAnalyticsEngine;
@synthesize googleTracker;
@synthesize managedObjectContext;

static iPitchAnalytics *sharediPitchAnalyticsInstance = nil;
static NSString *const kTrackingId = @"UA-36584966-1";

//iPitch V2 Tracking ID
//static NSString *const kTrackingId =@"UA-39201183-1";

+(iPitchAnalytics *)sharedInstance
{
    @synchronized(self){
		if(sharediPitchAnalyticsInstance == nil){
		sharediPitchAnalyticsInstance = [[self alloc] init];
        
	 }
    }
	return sharediPitchAnalyticsInstance;
}


-(void)setCurrentAnalyticsEngine:(iPitchAnlyticsType )engine
{
    
    currentAnalyticsEngine=engine;
    
    if (engine == iPitchAnlyticsTypeGA)
    {
        [GAI sharedInstance].debug = NO;
        [GAI sharedInstance].dispatchInterval = 60;
        [GAI sharedInstance].trackUncaughtExceptions = YES;
        self.googleTracker = [[GAI sharedInstance] trackerWithTrackingId:kTrackingId];
    }
    
    else if(engine == iPitchAnlyticsTypeOther)
        
    {
        //do whatever you want later.
        
       
    }
    
}
-(void)setShowDebugLogs:(BOOL)showDebugLogs
{
    if (self.currentAnalyticsEngine == iPitchAnlyticsTypeGA) {
        [[GAI sharedInstance] setDebug:showDebugLogs];
    }
    
    else if(self.currentAnalyticsEngine==iPitchAnlyticsTypeOther)
    showDebugLogs=showDebugLogs;
}
- (BOOL)trackEventForScreen:(NSString *)screenName
                    withAction:(NSString *)action
                     withLabel:(NSString *)label
                     withValue:(NSNumber *)value
{
    
    if (self.currentAnalyticsEngine == iPitchAnlyticsTypeGA)
    {
        [[[GAI sharedInstance] defaultTracker] trackEventWithCategory:screenName withAction:action withLabel:label withValue:value];
    }
    
    else if(self.currentAnalyticsEngine ==  iPitchAnlyticsTypeOther)
    {
        self.managedObjectContext=SAppDelegateObject.managedObjectContext;
        Analytics *analyticsObject=[NSEntityDescription insertNewObjectForEntityForName:@"Analytics" inManagedObjectContext:self.managedObjectContext];
        //device ID from Category.
        analyticsObject.deviceID =[[UIDevice currentDevice] uniqueDeviceIdentifier];
        analyticsObject.deviceTime =[[NSDate alloc]init];
        analyticsObject.appView=screenName;
        analyticsObject.appEvent=action;
        analyticsObject.userName=[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_USER_NAME];
        NSTimeZone *localTime = [NSTimeZone systemTimeZone];
        analyticsObject.timeZone= [localTime name];
        
        NSError *error=nil;
        
        if (![self.managedObjectContext save:&error]) {
            NSLog(@"sorry could not save analytics data locally");
        }
        
        else{
            if (self.showDebugLogs) {
                NSLog(@"Analytics Data for %@ was saved", screenName);
            }
        }
    }
    
    return NO;
}

- (BOOL)trackTimingForScreen:(NSString *)screenName
                      withValue:(NSTimeInterval)time
                       withEntityName:(NSString *)entityName
                      withLabel:(NSString *)label
{
    if (self.currentAnalyticsEngine == iPitchAnlyticsTypeGA)
    {
        [[[GAI sharedInstance] defaultTracker] trackTimingWithCategory:screenName withValue:time withName:entityName withLabel:label];
    }
    
    else if(self.currentAnalyticsEngine ==  iPitchAnlyticsTypeOther)
    {
        self.managedObjectContext=SAppDelegateObject.managedObjectContext;
        Analytics *analyticsObject=[NSEntityDescription insertNewObjectForEntityForName:@"Analytics" inManagedObjectContext:self.managedObjectContext];
        //device ID from Category.
        analyticsObject.deviceID =[[UIDevice currentDevice] uniqueDeviceIdentifier];
        analyticsObject.deviceTime =[[NSDate alloc]init];
        analyticsObject.appView=screenName;
        analyticsObject.appEvent=entityName;
        analyticsObject.userName=[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_USER_NAME];
        NSTimeZone *localTime = [NSTimeZone systemTimeZone];
        analyticsObject.timeZone= [localTime name];
        NSError *error=nil;
        
        if (![self.managedObjectContext save:&error]) {
            NSLog(@"sorry could not save analytics data locally");
        }
        else{
            if (self.showDebugLogs) 
                NSLog(@"Analytics Data for %@ was saved", screenName);
        }
    }

    return NO;
}

-(void)trackView:(NSString *)viewName
{
    if (self.currentAnalyticsEngine==iPitchAnlyticsTypeGA) {
        [[GAI sharedInstance] .defaultTracker trackView:viewName];
    }
}
@end
