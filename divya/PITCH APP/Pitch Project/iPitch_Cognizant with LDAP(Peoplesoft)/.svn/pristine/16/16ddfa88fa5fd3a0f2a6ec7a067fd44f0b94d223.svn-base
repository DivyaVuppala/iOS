//
//  Customers.h
//  iPitch V2
//
//  Created by Satheeshwaran on 4/2/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Events, Notes, Opportunities;

@interface Customers : NSManagedObject

@property (nonatomic, retain) NSString * accountID;
@property (nonatomic, retain) NSString * accountName;
@property (nonatomic, retain) NSString * customerID;
@property (nonatomic, retain) NSString * customerImageURL;
@property (nonatomic, retain) NSString * dateOfBirth;
@property (nonatomic, retain) NSString * department;
@property (nonatomic, retain) NSString * descriptionAboutCustomer;
@property (nonatomic, retain) NSString * emailID;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * linkedinID;
@property (nonatomic, retain) NSString * mailingCity;
@property (nonatomic, retain) NSString * mailingCountry;
@property (nonatomic, retain) NSString * mailingState;
@property (nonatomic, retain) NSString * mailingStreet;
@property (nonatomic, retain) NSString * mailingZIP;
@property (nonatomic, retain) NSString * phoneNumber;
@property (nonatomic, retain) NSString * skypeID;
@property (nonatomic, retain) NSString * twitterID;
@property (nonatomic, retain) NSNumber * favouriteStatus;

@property (nonatomic, retain) NSSet *eventsTaggedToCustomers;
@property (nonatomic, retain) NSSet *notesTaggedToCustomer;
@property (nonatomic, retain) NSSet *opportunitiesTaggedToCustomers;
@end

@interface Customers (CoreDataGeneratedAccessors)

- (void)addEventsTaggedToCustomersObject:(Events *)value;
- (void)removeEventsTaggedToCustomersObject:(Events *)value;
- (void)addEventsTaggedToCustomers:(NSSet *)values;
- (void)removeEventsTaggedToCustomers:(NSSet *)values;

- (void)addNotesTaggedToCustomerObject:(Notes *)value;
- (void)removeNotesTaggedToCustomerObject:(Notes *)value;
- (void)addNotesTaggedToCustomer:(NSSet *)values;
- (void)removeNotesTaggedToCustomer:(NSSet *)values;

- (void)addOpportunitiesTaggedToCustomersObject:(Opportunities *)value;
- (void)removeOpportunitiesTaggedToCustomersObject:(Opportunities *)value;
- (void)addOpportunitiesTaggedToCustomers:(NSSet *)values;
- (void)removeOpportunitiesTaggedToCustomers:(NSSet *)values;

@end
