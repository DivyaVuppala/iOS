//
//  Opportunities.h
//  iPitch V2
//
//  Created by Satheeshwaran on 4/2/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Events, Notes;

@interface Opportunities : NSManagedObject

@property (nonatomic, retain) NSString * opportunityAmount;
@property (nonatomic, retain) NSDate * opportunityClosingDate;
@property (nonatomic, retain) NSString * opportunityDescription;
@property (nonatomic, retain) NSString * opportunityID;
@property (nonatomic, retain) NSString * opportunityName;
@property (nonatomic, retain) NSString * opportunityProbability;
@property (nonatomic, retain) NSString * opportunityRelatedToAccountID;
@property (nonatomic, retain) NSString * opportunityRelatedToAccountName;
@property (nonatomic, retain) NSString * opportunityRelatedToContactID;
@property (nonatomic, retain) NSString * opportunityRelatedToContactName;
@property (nonatomic, retain) NSString * opportunityRevenue;
@property (nonatomic, retain) NSString * opportunityStage;
@property (nonatomic, retain) NSString * opportunityType;
@property (nonatomic, retain) NSNumber * favouriteStatus;
@property (nonatomic, retain) NSSet *eventsTaggedToOpportunity;
@property (nonatomic, retain) NSSet *notesTaggedToOpportunity;
@end

@interface Opportunities (CoreDataGeneratedAccessors)

- (void)addEventsTaggedToOpportunityObject:(Events *)value;
- (void)removeEventsTaggedToOpportunityObject:(Events *)value;
- (void)addEventsTaggedToOpportunity:(NSSet *)values;
- (void)removeEventsTaggedToOpportunity:(NSSet *)values;

- (void)addNotesTaggedToOpportunityObject:(Notes *)value;
- (void)removeNotesTaggedToOpportunityObject:(Notes *)value;
- (void)addNotesTaggedToOpportunity:(NSSet *)values;
- (void)removeNotesTaggedToOpportunity:(NSSet *)values;

@end
