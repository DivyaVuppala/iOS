//
//  NotificationsHelper.m
//  iPitch V2
//
//  Created by Satheeshwaran on 5/2/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//

#import "NotificationsHelper.h"

@implementation NotificationsHelper


/**
 *	This method creates a UILocalNotification at a specified date with other properties.
 */
+ (void) scheduleNotificationOn:(NSDate*) fireDate
                           text:(NSString*) alertText
                         action:(NSString*) alertAction
                          sound:(NSString*) soundfileName
                    launchImage:(NSString*) launchImage
                        andInfo:(NSDictionary*) userInfo
{
	UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = fireDate;
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    
    localNotification.alertBody = alertText;
    localNotification.alertAction = alertAction;
    
	if(soundfileName == nil)
	{
		localNotification.soundName = UILocalNotificationDefaultSoundName;
	}
	else
	{
		localNotification.soundName = soundfileName;
	}
    
	localNotification.alertLaunchImage = launchImage;
    NSInteger badgeCount=[[[UIApplication sharedApplication] scheduledLocalNotifications] count];
    localNotification.applicationIconBadgeNumber = badgeCount;
    localNotification.userInfo = userInfo;
    
	// Schedule it with the app
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

/**
 *	This method sets the application's badge icon as 0 i.e, no badge icon.
 */
+ (void) clearBadgeCount
{    
	[UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

/**
 *	This method sets the application's badge icon to value lesser than current value.
 */
+ (void) decreaseBadgeCountBy:(int) count
{
    NSInteger badgeCount=[[[UIApplication sharedApplication] scheduledLocalNotifications] count];
    
	badgeCount -= count;
	if(badgeCount < 0) badgeCount = 0;
    
	[UIApplication sharedApplication].applicationIconBadgeNumber = badgeCount;
}

/**
 *	This method is the handler of all UILocalNotfications in the app.
 */
+ (void) handleReceivedNotification:(UILocalNotification*) thisNotification
{
    NSLog(@"Received: %@",[thisNotification description]);
    UIAlertView *notificationAlert=[[UIAlertView alloc]initWithTitle:thisNotification.alertBody message:thisNotification.alertAction delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    [notificationAlert show];
	[self decreaseBadgeCountBy:1];
}


+(void)removePreviousNotifications
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];

}
@end
