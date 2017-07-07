//
//  calenderEvent.m
//  CRMNew
//
//  Created by Sandhya Sandala on 16/01/13.
//  Copyright (c) 2013 sandhya17@gmail.com. All rights reserved.
//

#import "calenderEvent.h"
#import "Events.h"
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUIDefines.h>
#import "ModelTrackingClass.h"


@implementation calenderEvent
@synthesize activityEvent;

-(id) init{
    
   if (self = [super init]) {
   
   }
     return self;
}


-(void)CreateEvent {
    activityEvent = [[ModelTrackingClass sharedInstance] getModelObjectForKey:@"ActivityArray"];
    
    NSLog(@"activityevent: %@", self.activityEvent);
 
        for (int i=0;i<self.activityEvent.count;i++)
        {
            NSLog(@"countabc: %d",activityEvent.count);
            EKEventStore *eventStore = [[[EKEventStore alloc] init]autorelease];
            Events * ActivityObject = [activityEvent objectAtIndex:i];
            
            NSDateFormatter *tempFormatterDate = [[[NSDateFormatter alloc]init]autorelease];
            [tempFormatterDate setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            [tempFormatterDate setLocale:[NSLocale currentLocale]];
            NSString *date =[NSString stringWithFormat:@"%@", ActivityObject.eventStartDate];
            
            
            NSPredicate *predicateForEventsOndate = [eventStore predicateForEventsWithStartDate: [tempFormatterDate dateFromString:date] endDate:[[[NSDate alloc] initWithTimeInterval:600 sinceDate:[tempFormatterDate dateFromString:date]]autorelease] calendars:nil]; // nil will search through all calendars
            
            
            NSArray *eventsOnDate = [eventStore eventsMatchingPredicate:predicateForEventsOndate];
            
            
            
            BOOL eventExists = NO;
            
            for (EKEvent *eventToCheck in eventsOnDate) {
                if ([eventToCheck.title isEqualToString:ActivityObject.eventTitle]) {
                    eventExists = YES;
                }
            }
            
            if (eventExists == NO) {
                
                EKEvent *event  = [EKEvent eventWithEventStore:eventStore];
                event.title =[NSString stringWithFormat:@"%@", ActivityObject.eventTitle];
                NSLog(@"event: %@", event.title);
                NSDateFormatter *tempFormatter = [[[NSDateFormatter alloc]init]autorelease];
                [tempFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                [tempFormatter setLocale:[NSLocale currentLocale]];
                NSString *dateandtime =[NSString stringWithFormat:@"%@",ActivityObject.eventStartDate];
                NSLog(@"dateandtime: %@",dateandtime);
                NSString *dateandtimeend =[NSString stringWithFormat:@"%@",ActivityObject.eventEndDate];
                NSLog(@"dateandtime: %@",dateandtimeend);
                event.notes = [NSString stringWithFormat:@"%@",ActivityObject.description];
                event.location = @"Location";
                event.startDate =[tempFormatter dateFromString:dateandtime];
                event.endDate   = [tempFormatter dateFromString:dateandtimeend];
                [event addAlarm:[EKAlarm alarmWithAbsoluteDate:event.startDate]];
                [event addAlarm:[EKAlarm alarmWithRelativeOffset:60.0f * -60.0f * 24]];
                [event addAlarm:[EKAlarm alarmWithRelativeOffset:60.0f * -15.0f]];
                [event setCalendar:[eventStore defaultCalendarForNewEvents]];
                NSError *err;
                [eventStore saveEvent:event span:EKSpanThisEvent error:&err];
            }
            
        }
}   


@end