//
//  Accounts.h
//  iPitch V2
//
//  Created by Satheeshwaran on 4/2/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Events, Notes, Opportunities;

@interface Accounts : NSManagedObject

@property (nonatomic, retain) NSString * acconuntPhoneNo;
@property (nonatomic, retain) NSString * accountID;
@property (nonatomic, retain) NSString * accountIndustry;
@property (nonatomic, retain) NSString * accountName;
@property (nonatomic, retain) NSString * accountNo;
@property (nonatomic, retain) NSString * accountOwnerShip;
@property (nonatomic, retain) NSString * accountType;
@property (nonatomic, retain) NSString * accountWebSite;
@property (nonatomic, retain) NSString * annualRevenue;
@property (nonatomic, retain) NSString * mailingCity;
@property (nonatomic, retain) NSString * mailingCountry;
@property (nonatomic, retain) NSString * mailingState;
@property (nonatomic, retain) NSString * mailingStreet;
@property (nonatomic, retain) NSString * mailingZIP;
@property (nonatomic, retain) NSString * numberOfEmployees;
@property (nonatomic, retain) NSString * parentAccountId;
@property (nonatomic, retain) NSNumber * favouriteStatus;

@property (nonatomic, retain) NSSet *eventsTaggedToAccount;
@property (nonatomic, retain) NSSet *opportunitiesTaggedToAccount;
@property (nonatomic, retain) NSSet *notesTaggedToAccount;
@end

@interface Accounts (CoreDataGeneratedAccessors)

- (void)addEventsTaggedToAccountObject:(Events *)value;
- (void)removeEventsTaggedToAccountObject:(Events *)value;
- (void)addEventsTaggedToAccount:(NSSet *)values;
- (void)removeEventsTaggedToAccount:(NSSet *)values;

- (void)addOpportunitiesTaggedToAccountObject:(Opportunities *)value;
- (void)removeOpportunitiesTaggedToAccountObject:(Opportunities *)value;
- (void)addOpportunitiesTaggedToAccount:(NSSet *)values;
- (void)removeOpportunitiesTaggedToAccount:(NSSet *)values;

- (void)addNotesTaggedToAccountObject:(Notes *)value;
- (void)removeNotesTaggedToAccountObject:(Notes *)value;
- (void)addNotesTaggedToAccount:(NSSet *)values;
- (void)removeNotesTaggedToAccount:(NSSet *)values;

@end
