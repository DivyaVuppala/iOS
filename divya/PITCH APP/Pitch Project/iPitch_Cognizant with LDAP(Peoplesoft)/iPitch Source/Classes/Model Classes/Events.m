//
//  Events.m
//  iPitch V2
//
//  Created by Satheeshwaran on 4/2/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//

#import "Events.h"
#import "Accounts.h"
#import "Customers.h"
#import "File.h"
#import "Notes.h"


@implementation Events

@dynamic eventDescType;
@dynamic eventEndDate;
@dynamic eventID;
@dynamic eventPurpose;
@dynamic eventStartDate;
@dynamic eventSyncStatus;
@dynamic eventTitle;
@dynamic eventType;
@dynamic eventVenue;
@dynamic relatedToAccountID;
@dynamic relatedToAccountName;
@dynamic relatedToContactID;
@dynamic relatedToContactName;
@dynamic relatedToID;
@dynamic relatedToLeadName;
@dynamic relatedToPotentialID;
@dynamic accountTaggedToEvent;
@dynamic customersTaggedToEvent;
@dynamic filesTaggedToEvent;
@dynamic notesTaggedToEvent;

-(EventType)eventTypeRaw {
    return (EventType)[[self eventType] intValue];
}

-(void)setEventTypeRaw:(EventType)type {
    [self setEventType:[NSNumber numberWithInt:type]];
}

+(NSSet *)keyPathsForValuesAffectingEventTypeRaw {
    return [NSSet setWithObject:@"eventType"];
}


-(BOOL)isValidEvent
{
    if (self.eventTitle.length>0) {
        return YES;
    }
    return NO;
    
}
+(BOOL)isValidEvent:(Events *)event
{
    if (event.eventTitle.length>0) {
        return YES;
    }
    
    return NO;
}

@end
