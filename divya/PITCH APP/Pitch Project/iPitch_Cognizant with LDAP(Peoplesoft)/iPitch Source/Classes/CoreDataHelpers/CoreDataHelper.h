//
//  CoreDataHelper.h
//  iPitch V2
//
//  Created by Satheeshwaran on 6/12/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoreDataHelper : NSObject

+(void)insertEventsToStore:(NSMutableDictionary *)eventDetails CRMSyncStatus:(BOOL)status;

+(void)insertTasksToStore:(NSMutableDictionary *)taskDetails CRMSyncStatus:(BOOL)status;

+(void)insertAccountsToStore:(NSMutableDictionary *)accountDetails;

+(void)insertContactsToStore:(NSMutableDictionary *)contactDetails;

+(void)insertLeadsToStore:(NSMutableDictionary *)leadDetails;

+(void)insertOpportunitiesToStore:(NSMutableDictionary *)opportunityDetails;

+(void)insertNotesToStore:(NSMutableDictionary *)noteDetails withStatus:(BOOL)status;

@end
