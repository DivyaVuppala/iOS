//
//  Events.h
//  iPitch V2
//
//  Created by Satheeshwaran on 4/2/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Accounts, Customers, File, Notes;

typedef enum {
    EventTypeCall,
    EventTypeEmail,
    EventTypeMeeting,
    EventTypeProduct_Demo
    
}EventType;

@interface Events : NSManagedObject

@property (nonatomic, retain) NSString * eventDescType;
@property (nonatomic, retain) NSDate * eventEndDate;
@property (nonatomic, retain) NSString * eventID;
@property (nonatomic, retain) NSString * eventPurpose;
@property (nonatomic, retain) NSDate * eventStartDate;
@property (nonatomic, retain) NSNumber * eventSyncStatus;
@property (nonatomic, retain) NSString * eventTitle;
@property (nonatomic, retain) NSNumber * eventType;
@property (nonatomic, retain) NSString * eventVenue;
@property (nonatomic, retain) NSString * relatedToAccountID;
@property (nonatomic, retain) NSString * relatedToAccountName;
@property (nonatomic, retain) NSString * relatedToContactID;
@property (nonatomic, retain) NSString * relatedToContactName;
@property (nonatomic, retain) NSString * relatedToID;
@property (nonatomic, retain) NSString * relatedToLeadName;
@property (nonatomic, retain) NSString * relatedToPotentialID;
@property (nonatomic, retain) Accounts *accountTaggedToEvent;
@property (nonatomic, retain) NSSet *customersTaggedToEvent;
@property (nonatomic, retain) NSSet *filesTaggedToEvent;
@property (nonatomic, retain) NSSet *notesTaggedToEvent;
@end

@interface Events (CoreDataGeneratedAccessors)

- (void)addCustomersTaggedToEventObject:(Customers *)value;
- (void)removeCustomersTaggedToEventObject:(Customers *)value;
- (void)addCustomersTaggedToEvent:(NSSet *)values;
- (void)removeCustomersTaggedToEvent:(NSSet *)values;

- (void)addFilesTaggedToEventObject:(File *)value;
- (void)removeFilesTaggedToEventObject:(File *)value;
- (void)addFilesTaggedToEvent:(NSSet *)values;
- (void)removeFilesTaggedToEvent:(NSSet *)values;

- (void)addNotesTaggedToEventObject:(Notes *)value;
- (void)removeNotesTaggedToEventObject:(Notes *)value;
- (void)addNotesTaggedToEvent:(NSSet *)values;
- (void)removeNotesTaggedToEvent:(NSSet *)values;

-(EventType)eventTypeRaw;
-(void)setEventTypeRaw:(EventType)type;
+(NSSet *)keyPathsForValuesAffectingEventTypeRaw;

-(BOOL)isValidEvent;
+(BOOL)isValidEvent:(Events *)event;
@end
