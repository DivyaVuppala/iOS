//
//  SalesForceHelper.h
//  iPitch V2
//
//  Created by Satheeshwaran on 6/13/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CRMHelper.h"
#import "XMLParser.h"

typedef enum
{
    WhoModuleType = 0,
    WhatModuleType,
}
ParentModuleType;

@interface SalesForceHelper : CRMHelper


@property (nonatomic,retain)NSMutableArray *opportArray;
@property (nonatomic,retain)NSMutableArray *acntArray;

- (void)fetchActivities;

- (void)refreshoAuthToken;

- (void)fetchTasks;

- (NSError *)fetchAccounts:(NSString *)employeeID;

- (void)fetchContacts;

- (void)fetchLeads;

- (NSError *)fetchOpportunities:(NSString *)employeeID;

- (void)fetchActivitiesForID:(NSString *)ID parentModuleType:(ParentModuleType)type;

- (void)fetchOpportunitiesForID:(NSString *)recordID;

- (void)fetchNotesForParentID:(NSString *)parentID;

- (BOOL)addContactWithDetails:(NSMutableDictionary *)contactInfo;

- (BOOL)editContactForContactID:(NSString *)contactID withDetails:(NSMutableDictionary *)details;

- (BOOL)addActivityWithDetails:(NSMutableDictionary *)activityDetails;

- (void)fetchActivityDetailsForActivityID:(NSString *)ID;

- (BOOL)addTaskWithDetails:(NSMutableDictionary *)taskDetails;

- (void)fetchTasksDetailsForID:(NSString *)taskID;

- (BOOL)addActivityWithDetails:(NSMutableDictionary *)activityDetails forModule:(ModuleType)type;

- (void)fetchLeadDetailsForLeadID:(NSString *)leadID;

- (BOOL)editLeadWithLeadID:(NSString *)leadID andDetails:(NSMutableDictionary *)details;

- (BOOL)addLeadWithDetails:(NSMutableDictionary *)leadInfo;

- (void)fetchAccountDetailsForID:(NSString *)accountID;

- (BOOL)editAccountWithID:(NSString *)accountID withDetails:(NSMutableDictionary *)details;

- (NSError *)updateOpportunity:(NSMutableDictionary *)oppDic;

- (NSError *)addNote:(NSMutableDictionary *)noteDic;

- (NSError *)createOpportunity:(NSMutableDictionary *)oppDic;

@end
