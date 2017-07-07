//
//  ZohoHelper.h
//  CRMNew
//
//  Created by Sandhya Sandala on 20/12/12.
//  Copyright (c) 2012 sandhya17@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XMLWriter.h"

#import "iPitchConstants.h"

#import "ZohoConstants.h"

#import "CRMHelper.h"

@interface ZohoHelper : CRMHelper <NSURLConnectionDelegate>
{
    NSMutableArray * ActivityArray;
    NSMutableArray * LeadsArray;
    NSMutableArray * TasksArray;
    NSMutableArray * PotentialArray;
    NSMutableArray * accountArray;
    NSMutableArray * ContactArray;
    NSMutableArray * searchContactArray;
    NSMutableArray * searchAccountArray;
    NSMutableArray * searchOpportunityArray;
}


@property (nonatomic,strong) NSString * userString;
@property (nonatomic,strong) NSString * PasswordString;
@property (nonatomic,strong) NSString *token;

- (void) searchOpportunitiesFromZoho;
- (void) FetchContactsFromZoho;
- (void) check;
- (void) FetchAccountsFromZoho;
- (void) AddContactToZoho;
- (void) EditContactOFZoho;
- (void) DeleteContactFromZoho;
- (void) FetchActivitiesFromZoho;
- (void) AddTasksToZoho;
- (void) FetchTasksFromZoho;
- (void) AddActivityEventToZoho;
- (void) FetchOppOrtunitiesFromZoho;
- (BOOL)addLeadToZohoWithDetails: (NSMutableDictionary *)details;
- (void) searchAccountsFromZoho;
- (void) SearchContactsFromZoho;
- (NSMutableArray *)searchLeadsFromZoho:(NSString *)searchString;
- (void) FetchLeadsFromZoho;
- (void) FetchRelatedActivitiesForEntity:(NSString *)parentModule :(NSString *)value;
- (void) FetchRelatedOpportunitiesForEntity:(NSString *)parentModule :(NSString *)value;
- (void)AddActivityEventToZohoForModule:(ModuleType) moduleType WithDetails:(NSMutableDictionary *)details;
- (NSMutableSet *) fetchNotesForRecordID:(NSString *)recordID inModule:(NSString *)moduleName;
- (void) addNotesToRecordID:(NSString *)recordID withNoteTitle:(NSString *)title andNoteContent:(NSString *)content;

- (void)deleteNotesFromZoho:(NSString *)noteID;
- (BOOL)AddPotentialsToZohoForModule:(ModuleType)moduleType withDetails:(NSMutableDictionary *)details;
- (BOOL)updateDetailsForZohoEntity:(ModuleType )modulType WithID:(NSString *)entityID withDetails:(NSDictionary *)details;
//-(void)ZohoContacts;

@end
