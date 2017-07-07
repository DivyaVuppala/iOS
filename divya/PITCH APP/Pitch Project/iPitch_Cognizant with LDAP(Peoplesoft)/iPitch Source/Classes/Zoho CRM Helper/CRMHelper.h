//
//  CRMHelper.h
//  iPitch V2
//
//  Created by Satheeshwaran on 6/15/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iPitchConstants.h"
@interface CRMHelper : NSObject

- (void) TagActivitiesToContact;
- (void) TagOpportunitiesToAccounts;
- (void) TagActivitiesToAccounts;
- (void) TagActivitiesToOpportunities;
- (void) TagOpportunitiesToContact;
- (void) TagEventsToLead;
- (NSMutableSet *) fetchNotesforPrimaryID:(NSString *)ID;
- (BOOL) checkAttributeWithAttributeName:(NSString *)attributeName InEntityWithEntityName:(NSString *)entityName ForPreviousItems:(NSString *)itemValue inContext:(NSManagedObjectContext *)context;
- (void)deleteCRMActivitiesInEventsEntityInContext :(NSManagedObjectContext*)context;
- (void)deleteCRMTasksInTasksEntityInContext :(NSManagedObjectContext*)context;

- (BOOL)checkAttributeWithAttributeName:(NSString *)attributeName InEntityWithEntityName:(NSString *)entityName ForPreviousItems:(NSString *)itemValue;
@end
