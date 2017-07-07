//
//  Leads.h
//  iPitch V2
//
//  Created by Satheeshwaran on 5/11/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Events, Notes;

@interface Leads : NSManagedObject

@property (nonatomic, retain) NSString * leadFirstName;
@property (nonatomic, retain) NSString * leadOwner;
@property (nonatomic, retain) NSString * leadCompany;
@property (nonatomic, retain) NSString * leadTitle;
@property (nonatomic, retain) NSString * leadEmailID;
@property (nonatomic, retain) NSString * leadPhone;
@property (nonatomic, retain) NSString * leadMobileNo;
@property (nonatomic, retain) NSString * leadLastName;
@property (nonatomic, retain) NSString * leadFax;
@property (nonatomic, retain) NSString * leadWebsite;
@property (nonatomic, retain) NSString * leadTwitterID;
@property (nonatomic, retain) NSString * leadSource;
@property (nonatomic, retain) NSString * leadStatus;
@property (nonatomic, retain) NSString * numberOfEmployees;
@property (nonatomic, retain) NSString * leadRating;
@property (nonatomic, retain) NSString * leadSkypeID;
@property (nonatomic, retain) NSString * leadLinkedInID;
@property (nonatomic, retain) NSString * mailingCity;
@property (nonatomic, retain) NSString * mailingCountry;
@property (nonatomic, retain) NSString * mailingState;
@property (nonatomic, retain) NSString * mailingStreet;
@property (nonatomic, retain) NSString * mailingZIP;
@property (nonatomic, retain) NSString * leadDescription;
@property (nonatomic, retain) NSNumber * favouriteStatus;
@property (nonatomic, retain) NSString *leadID;
@property (nonatomic, retain) NSString *leadSalutation;
@property (nonatomic, retain) NSString *leadImageURL;
@property (nonatomic, retain) NSString *annualRevenue;
@property (nonatomic, retain) NSString *leadIndustry;
@property (nonatomic, retain) NSSet *eventsTaggedToLead;
@property (nonatomic, retain) NSSet *notesTaggedToLead;
@end

@interface Leads (CoreDataGeneratedAccessors)

- (void)addEventsTaggedToLeadObject:(Events *)value;
- (void)removeEventsTaggedToLeadObject:(Events *)value;
- (void)addEventsTaggedToLead:(NSSet *)values;
- (void)removeEventsTaggedToLead:(NSSet *)values;

- (void)addNotesTaggedToLeadObject:(Notes *)value;
- (void)removeNotesTaggedToLeadObject:(Notes *)value;
- (void)addNotesTaggedToLead:(NSSet *)values;
- (void)removeNotesTaggedToLead:(NSSet *)values;

@end
