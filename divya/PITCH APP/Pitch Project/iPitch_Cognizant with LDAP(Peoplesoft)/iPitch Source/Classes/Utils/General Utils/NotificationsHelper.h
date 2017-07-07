//
//  NotificationsHelper.h
//  iPitch V2
//
//  Created by Satheeshwaran on 5/2/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotificationsHelper : NSObject

+ (void) clearBadgeCount;

+ (void) scheduleNotificationOn:(NSDate*) fireDate
                           text:(NSString*) alertText
                         action:(NSString*) alertAction
                          sound:(NSString*) soundfileName
                    launchImage:(NSString*) launchImage
                        andInfo:(NSDictionary*) userInfo;

+ (void) handleReceivedNotification:(UILocalNotification*) thisNotification;

+(void)removePreviousNotifications;
@end
