//
//  SalesForceHelper.m
//  iPitch V2
//
//  Created by Satheeshwaran on 6/13/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//

#import "SalesForceHelper.h"

#import "Utils.h"

#import "iPitchConstants.h"

#import "ZohoConstants.h"

#import "SFHFKeychainUtils.h"

#import "CoreDataHelper.h"

#import "SNSDateUtils.h"

#import "Events.h"

#import "Accounts.h"

#import "Leads.h"

#import "Lead.h"

#import "Potentials.h"

#import "Opportunities.h"

#import "AppDelegate.h"

#define ACTIVITIES_CALL @"http://ipitch-test.apigee.net/v1/sfdcquery/services/data/v24.0/query?q=Select subject,location,ActivityDate,ActivityDateTime,CreatedById,Description,EndDateTime,Id from Event"

#define ACTIVITY_DETAILS_FOR_ID_CALL @"http://ipitch-test.apigee.net/oauth/sfdc/events/id/"

#define TASKS_CALL @"http://ipitch-test.apigee.net/v1/sfdcquery/services/data/v24.0/query?q=Select subject,Id,Status,ActivityDate,Description,Priority,CallType from Task"

#define TASK_DETAILS_FOR_ID_CALL @"http://ipitch-test.apigee.net/oauth/sfdc/tasks/id/"

#define ACCOUNTS_CALL @"http://ipitch-test.apigee.net/v1/sfdcquery/services/data/v24.0/query?q=Select name,AccountNumber,AnnualRevenue,BillingCity,BillingCountry,BillingPostalCode,BillingState,BillingStreet,Description,Fax,Id,Industry,NumberOfEmployees,Ownership,ParentId,Phone,Rating,Site,Type,Website from Account"

#define ACCOUNT_DETAILS_FOR_ID_CALL @"http://ipitch-test.apigee.net/oauth/sfdc/accounts/id/"

#define EDIT_ACCOUNT_CALL @"http://ipitch-test.apigee.net/oauth/sfdc/update/Account/"

#define CONTACTS_CALL @"http://ipitch-test.apigee.net/v1/sfdcquery/services/data/v24.0/query?q=Select FirstName,AccountId,Birthdate,Department,Description,Email,Fax,HomePhone,Id,LastName,MailingCity,MailingCountry,MailingPostalCode,MailingState,MailingStreet,MobilePhone,Name,Phone,Salutation,Title from Contact"

#define EDIT_CONTACT_CALL @"http://ipitch-test.apigee.net/oauth/sfdc/update/Contact/"

#define CONTACT_DETAILS_FOR_ID_CALL @"http://ipitch-test.apigee.net/oauth/sfdc/contacts/id/"

#define LEADS_CALL @"http://ipitch-test.apigee.net/v1/sfdcquery/services/data/v24.0/query?q=Select AnnualRevenue,City,Company,Country,Description,Email,Fax,FirstName,Id,Industry,LastName,LeadSource,MobilePhone,Name,NumberOfEmployees,Phone,PostalCode,Rating,Salutation,State,Status,Street,Title,Website from Lead"

#define LEAD_DETAILS_FOR_ID_CALL @"http://ipitch-test.apigee.net/oauth/sfdc/leads/id/"

#define EDIT_LEAD_CALL @"http://ipitch-test.apigee.net/oauth/sfdc/update/Lead/"

#define OPPORTUNITY_CALL @"https://pscrmuat.cognizant.com/PSIGW/PeopleSoftServiceListeningConnector/"

//#define OPPORTUNITY_CALL @"http://10.232.196.156:87/PSIGW/PeopleSoftServiceListeningConnector/"

//#define OPPORTUNITY_CALL @"http:// pscrmuat.cognizant.com /PSIGW/PeopleSoftServiceListeningConnector/"     //INTRANET LINK

#define EDIT_OPPORTUNITY_CALL @"http://ipitch-test.apigee.net/oauth/sfdc/update/Opportunity/"

#define ADD_OPPORTUNITY_CALL @"http://ipitch-test.apigee.net/oauth/sfdc/create/Opportunity/"

#define OPPORTUNITY_DETAILS_FOR_ID_CALL @"http://ipitch-test.apigee.net/oauth/sfdc/opportunities/id/"

#define NOTES_CALL @"http://ipitch-test.apigee.net/v1/sfdcquery/services/data/v24.0/query?q=SELECT title,body,Id,ParentId from Note"

//#define ACTIVITIES_CALL @"http://ipitch-test.apigee.net/oauth/salesforce/query?q=Select subject from event"

#define ADD_CONTACTS_CALL @"http://ipitch-test.apigee.net/oauth/sfdc/create/Contact"

#define ADD_LEADS_CALL @"http://ipitch-test.apigee.net/oauth/sfdc/create/Lead"

#define ADD_ACCOUNT_CALL @"http://ipitch-test.apigee.net/oauth/sfdc/create/Account"

#define ADD_ACTIVITY_CALL @"http://ipitch-test.apigee.net/oauth/sfdc/create/Event"

#define ADD_TASK_CALL @"http://ipitch-test.apigee.net/oauth/sfdc/create/Task"

#define LOGIN_CALL @"http://ipitch-test.apigee.net/oauth/authorize?response_type=code&crm=salesforce"

#define REFRESH_TOKEN_CALl @"http://ipitch-test.apigee.net/v1/salesforce/token?refresh_token="

#define SALESFORCE_BASE_URL @"http://ipitch-test.apigee.net/v1/sfdcquery"

@interface SalesForceHelper()
@property (nonatomic, strong) NSString *oAuthToken;

@end

@implementation SalesForceHelper
@synthesize opportArray,acntArray;
- (SalesForceHelper *) init
{
    
    self=[super init];
    NSError *error;
    NSString *token=[SFHFKeychainUtils getPasswordForUsername:OAUTH_TOKEN andServiceName:SERVICE_NAME  error:&error];
    if(!error && token)
        self.oAuthToken = token;
    else
    {
        [self refreshoAuthToken];
        token=[SFHFKeychainUtils getPasswordForUsername:OAUTH_TOKEN andServiceName:SERVICE_NAME  error:&error];
        self.oAuthToken = token;
    }
    return self;
    
}


- (void)loginToSalesForce
{
    
}

#pragma mark Activity/Event Methods

- (void)fetchActivities
{
    if(!SAppDelegateObject.postedTokenExpiredNotification)
    {
        NSString *urlString=[ACTIVITIES_CALL stringByAddingPercentEscapesUsingEncoding:NSStringEncodingConversionExternalRepresentation];
        
        NSLog(@"url: %@",urlString);
        
        NSURL *urlActivities =[NSURL URLWithString: urlString];
        
        NSMutableURLRequest *req=[[NSMutableURLRequest alloc]initWithURL:urlActivities];
        [req setHTTPMethod:@"GET"];
        [req setValue:[NSString stringWithFormat:@"OAuth %@", self.oAuthToken]  forHTTPHeaderField:@"Authorization"];
        
        NSURLResponse *res = [[NSURLResponse alloc]init];
        NSError *err;
        
        NSData *responseData=[NSURLConnection sendSynchronousRequest:req returningResponse:&res error:&err];
        if(!err)
        {
            NSError *jsonParsingError = nil;
            NSDictionary *eventsResponseDict = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&jsonParsingError];
            NSLog(@"responseActivities : %@", eventsResponseDict);
            
            NSMutableDictionary *eventDetailsDict=[[NSMutableDictionary alloc]init];
            
            if([[eventsResponseDict allKeys] containsObject:RECORDS_PARAMETER])
            {
                NSArray *recordsArray=[eventsResponseDict objectForKey:RECORDS_PARAMETER];
                for(id item in recordsArray)
                {
                    if([item isKindOfClass:[NSDictionary class]])
                    {
                        
                        if ([[item allKeys] containsObject:ZOHO_SUBJECT_PARAMETER]) {
                            
                            [eventDetailsDict setObject:[Utils checkForNull:[item objectForKey:ZOHO_SUBJECT_PARAMETER]] forKey:ZOHO_SUBJECT_PARAMETER];
                        }
                        
                        if ([[item allKeys] containsObject:LOCATION_PARAMTER]) {
                            
                            [eventDetailsDict setObject:[Utils checkForNull: [item objectForKey:LOCATION_PARAMTER]] forKey:ZOHO_VENUE_PARAMETER];
                        }
                        
                        
                        if ([[item allKeys] containsObject:START_DATE_TIME_PARARMTER]) {
                            
                            NSDate *startDate =  [SNSDateUtils dateFromUTCTimeStamp:[item objectForKey:START_DATE_TIME_PARARMTER]];;
                            
                            if(startDate)
                                [eventDetailsDict setObject:startDate forKey:ZOHO_START_TIME_PARAMETER];
                        }
                        
                        if ([[item allKeys] containsObject:END_DATE_TIME_PARAMTER]) {
                            
                            
                            NSDate *endDate =  [SNSDateUtils dateFromUTCTimeStamp:[item objectForKey:END_DATE_TIME_PARAMTER]];;
                            
                            if(endDate)
                                
                                [eventDetailsDict setObject:endDate forKey:ZOHO_END_TIME_PARAMETER];
                        }
                        
                        if ([[item allKeys] containsObject:ID_PARAMTER]) {
                            
                            [eventDetailsDict setObject:[item objectForKey:ID_PARAMTER] forKey:ZOHO_ACTIVITY_ID_PARAMETER];
                        }
                        
                        if ([[item allKeys] containsObject:ZOHO_DESCRIPTION_PARAMETER]) {
                            
                            [eventDetailsDict setObject:[Utils checkForNull:[item objectForKey:ZOHO_DESCRIPTION_PARAMETER]] forKey:ZOHO_PURPOSE_PARAMETER];
                        }
                        
                        [CoreDataHelper insertEventsToStore:eventDetailsDict CRMSyncStatus:YES];
                        
                    }
                    
                }
                
            }
        }
        
        else
        {
            [self refreshoAuthToken];
        }
        
    }
}

-(void)fetchActivitiesForID:(NSString *)ID parentModuleType:(ParentModuleType)type
{
    if(!SAppDelegateObject.postedTokenExpiredNotification)
    {
        NSString *urlString=@"";
        
        if(type == WhoModuleType)
            urlString=[[NSString stringWithFormat:@"%@ where whoId='%@'",ACTIVITIES_CALL,ID] stringByAddingPercentEscapesUsingEncoding:NSStringEncodingConversionExternalRepresentation];
        
        else if(type == WhatModuleType)
            urlString=[[NSString stringWithFormat:@"%@ where whatId='%@'",ACTIVITIES_CALL,ID] stringByAddingPercentEscapesUsingEncoding:NSStringEncodingConversionExternalRepresentation];
        
        
        NSLog(@"url: %@",urlString);
        
        NSURL *urlActivities =[NSURL URLWithString: urlString];
        
        NSMutableURLRequest *req=[[NSMutableURLRequest alloc]initWithURL:urlActivities];
        [req setHTTPMethod:@"GET"];
        [req setValue:[NSString stringWithFormat:@"OAuth %@", self.oAuthToken]  forHTTPHeaderField:@"Authorization"];
        
        NSURLResponse *res = [[NSURLResponse alloc]init];
        NSError *err;
        
        NSData *responseData=[NSURLConnection sendSynchronousRequest:req returningResponse:&res error:&err];
        if(!err)
        {
            NSError *jsonParsingError = nil;
            NSDictionary *eventsResponseDict = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&jsonParsingError];
            NSLog(@"responseActivities : %@", eventsResponseDict);
            
            NSMutableDictionary *eventDetailsDict=[[NSMutableDictionary alloc]init];
            
            if([[eventsResponseDict allKeys] containsObject:RECORDS_PARAMETER])
            {
                NSArray *recordsArray=[eventsResponseDict objectForKey:RECORDS_PARAMETER];
                for(id item in recordsArray)
                {
                    if([item isKindOfClass:[NSDictionary class]])
                    {
                        
                        if ([[item allKeys] containsObject:ZOHO_SUBJECT_PARAMETER]) {
                            
                            [eventDetailsDict setObject:[Utils checkForNull:[item objectForKey:ZOHO_SUBJECT_PARAMETER]] forKey:ZOHO_SUBJECT_PARAMETER];
                        }
                        
                        if ([[item allKeys] containsObject:LOCATION_PARAMTER]) {
                            
                            [eventDetailsDict setObject:[Utils checkForNull: [item objectForKey:LOCATION_PARAMTER]] forKey:ZOHO_VENUE_PARAMETER];
                        }
                        
                        
                        if ([[item allKeys] containsObject:START_DATE_TIME_PARARMTER]) {
                            
                            NSDate *startDate =  [SNSDateUtils dateFromUTCTimeStamp:[item objectForKey:START_DATE_TIME_PARARMTER]];;
                            
                            if(startDate)
                                [eventDetailsDict setObject:startDate forKey:ZOHO_START_TIME_PARAMETER];
                        }
                        
                        if ([[item allKeys] containsObject:END_DATE_TIME_PARAMTER]) {
                            
                            
                            NSDate *endDate =  [SNSDateUtils dateFromUTCTimeStamp:[item objectForKey:END_DATE_TIME_PARAMTER]];;
                            
                            if(endDate)
                                
                                [eventDetailsDict setObject:endDate forKey:ZOHO_END_TIME_PARAMETER];
                        }
                        
                        if ([[item allKeys] containsObject:ID_PARAMTER]) {
                            
                            [eventDetailsDict setObject:[item objectForKey:ID_PARAMTER] forKey:ZOHO_ACTIVITY_ID_PARAMETER];
                        }
                        
                        if ([[item allKeys] containsObject:ZOHO_DESCRIPTION_PARAMETER]) {
                            
                            [eventDetailsDict setObject:[Utils checkForNull:[item objectForKey:ZOHO_DESCRIPTION_PARAMETER]] forKey:ZOHO_PURPOSE_PARAMETER];
                        }
                        
                        
                        [eventDetailsDict setObject:ID forKey:ZOHO_RELATED_TO_MODULE_ID];
                        
                        [CoreDataHelper insertEventsToStore:eventDetailsDict CRMSyncStatus:YES];
                        
                    }
                    
                }
                
            }
        }
        
        else
        {
            [self refreshoAuthToken];
        }
        
    }
}


-(void)fetchActivityDetailsForActivityID:(NSString *)ID
{
    if(!SAppDelegateObject.postedTokenExpiredNotification)
    {
        NSString *urlString=[[NSString stringWithFormat:@"%@%@",ACTIVITY_DETAILS_FOR_ID_CALL,ID]stringByAddingPercentEscapesUsingEncoding:NSStringEncodingConversionExternalRepresentation];
        
        NSLog(@"url: %@",urlString);
        
        NSURL *urlActivities =[NSURL URLWithString: urlString];
        
        NSMutableURLRequest *req=[[NSMutableURLRequest alloc]initWithURL:urlActivities];
        [req setHTTPMethod:@"GET"];
        [req setValue:[NSString stringWithFormat:@"OAuth %@", self.oAuthToken]  forHTTPHeaderField:@"Authorization"];
        
        NSURLResponse *res = [[NSURLResponse alloc]init];
        NSError *err;
        
        NSData *responseData=[NSURLConnection sendSynchronousRequest:req returningResponse:&res error:&err];
        if(!err)
        {
            NSError *jsonParsingError = nil;
            NSDictionary *eventsResponseDict = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&jsonParsingError];
            NSLog(@"responseActivities : %@", eventsResponseDict);
            
            NSMutableDictionary *eventDetailsDict=[[NSMutableDictionary alloc]init];
            
            if([[eventsResponseDict allKeys] containsObject:RECORDS_PARAMETER])
            {
                NSArray *recordsArray=[eventsResponseDict objectForKey:RECORDS_PARAMETER];
                for(id item in recordsArray)
                {
                    if([item isKindOfClass:[NSDictionary class]])
                    {
                        
                        if ([[item allKeys] containsObject:ZOHO_SUBJECT_PARAMETER]) {
                            
                            [eventDetailsDict setObject:[Utils checkForNull:[item objectForKey:ZOHO_SUBJECT_PARAMETER]] forKey:ZOHO_SUBJECT_PARAMETER];
                        }
                        
                        if ([[item allKeys] containsObject:LOCATION_PARAMTER]) {
                            
                            [eventDetailsDict setObject:[Utils checkForNull: [item objectForKey:LOCATION_PARAMTER]] forKey:ZOHO_VENUE_PARAMETER];
                        }
                        
                        
                        if ([[item allKeys] containsObject:START_DATE_TIME_PARARMTER]) {
                            
                            NSDate *startDate =  [SNSDateUtils dateFromUTCTimeStamp:[item objectForKey:START_DATE_TIME_PARARMTER]];;
                            
                            if(startDate)
                                [eventDetailsDict setObject:startDate forKey:ZOHO_START_TIME_PARAMETER];
                        }
                        
                        if ([[item allKeys] containsObject:END_DATE_TIME_PARAMTER]) {
                            
                            
                            NSDate *endDate =  [SNSDateUtils dateFromUTCTimeStamp:[item objectForKey:END_DATE_TIME_PARAMTER]];;
                            
                            if(endDate)
                                
                                [eventDetailsDict setObject:endDate forKey:ZOHO_END_TIME_PARAMETER];
                        }
                        
                        if ([[item allKeys] containsObject:ID_PARAMTER]) {
                            
                            [eventDetailsDict setObject:[item objectForKey:ID_PARAMTER] forKey:ZOHO_ACTIVITY_ID_PARAMETER];
                        }
                        
                        if ([[item allKeys] containsObject:ZOHO_DESCRIPTION_PARAMETER]) {
                            
                            [eventDetailsDict setObject:[Utils checkForNull:[item objectForKey:ZOHO_DESCRIPTION_PARAMETER]] forKey:ZOHO_PURPOSE_PARAMETER];
                        }
                        
                        if ([[item allKeys] containsObject:WHO_ID_PARAMETER])
                            [eventDetailsDict setObject:[Utils checkForNull:[item objectForKey:WHO_ID_PARAMETER]] forKey:ZOHO_RELATED_TO_MODULE_ID];
                        
                        if ([[item allKeys] containsObject:WHAT_ID_PARAMETER])
                            [eventDetailsDict setObject:[Utils checkForNull:[item objectForKey:WHAT_ID_PARAMETER]] forKey:ZOHO_RELATED_TO_MODULE_ID];
                        
                        [CoreDataHelper insertEventsToStore:eventDetailsDict CRMSyncStatus:YES];
                        
                    }
                    
                }
                
            }
        }
        
        else
        {
            [self refreshoAuthToken];
        }
        
    }
}
- (BOOL)addActivityWithDetails:(NSMutableDictionary *)activityDetails
{
    if(!SAppDelegateObject.postedTokenExpiredNotification)
    {
        NSString *urlString=[ADD_ACTIVITY_CALL stringByAddingPercentEscapesUsingEncoding:NSStringEncodingConversionExternalRepresentation];
        
        NSLog(@"url: %@",urlString);
        
        NSURL *urlActivities =[NSURL URLWithString: urlString];
        
        NSMutableURLRequest *req=[[NSMutableURLRequest alloc]initWithURL:urlActivities];
        [req setHTTPMethod:@"POST"];
        [req setValue:[NSString stringWithFormat:@"OAuth %@", self.oAuthToken]  forHTTPHeaderField:@"Authorization"];
        
        NSURLResponse *res = [[NSURLResponse alloc]init];
        NSError *err;
        
        NSMutableDictionary *activityPostDict=[[NSMutableDictionary alloc]init];
        
        //Translating input dictionary from VC to SalesForce Parameters.
        
        for (id key in [activityDetails allKeys]) {
            
            if([key isEqualToString:ZOHO_VENUE_PARAMETER])
            {
                [activityPostDict setObject:[activityDetails objectForKey:key] forKey:LOCATION_PARAMTER];
            }
            
            else if([key isEqualToString:ZOHO_SUBJECT_PARAMETER])
            {
                [activityPostDict setObject:[activityDetails objectForKey:key] forKey:ZOHO_SUBJECT_PARAMETER];
            }
            
            else if([key isEqualToString:ZOHO_START_TIME_PARAMETER])
            {
                [activityPostDict setObject:[SNSDateUtils convertDateToUTC:[activityDetails objectForKey:key]] forKey:START_DATE_TIME_PARARMTER];
            }
            
            else if([key isEqualToString:ZOHO_END_TIME_PARAMETER])
            {
                [activityPostDict setObject:[SNSDateUtils convertDateToUTC:[activityDetails objectForKey:key]] forKey:END_DATE_TIME_PARAMTER];
            }
            
            else if([key isEqualToString:ZOHO_PURPOSE_PARAMETER])
            {
                [activityPostDict setObject:[activityDetails objectForKey:key] forKey:ZOHO_DESCRIPTION_PARAMETER];
            }
            
            
        }
        
        
        [activityPostDict setObject:[NSString stringWithFormat:@"%d",[SNSDateUtils getDiffernceInMinutesForDate:[activityDetails objectForKey:ZOHO_END_TIME_PARAMETER] andAnotherDate:[activityDetails objectForKey:ZOHO_START_TIME_PARAMETER] ]] forKey:DURATION_IN_MINUTES_PARAMETER];
        
        NSData *postData=[NSJSONSerialization dataWithJSONObject:activityPostDict options:NSJSONWritingPrettyPrinted error:&err];
        
        NSString* postString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        
        [req setValue:JSON_CONTENT_TYPE_PARAMETER forHTTPHeaderField:CONTENT_TYPE_PARAMETER];
        [req setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES]];
        
        NSData *responseData=[NSURLConnection sendSynchronousRequest:req returningResponse:&res error:&err];
        
        if(!err)
        {
            NSError *jsonParsingError = nil;
            NSDictionary *addActivityResponseDict = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&jsonParsingError];
            NSLog(@"addActivityResponseDict : %@", addActivityResponseDict);
            
            if([addActivityResponseDict isKindOfClass:[NSDictionary class]])
            {
                if([[addActivityResponseDict allKeys] containsObject:SUCCESS_PARAMETER])
                {
                    if([[addActivityResponseDict objectForKey:SUCCESS_PARAMETER] boolValue])
                    {
                        [self fetchActivityDetailsForActivityID:[addActivityResponseDict objectForKey:@"id"]];
                        return YES;
                    }
                }
            }
        }
        
        else
        {
            [self refreshoAuthToken];
        }
        
    }
    
    return NO;
}


- (BOOL)addActivityWithDetails:(NSMutableDictionary *)activityDetails forModule:(ModuleType)type
{
    if(!SAppDelegateObject.postedTokenExpiredNotification)
    {
        
        if([[activityDetails allKeys] containsObject:ID_PARAMTER])
        {
            NSString *urlString=[ADD_ACTIVITY_CALL stringByAddingPercentEscapesUsingEncoding:NSStringEncodingConversionExternalRepresentation];
            
            NSLog(@"url: %@",urlString);
            
            NSURL *urlActivities =[NSURL URLWithString: urlString];
            
            NSMutableURLRequest *req=[[NSMutableURLRequest alloc]initWithURL:urlActivities];
            [req setHTTPMethod:@"POST"];
            [req setValue:[NSString stringWithFormat:@"OAuth %@", self.oAuthToken]  forHTTPHeaderField:@"Authorization"];
            
            NSURLResponse *res = [[NSURLResponse alloc]init];
            NSError *err;
            
            NSMutableDictionary *activityPostDict=[[NSMutableDictionary alloc]init];
            
            //Translating input dictionary from VC to SalesForce Parameters.
            
            for (id key in [activityDetails allKeys]) {
                
                if([key isEqualToString:ZOHO_VENUE_PARAMETER])
                {
                    [activityPostDict setObject:[activityDetails objectForKey:key] forKey:LOCATION_PARAMTER];
                }
                
                else if([key isEqualToString:ZOHO_SUBJECT_PARAMETER])
                {
                    [activityPostDict setObject:[activityDetails objectForKey:key] forKey:ZOHO_SUBJECT_PARAMETER];
                }
                
                else if([key isEqualToString:ZOHO_START_TIME_PARAMETER])
                {
                    [activityPostDict setObject:[SNSDateUtils convertDateToUTC:[activityDetails objectForKey:key]] forKey:START_DATE_TIME_PARARMTER];
                }
                
                else if([key isEqualToString:ZOHO_END_TIME_PARAMETER])
                {
                    [activityPostDict setObject:[SNSDateUtils convertDateToUTC:[activityDetails objectForKey:key]] forKey:END_DATE_TIME_PARAMTER];
                }
                
                else if([key isEqualToString:ZOHO_PURPOSE_PARAMETER])
                {
                    [activityPostDict setObject:[activityDetails objectForKey:key] forKey:ZOHO_DESCRIPTION_PARAMETER];
                }
                
                
            }
            
            switch (type) {
                    
                case CustomerModule:
                    [activityPostDict setObject:[activityDetails objectForKey:ID_PARAMTER] forKey:WHO_ID_PARAMETER];
                    break;
                    
                case AccountsModule:
                    [activityPostDict setObject:[activityDetails objectForKey:ID_PARAMTER] forKey:WHAT_ID_PARAMETER];
                    break;
                    
                case OpportunitiesModule:
                    [activityPostDict setObject:[activityDetails objectForKey:ID_PARAMTER] forKey:WHAT_ID_PARAMETER];
                    break;
                    
                case LeadModule:
                    [activityPostDict setObject:[activityDetails objectForKey:ID_PARAMTER] forKey:WHAT_ID_PARAMETER];
                    
                default:
                    break;
            }
            
            [activityPostDict setObject:[NSString stringWithFormat:@"%d",[SNSDateUtils getDiffernceInMinutesForDate:[activityDetails objectForKey:ZOHO_END_TIME_PARAMETER] andAnotherDate:[activityDetails objectForKey:ZOHO_START_TIME_PARAMETER] ]] forKey:DURATION_IN_MINUTES_PARAMETER];
            
            NSData *postData=[NSJSONSerialization dataWithJSONObject:activityPostDict options:NSJSONWritingPrettyPrinted error:&err];
            
            NSString* postString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
            
            [req setValue:JSON_CONTENT_TYPE_PARAMETER forHTTPHeaderField:CONTENT_TYPE_PARAMETER];
            [req setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES]];
            
            NSData *responseData=[NSURLConnection sendSynchronousRequest:req returningResponse:&res error:&err];
            
            if(!err)
            {
                NSError *jsonParsingError = nil;
                NSDictionary *addActivityResponseDict = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&jsonParsingError];
                NSLog(@"addActivityResponseDict : %@", addActivityResponseDict);
                
                if([addActivityResponseDict isKindOfClass:[NSDictionary class]])
                {
                    if([[addActivityResponseDict allKeys] containsObject:SUCCESS_PARAMETER])
                    {
                        if([[addActivityResponseDict objectForKey:SUCCESS_PARAMETER] boolValue])
                        {
                            [self fetchActivityDetailsForActivityID:[addActivityResponseDict objectForKey:@"id"]];
                            return YES;
                        }
                    }
                }
            }
            
            else
            {
                [self refreshoAuthToken];
            }
        }
    }
    
    return NO;
}

#pragma mark Task Methods

- (void)fetchTasks
{
    if(!SAppDelegateObject.postedTokenExpiredNotification)
    {
        NSString *urlString=[TASKS_CALL stringByAddingPercentEscapesUsingEncoding:NSStringEncodingConversionExternalRepresentation];
        
        NSLog(@"url: %@",urlString);
        
        NSURL *urlActivities =[NSURL URLWithString: urlString];
        
        NSMutableURLRequest *req=[[NSMutableURLRequest alloc]initWithURL:urlActivities];
        [req setHTTPMethod:@"GET"];
        [req setValue:[NSString stringWithFormat:@"OAuth %@", self.oAuthToken]  forHTTPHeaderField:@"Authorization"];
        
        NSURLResponse *res = [[NSURLResponse alloc]init];
        NSError *err;
        
        NSData *responseData=[NSURLConnection sendSynchronousRequest:req returningResponse:&res error:&err];
        if(!err)
        {
            NSError *jsonParsingError = nil;
            NSDictionary *tasksResponseDict = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&jsonParsingError];
            NSLog(@"responseTasks : %@", tasksResponseDict);
            
            NSMutableDictionary *taskDetailsDict=[[NSMutableDictionary alloc]init];
            
            if([[tasksResponseDict allKeys] containsObject:RECORDS_PARAMETER])
            {
                NSArray *recordsArray=[tasksResponseDict objectForKey:RECORDS_PARAMETER];
                for(id item in recordsArray)
                {
                    if([item isKindOfClass:[NSDictionary class]])
                    {
                        
                        if ([[item allKeys] containsObject:ZOHO_SUBJECT_PARAMETER]) {
                            
                            [taskDetailsDict setObject:[Utils checkForNull:[item objectForKey:ZOHO_SUBJECT_PARAMETER]] forKey:ZOHO_SUBJECT_PARAMETER];
                        }
                        
                        if ([[item allKeys] containsObject:CALL_TYPE_PARAMTER]) {
                            
                            [taskDetailsDict setObject:[Utils checkForNull: [item objectForKey:CALL_TYPE_PARAMTER]] forKey:CALL_TYPE_PARAMTER];
                        }
                        
                        
                        if ([[item allKeys] containsObject:START_DATE_PARAMTER]) {
                            
                            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                            
                            NSDate *startDate =  [dateFormatter dateFromString:[Utils checkForNull:[item objectForKey:START_DATE_PARAMTER]]];
                            
                            if(startDate)
                                [taskDetailsDict setObject:startDate forKey:START_DATE_PARAMTER];
                        }
                        
                        
                        if ([[item allKeys] containsObject:PRIORITY_PARAMTER]) {
                            
                            [taskDetailsDict setObject:[Utils checkForNull:[item objectForKey:PRIORITY_PARAMTER]] forKey:PRIORITY_PARAMTER];
                        }
                        
                        if ([[item allKeys] containsObject:ZOHO_DESCRIPTION_PARAMETER]) {
                            
                            [taskDetailsDict setObject:[Utils checkForNull:[item objectForKey:ZOHO_DESCRIPTION_PARAMETER]] forKey:ZOHO_DESCRIPTION_PARAMETER];
                        }
                        
                        if ([[item allKeys] containsObject:ID_PARAMTER]) {
                            
                            [taskDetailsDict setObject:[Utils checkForNull:[item objectForKey:ID_PARAMTER]] forKey:TASK_ID_PARMETER];
                        }
                        
                        [CoreDataHelper insertTasksToStore:taskDetailsDict CRMSyncStatus:YES];
                        
                    }
                    
                }
                
            }
        }
        
        else
        {
            [self refreshoAuthToken];
        }
        
    }
}

- (void)fetchTasksDetailsForID:(NSString *)taskID
{
    
    if(!SAppDelegateObject.postedTokenExpiredNotification)
    {
        NSString *urlString=[[NSString stringWithFormat:@"%@%@",TASK_DETAILS_FOR_ID_CALL,taskID]stringByAddingPercentEscapesUsingEncoding:NSStringEncodingConversionExternalRepresentation];
        
        NSLog(@"url: %@",urlString);
        
        NSURL *urlActivities =[NSURL URLWithString: urlString];
        
        NSMutableURLRequest *req=[[NSMutableURLRequest alloc]initWithURL:urlActivities];
        [req setHTTPMethod:@"GET"];
        [req setValue:[NSString stringWithFormat:@"OAuth %@", self.oAuthToken]  forHTTPHeaderField:@"Authorization"];
        
        NSURLResponse *res = [[NSURLResponse alloc]init];
        NSError *err;
        
        NSData *responseData=[NSURLConnection sendSynchronousRequest:req returningResponse:&res error:&err];
        if(!err)
        {
            NSError *jsonParsingError = nil;
            NSDictionary *tasksResponseDict = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&jsonParsingError];
            NSLog(@"responseTasks : %@", tasksResponseDict);
            
            NSMutableDictionary *taskDetailsDict=[[NSMutableDictionary alloc]init];
            
            if([[tasksResponseDict allKeys] containsObject:RECORDS_PARAMETER])
            {
                NSArray *recordsArray=[tasksResponseDict objectForKey:RECORDS_PARAMETER];
                for(id item in recordsArray)
                {
                    if([item isKindOfClass:[NSDictionary class]])
                    {
                        
                        if ([[item allKeys] containsObject:ZOHO_SUBJECT_PARAMETER]) {
                            
                            [taskDetailsDict setObject:[Utils checkForNull:[item objectForKey:ZOHO_SUBJECT_PARAMETER]] forKey:ZOHO_SUBJECT_PARAMETER];
                        }
                        
                        if ([[item allKeys] containsObject:CALL_TYPE_PARAMTER]) {
                            
                            [taskDetailsDict setObject:[Utils checkForNull: [item objectForKey:CALL_TYPE_PARAMTER]] forKey:CALL_TYPE_PARAMTER];
                        }
                        
                        
                        if ([[item allKeys] containsObject:START_DATE_PARAMTER]) {
                            
                            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                            [dateFormatter setDateFormat:@"dd-MM-yyyy"];
                            
                            NSDate *startDate =  [dateFormatter dateFromString:[Utils checkForNull:[item objectForKey:START_DATE_PARAMTER]]];
                            
                            if(startDate)
                                [taskDetailsDict setObject:startDate forKey:START_DATE_PARAMTER];
                        }
                        
                        
                        if ([[item allKeys] containsObject:PRIORITY_PARAMTER]) {
                            
                            [taskDetailsDict setObject:[Utils checkForNull:[item objectForKey:PRIORITY_PARAMTER]] forKey:PRIORITY_PARAMTER];
                        }
                        
                        if ([[item allKeys] containsObject:ZOHO_DESCRIPTION_PARAMETER]) {
                            
                            [taskDetailsDict setObject:[Utils checkForNull:[item objectForKey:ZOHO_DESCRIPTION_PARAMETER]] forKey:ZOHO_DESCRIPTION_PARAMETER];
                        }
                        
                        if ([[item allKeys] containsObject:ID_PARAMTER]) {
                            
                            [taskDetailsDict setObject:[Utils checkForNull:[item objectForKey:ID_PARAMTER]] forKey:TASK_ID_PARMETER];
                        }
                        
                        [CoreDataHelper insertTasksToStore:taskDetailsDict CRMSyncStatus:YES];
                        
                    }
                    
                }
                
            }
        }
        
        else
        {
            [self refreshoAuthToken];
        }
        
    }
    
}
- (BOOL)addTaskWithDetails:(NSMutableDictionary *)taskDetails
{
    if(!SAppDelegateObject.postedTokenExpiredNotification)
    {
        NSString *urlString=[ADD_TASK_CALL stringByAddingPercentEscapesUsingEncoding:NSStringEncodingConversionExternalRepresentation];
        
        NSLog(@"url: %@",urlString);
        
        NSURL *urlActivities =[NSURL URLWithString: urlString];
        
        NSMutableURLRequest *req=[[NSMutableURLRequest alloc]initWithURL:urlActivities];
        [req setHTTPMethod:@"POST"];
        [req setValue:[NSString stringWithFormat:@"OAuth %@", self.oAuthToken]  forHTTPHeaderField:@"Authorization"];
        
        NSURLResponse *res = [[NSURLResponse alloc]init];
        NSError *err;
        
        NSMutableDictionary *taskPostDict=[[NSMutableDictionary alloc]init];
        
        //Translating input dictionary from VC to SalesForce Parameters.
        
        for (id key in [taskDetails allKeys]) {
            
            if([key isEqualToString:ZOHO_DESCRIPTION_PARAMETER])
            {
                [taskPostDict setObject:[taskDetails objectForKey:key] forKey:ZOHO_DESCRIPTION_PARAMETER];
            }
            
            else if([key isEqualToString:ZOHO_SUBJECT_PARAMETER])
            {
                [taskPostDict setObject:[taskDetails objectForKey:key] forKey:ZOHO_SUBJECT_PARAMETER];
            }
            
            else if([key isEqualToString:START_DATE_PARAMTER])
            {
                [taskPostDict setObject:[SNSDateUtils convertDateToUTC:[taskDetails objectForKey:key]] forKey:START_DATE_PARAMTER];
            }
            
            
        }
        
        
        NSData *postData=[NSJSONSerialization dataWithJSONObject:taskPostDict options:NSJSONWritingPrettyPrinted error:&err];
        
        NSString* postString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        
        [req setValue:JSON_CONTENT_TYPE_PARAMETER forHTTPHeaderField:CONTENT_TYPE_PARAMETER];
        [req setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES]];
        
        NSData *responseData=[NSURLConnection sendSynchronousRequest:req returningResponse:&res error:&err];
        
        if(!err)
        {
            NSError *jsonParsingError = nil;
            NSDictionary *addTaskResponseDict = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&jsonParsingError];
            NSLog(@"addTaskResponseDict : %@", addTaskResponseDict);
            
            if([addTaskResponseDict isKindOfClass:[NSDictionary class]])
            {
                if([[addTaskResponseDict allKeys] containsObject:SUCCESS_PARAMETER])
                {
                    if([[addTaskResponseDict objectForKey:SUCCESS_PARAMETER] boolValue])
                    {
                        [self fetchTasksDetailsForID:[addTaskResponseDict objectForKey:@"id"]];
                        return YES;
                    }
                }
            }
        }
        
        else
        {
            [self refreshoAuthToken];
        }
        
    }
    
    return NO;
}


- (void)fetchAccountDetailsForID:(NSString *)accountID
{
    
    if(!SAppDelegateObject.postedTokenExpiredNotification)
    {
        NSString *urlString=[[NSString stringWithFormat:@"%@%@",ACCOUNT_DETAILS_FOR_ID_CALL,accountID]stringByAddingPercentEscapesUsingEncoding:NSStringEncodingConversionExternalRepresentation];
        
        NSLog(@"url: %@",urlString);
        
        NSURL *urlActivities =[NSURL URLWithString: urlString];
        
        NSMutableURLRequest *req=[[NSMutableURLRequest alloc]initWithURL:urlActivities];
        [req setHTTPMethod:@"GET"];
        [req setValue:[NSString stringWithFormat:@"OAuth %@", self.oAuthToken]  forHTTPHeaderField:@"Authorization"];
        
        NSURLResponse *res = [[NSURLResponse alloc]init];
        NSError *err;
        
        NSData *responseData=[NSURLConnection sendSynchronousRequest:req returningResponse:&res error:&err];
        if(!err)
        {
            NSError *jsonParsingError = nil;
            NSDictionary *accountsResponseDict = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&jsonParsingError];
            NSLog(@"responseAccounts : %@", accountsResponseDict);
            
            NSMutableDictionary *accountDetailsDict=[[NSMutableDictionary alloc]init];
            
            if([[accountsResponseDict allKeys] containsObject:RECORDS_PARAMETER])
            {
                NSArray *recordsArray=[accountsResponseDict objectForKey:RECORDS_PARAMETER];
                for(id item in recordsArray)
                {
                    if([item isKindOfClass:[NSDictionary class]])
                    {
                        
                        if ([[item allKeys] containsObject:NAME_PARAMETER]) {
                            
                            [accountDetailsDict setObject:[Utils checkForNull:[item objectForKey:NAME_PARAMETER]] forKey:NAME_PARAMETER];
                        }
                        
                        if ([[item allKeys] containsObject:ANNUAL_REVENUE_PARAMETER]) {
                            
                            [accountDetailsDict setObject:[Utils checkForNull: [item objectForKey:ANNUAL_REVENUE_PARAMETER]] forKey:ANNUAL_REVENUE_PARAMETER];
                        }
                        
                        if ([[item allKeys] containsObject:BILLING_CITY_PARARMETER]) {
                            
                            [accountDetailsDict setObject:[Utils checkForNull: [item objectForKey:BILLING_CITY_PARARMETER]] forKey:BILLING_CITY_PARARMETER];
                        }
                        
                        if ([[item allKeys] containsObject:BILLING_COUNTRY_PARARMETER]) {
                            
                            [accountDetailsDict setObject:[Utils checkForNull: [item objectForKey:BILLING_COUNTRY_PARARMETER]] forKey:BILLING_COUNTRY_PARARMETER];
                        }
                        
                        if ([[item allKeys] containsObject:BILLING_ZIP_PARARMETER]) {
                            
                            [accountDetailsDict setObject:[Utils checkForNull: [item objectForKey:BILLING_ZIP_PARARMETER]] forKey:BILLING_ZIP_PARARMETER];
                        }
                        
                        if ([[item allKeys] containsObject:BILLING_STATE_PARARMETER]) {
                            
                            [accountDetailsDict setObject:[Utils checkForNull: [item objectForKey:BILLING_STATE_PARARMETER]] forKey:BILLING_STATE_PARARMETER];
                        }
                        
                        if ([[item allKeys] containsObject:BILLING_STREET_PARARMETER]) {
                            
                            [accountDetailsDict setObject:[Utils checkForNull: [item objectForKey:BILLING_STREET_PARARMETER]] forKey:BILLING_STREET_PARARMETER];
                        }
                        
                        if ([[item allKeys] containsObject:NUMBER_OF_EMPLOYEES]) {
                            
                            [accountDetailsDict setObject:[Utils checkForNull: [item objectForKey:NUMBER_OF_EMPLOYEES]] forKey:NUMBER_OF_EMPLOYEES];
                        }
                        
                        if ([[item allKeys] containsObject:PARENT_ID_PARAMETER]) {
                            
                            [accountDetailsDict setObject:[Utils checkForNull: [item objectForKey:PARENT_ID_PARAMETER]] forKey:PARENT_ID_PARAMETER];
                        }
                        
                        
                        if ([[item allKeys] containsObject:ZOHO_PHONE_PARAMETER]) {
                            
                            [accountDetailsDict setObject:[Utils checkForNull: [item objectForKey:ZOHO_PHONE_PARAMETER]] forKey:ZOHO_PHONE_PARAMETER];
                        }
                        
                        if ([[item allKeys] containsObject:ZOHO_DESCRIPTION_PARAMETER]) {
                            
                            [accountDetailsDict setObject:[Utils checkForNull: [item objectForKey:ZOHO_DESCRIPTION_PARAMETER]] forKey:ZOHO_DESCRIPTION_PARAMETER];
                        }
                        
                        
                        if ([[item allKeys] containsObject:ID_PARAMTER]) {
                            
                            [accountDetailsDict setObject:[Utils checkForNull: [item objectForKey:ID_PARAMTER]] forKey:ZOHO_ACCOUNT_ID_PARAMETER];
                        }
                        
                        if ([[item allKeys] containsObject:ZOHO_INDUSTRY_PARAMETER]) {
                            
                            [accountDetailsDict setObject:[Utils checkForNull: [item objectForKey:ZOHO_INDUSTRY_PARAMETER]] forKey:ZOHO_INDUSTRY_PARAMETER];
                        }
                        
                        if ([[item allKeys] containsObject:ZOHO_ACCOUNT_OWNERSHIP_PARAMETER]) {
                            
                            [accountDetailsDict setObject:[Utils checkForNull: [item objectForKey:ZOHO_ACCOUNT_OWNERSHIP_PARAMETER]] forKey:ZOHO_ACCOUNT_OWNERSHIP_PARAMETER];
                        }
                        
                        if ([[item allKeys] containsObject:ZOHO_TYPE_PARAMETER]) {
                            
                            [accountDetailsDict setObject:[Utils checkForNull: [item objectForKey:ZOHO_TYPE_PARAMETER]] forKey:ZOHO_TYPE_PARAMETER];
                        }
                        
                        
                        if ([[item allKeys] containsObject:ZOHO_WEBSITE_PARAMETER]) {
                            
                            [accountDetailsDict setObject:[Utils checkForNull: [item objectForKey:ZOHO_WEBSITE_PARAMETER]] forKey:ZOHO_WEBSITE_PARAMETER];
                        }
                        
                        [CoreDataHelper insertAccountsToStore:accountDetailsDict];
                        //SAppDelegateObject.opportunitiesForAccounts=accountDetailsDict;
                    }
                    
                }
                
            }
        }
        
        else
        {
            [self refreshoAuthToken];
        }
    }
    
}

- (BOOL)editAccountWithID:(NSString *)accountID withDetails:(NSMutableDictionary *)details
{
    if(!SAppDelegateObject.postedTokenExpiredNotification)
    {
        
        NSString *urlString=[[NSString stringWithFormat:@"%@%@",EDIT_ACCOUNT_CALL,accountID]stringByAddingPercentEscapesUsingEncoding:NSStringEncodingConversionExternalRepresentation];
        
        NSLog(@"url: %@",urlString);
        
        NSURL *urlActivities =[NSURL URLWithString: urlString];
        
        NSMutableURLRequest *req=[[NSMutableURLRequest alloc]initWithURL:urlActivities];
        [req setHTTPMethod:@"PATCH"];
        [req setValue:[NSString stringWithFormat:@"OAuth %@", self.oAuthToken]  forHTTPHeaderField:@"Authorization"];
        
        NSError *err;
        
        NSMutableDictionary *accountPostDict=[[NSMutableDictionary alloc]init];
        
        //Translating input dictionary from VC to SalesForce Parameters.
        
        /*[accountDetailsDict setObject:[Utils checkForNull:[item objectForKey:NAME_PARAMETER]] forKey:NAME_PARAMETER];
         
         [accountDetailsDict setObject:[Utils checkForNull: [item objectForKey:ANNUAL_REVENUE_PARAMETER]] forKey:ANNUAL_REVENUE_PARAMETER];
         
         [accountDetailsDict setObject:[Utils checkForNull: [item objectForKey:BILLING_CITY_PARARMETER]] forKey:BILLING_CITY_PARARMETER];
         
         
         [accountDetailsDict setObject:[Utils checkForNull: [item objectForKey:BILLING_COUNTRY_PARARMETER]] forKey:BILLING_COUNTRY_PARARMETER];
         */
        
        for (id key in [details allKeys]) {
            
            if([key isEqualToString:ZOHO_ACCOUNT_NAME_PARAMETER])
            {
                [accountPostDict setObject:[details objectForKey:key] forKey:NAME_PARAMETER];
            }
            
            else if([key isEqualToString:ZOHO_PHONE_PARAMETER])
            {
                [accountPostDict setObject:[details objectForKey:key] forKey:ZOHO_PHONE_PARAMETER];
            }
            
            else if([key isEqualToString:ZOHO_WEBSITE_PARAMETER])
            {
                [accountPostDict setObject:[details objectForKey:key] forKey:ZOHO_WEBSITE_PARAMETER];
            }
            else if([key isEqualToString:ZOHO_MAILING_CITY_PARAMETER])
            {
                [accountPostDict setObject:[details objectForKey:key] forKey:BILLING_CITY_PARARMETER];
            }
            else if([key isEqualToString:ZOHO_MAILING_COUNTRY_PARAMETER])
            {
                [accountPostDict setObject:[details objectForKey:key] forKey:BILLING_COUNTRY_PARARMETER];
            }
            else if([key isEqualToString:ZOHO_MAILING_STATE_PARAMETER])
            {
                [accountPostDict setObject:[details objectForKey:key] forKey:BILLING_STATE_PARARMETER];
            }
            else if([key isEqualToString:ZOHO_MAILING_STREET_PARAMETER])
            {
                [accountPostDict setObject:[details objectForKey:key] forKey:BILLING_STREET_PARARMETER];
            }
            else if([key isEqualToString:ZOHO_MAILING_ZIP_PARAMETER])
            {
                [accountPostDict setObject:[details objectForKey:key] forKey:BILLING_ZIP_PARARMETER];
            }
            else if([key isEqualToString:ZOHO_PHONE_PARAMETER])
            {
                [accountPostDict setObject:[details objectForKey:key] forKey:ZOHO_DEPARTMENT_PARAMETER];
            }
            else if([key isEqualToString:ZOHO_WEBSITE_PARAMETER])
            {
                [accountPostDict setObject:[details objectForKey:key] forKey:ZOHO_EMAIL_PARAMETER];
            }
            else if([key isEqualToString:ZOHO_ACCOUNT_REVENUE_PARAMETER])
            {
                [accountPostDict setObject:[details objectForKey:key] forKey:ANNUAL_REVENUE_PARAMETER];
            }
            else if([key isEqualToString:ZOHO_EMPLOYESS_PARAMETER])
            {
                [accountPostDict setObject:[details objectForKey:key] forKey:NUMBER_OF_EMPLOYEES];
            }
            
        }
        
        NSData *postData=[NSJSONSerialization dataWithJSONObject:accountPostDict options:NSJSONWritingPrettyPrinted error:&err];
        
        NSString* postString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSURLResponse *res = [[NSURLResponse alloc]init];
        
        [req setValue:JSON_CONTENT_TYPE_PARAMETER forHTTPHeaderField:CONTENT_TYPE_PARAMETER];
        [req setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES]];
        
        NSData *responseData=[NSURLConnection sendSynchronousRequest:req returningResponse:&res error:&err];
        NSString *string=[[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding];
        NSLog(@"response: %@",string);
        
        [self fetchAccountDetailsForID:accountID];
        
        //remove return and handle response.
        
        return YES;
        
        if(!err)
        {
            NSError *jsonParsingError = nil;
            NSDictionary *contactResponseDict = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&jsonParsingError];
            NSLog(@"contactResponseDict : %@", contactResponseDict);
            
            if([contactResponseDict isKindOfClass:[NSDictionary class]])
                if([[contactResponseDict allKeys] containsObject:SUCCESS_PARAMETER])
                {
                    if([[contactResponseDict objectForKey:SUCCESS_PARAMETER] boolValue])
                        return YES;
                }
        }
        
        else
        {
            [self refreshoAuthToken];
        }
    }
    
    return NO;
}

#pragma mark Contact Methods

- (void)fetchContacts
{
    if(!SAppDelegateObject.postedTokenExpiredNotification)
    {
        NSString *urlString=[CONTACTS_CALL stringByAddingPercentEscapesUsingEncoding:NSStringEncodingConversionExternalRepresentation];
        
        NSLog(@"url: %@",urlString);
        
        NSURL *urlActivities =[NSURL URLWithString: urlString];
        
        NSMutableURLRequest *req=[[NSMutableURLRequest alloc]initWithURL:urlActivities];
        [req setHTTPMethod:@"GET"];
        [req setValue:[NSString stringWithFormat:@"OAuth %@", self.oAuthToken]  forHTTPHeaderField:@"Authorization"];
        
        NSURLResponse *res = [[NSURLResponse alloc]init];
        NSError *err;
        
        NSData *responseData=[NSURLConnection sendSynchronousRequest:req returningResponse:&res error:&err];
        if(!err)
        {
            NSError *jsonParsingError = nil;
            NSDictionary *contactResponseDict = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&jsonParsingError];
            NSLog(@"contactResponseDict : %@", contactResponseDict);
            
            NSMutableDictionary *contactDetailsDict=[[NSMutableDictionary alloc]init];
            
            if([[contactResponseDict allKeys] containsObject:RECORDS_PARAMETER])
            {
                NSArray *recordsArray=[contactResponseDict objectForKey:RECORDS_PARAMETER];
                for(id item in recordsArray)
                {
                    if([item isKindOfClass:[NSDictionary class]])
                    {
                        
                        if ([[item allKeys] containsObject:ACCOUNT_ID_PARAMTER]) {
                            
                            [contactDetailsDict setObject:[Utils checkForNull:[item objectForKey:ACCOUNT_ID_PARAMTER]] forKey:ACCOUNT_ID_PARAMTER];
                        }
                        
                        if ([[item allKeys] containsObject:ID_PARAMTER]) {
                            
                            [contactDetailsDict setObject:[Utils checkForNull:[item objectForKey:ID_PARAMTER]] forKey:CONTACT_ID_PARAMETER];
                        }
                        
                        if ([[item allKeys] containsObject:BIRTH_DATE_PARAMETER]) {
                            
                            [contactDetailsDict setObject:[Utils checkForNull: [item objectForKey:BIRTH_DATE_PARAMETER]] forKey:BIRTH_DATE_PARAMETER];
                        }
                        
                        if ([[item allKeys] containsObject:ZOHO_DEPARTMENT_PARAMETER]) {
                            
                            [contactDetailsDict setObject:[Utils checkForNull: [item objectForKey:ZOHO_DEPARTMENT_PARAMETER]] forKey:ZOHO_DEPARTMENT_PARAMETER];
                        }
                        
                        if ([[item allKeys] containsObject:ZOHO_DESCRIPTION_PARAMETER]) {
                            
                            [contactDetailsDict setObject:[Utils checkForNull: [item objectForKey:ZOHO_DESCRIPTION_PARAMETER]] forKey:ZOHO_DESCRIPTION_PARAMETER];
                        }
                        
                        if ([[item allKeys] containsObject:ZOHO_EMAIL_PARAMETER]) {
                            
                            [contactDetailsDict setObject:[Utils checkForNull: [item objectForKey:ZOHO_EMAIL_PARAMETER]] forKey:ZOHO_EMAIL_PARAMETER];
                        }
                        
                        if ([[item allKeys] containsObject:FIRST_NAME_PARAMETER]) {
                            
                            [contactDetailsDict setObject:[Utils checkForNull: [item objectForKey:FIRST_NAME_PARAMETER]] forKey:FIRST_NAME_PARAMETER];
                        }
                        
                        if ([[item allKeys] containsObject:LAST_NAME_PARAMTER]) {
                            
                            [contactDetailsDict setObject:[Utils checkForNull: [item objectForKey:LAST_NAME_PARAMTER]] forKey:LAST_NAME_PARAMTER];
                        }
                        
                        if ([[item allKeys] containsObject:MOBILE_PHONE_PARAMETER]) {
                            
                            [contactDetailsDict setObject:[Utils checkForNull: [item objectForKey:MOBILE_PHONE_PARAMETER]] forKey:MOBILE_PHONE_PARAMETER];
                        }
                        
                        if ([[item allKeys] containsObject:NAME_PARAMETER]) {
                            
                            [contactDetailsDict setObject:[Utils checkForNull: [item objectForKey:NAME_PARAMETER]] forKey:NAME_PARAMETER];
                        }
                        
                        if ([[item allKeys] containsObject:ZOHO_PHONE_PARAMETER]) {
                            
                            [contactDetailsDict setObject:[Utils checkForNull: [item objectForKey:ZOHO_PHONE_PARAMETER]] forKey:ZOHO_PHONE_PARAMETER];
                        }
                        
                        if ([[item allKeys] containsObject:ZOHO_SALUTATION_PARAMETER]) {
                            
                            [contactDetailsDict setObject:[Utils checkForNull: [item objectForKey:ZOHO_SALUTATION_PARAMETER]] forKey:ZOHO_SALUTATION_PARAMETER];
                        }
                        
                        if ([[item allKeys] containsObject:MAILING_CITY_PARAMETER]) {
                            
                            [contactDetailsDict setObject:[Utils checkForNull: [item objectForKey:MAILING_CITY_PARAMETER]] forKey:MAILING_CITY_PARAMETER];
                        }
                        
                        if ([[item allKeys] containsObject:MAILING_COUNTRY_PARAMETER]) {
                            
                            [contactDetailsDict setObject:[Utils checkForNull: [item objectForKey:MAILING_COUNTRY_PARAMETER]] forKey:MAILING_COUNTRY_PARAMETER];
                        }
                        
                        if ([[item allKeys] containsObject:MAILING_POSTAL_CODE]) {
                            
                            [contactDetailsDict setObject:[Utils checkForNull: [item objectForKey:MAILING_POSTAL_CODE]] forKey:MAILING_POSTAL_CODE];
                        }
                        
                        if ([[item allKeys] containsObject:MAILING_STATE_PARAMETER]) {
                            
                            [contactDetailsDict setObject:[Utils checkForNull: [item objectForKey:MAILING_STATE_PARAMETER]] forKey:MAILING_STATE_PARAMETER];
                        }
                        
                        if ([[item allKeys] containsObject:MAILING_STREET_PARAMETER]) {
                            
                            [contactDetailsDict setObject:[Utils checkForNull: [item objectForKey:MAILING_STREET_PARAMETER]] forKey:MAILING_STREET_PARAMETER];
                        }
                        
                        
                        [CoreDataHelper insertContactsToStore:contactDetailsDict];
                        
                    }
                }
            }
        }
        
        else
        {
            [self refreshoAuthToken];
        }
    }
}


- (void)fetchContactDetailsForID:(NSString *)contactID
{
    
    if(!SAppDelegateObject.postedTokenExpiredNotification)
    {
        NSString *urlString=[[NSString stringWithFormat:@"%@%@",CONTACT_DETAILS_FOR_ID_CALL,contactID]stringByAddingPercentEscapesUsingEncoding:NSStringEncodingConversionExternalRepresentation];
        
        NSLog(@"url: %@",urlString);
        
        NSURL *urlActivities =[NSURL URLWithString: urlString];
        
        NSMutableURLRequest *req=[[NSMutableURLRequest alloc]initWithURL:urlActivities];
        [req setHTTPMethod:@"GET"];
        [req setValue:[NSString stringWithFormat:@"OAuth %@", self.oAuthToken]  forHTTPHeaderField:@"Authorization"];
        
        NSURLResponse *res = [[NSURLResponse alloc]init];
        NSError *err;
        
        NSData *responseData=[NSURLConnection sendSynchronousRequest:req returningResponse:&res error:&err];
        if(!err)
        {
            NSError *jsonParsingError = nil;
            NSDictionary *contactResponseDict = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&jsonParsingError];
            NSLog(@"contactResponseDict : %@", contactResponseDict);
            
            NSMutableDictionary *contactDetailsDict=[[NSMutableDictionary alloc]init];
            
            if([[contactResponseDict allKeys] containsObject:RECORDS_PARAMETER])
            {
                NSArray *recordsArray=[contactResponseDict objectForKey:RECORDS_PARAMETER];
                for(id item in recordsArray)
                {
                    if([item isKindOfClass:[NSDictionary class]])
                    {
                        
                        if ([[item allKeys] containsObject:ACCOUNT_ID_PARAMTER]) {
                            
                            [contactDetailsDict setObject:[Utils checkForNull:[item objectForKey:ACCOUNT_ID_PARAMTER]] forKey:ACCOUNT_ID_PARAMTER];
                        }
                        
                        if ([[item allKeys] containsObject:ID_PARAMTER]) {
                            
                            [contactDetailsDict setObject:[Utils checkForNull:[item objectForKey:ID_PARAMTER]] forKey:CONTACT_ID_PARAMETER];
                        }
                        
                        if ([[item allKeys] containsObject:BIRTH_DATE_PARAMETER]) {
                            
                            [contactDetailsDict setObject:[Utils checkForNull: [item objectForKey:BIRTH_DATE_PARAMETER]] forKey:BIRTH_DATE_PARAMETER];
                        }
                        
                        if ([[item allKeys] containsObject:ZOHO_DEPARTMENT_PARAMETER]) {
                            
                            [contactDetailsDict setObject:[Utils checkForNull: [item objectForKey:ZOHO_DEPARTMENT_PARAMETER]] forKey:ZOHO_DEPARTMENT_PARAMETER];
                        }
                        
                        if ([[item allKeys] containsObject:ZOHO_DESCRIPTION_PARAMETER]) {
                            
                            [contactDetailsDict setObject:[Utils checkForNull: [item objectForKey:ZOHO_DESCRIPTION_PARAMETER]] forKey:ZOHO_DESCRIPTION_PARAMETER];
                        }
                        
                        if ([[item allKeys] containsObject:ZOHO_EMAIL_PARAMETER]) {
                            
                            [contactDetailsDict setObject:[Utils checkForNull: [item objectForKey:ZOHO_EMAIL_PARAMETER]] forKey:ZOHO_EMAIL_PARAMETER];
                        }
                        
                        if ([[item allKeys] containsObject:FIRST_NAME_PARAMETER]) {
                            
                            [contactDetailsDict setObject:[Utils checkForNull: [item objectForKey:FIRST_NAME_PARAMETER]] forKey:FIRST_NAME_PARAMETER];
                        }
                        
                        if ([[item allKeys] containsObject:LAST_NAME_PARAMTER]) {
                            
                            [contactDetailsDict setObject:[Utils checkForNull: [item objectForKey:LAST_NAME_PARAMTER]] forKey:LAST_NAME_PARAMTER];
                        }
                        
                        if ([[item allKeys] containsObject:MOBILE_PHONE_PARAMETER]) {
                            
                            [contactDetailsDict setObject:[Utils checkForNull: [item objectForKey:MOBILE_PHONE_PARAMETER]] forKey:MOBILE_PHONE_PARAMETER];
                        }
                        
                        if ([[item allKeys] containsObject:NAME_PARAMETER]) {
                            
                            [contactDetailsDict setObject:[Utils checkForNull: [item objectForKey:NAME_PARAMETER]] forKey:NAME_PARAMETER];
                        }
                        
                        if ([[item allKeys] containsObject:ZOHO_PHONE_PARAMETER]) {
                            
                            [contactDetailsDict setObject:[Utils checkForNull: [item objectForKey:ZOHO_PHONE_PARAMETER]] forKey:ZOHO_PHONE_PARAMETER];
                        }
                        
                        if ([[item allKeys] containsObject:ZOHO_SALUTATION_PARAMETER]) {
                            
                            [contactDetailsDict setObject:[Utils checkForNull: [item objectForKey:ZOHO_SALUTATION_PARAMETER]] forKey:ZOHO_SALUTATION_PARAMETER];
                        }
                        
                        if ([[item allKeys] containsObject:MAILING_CITY_PARAMETER]) {
                            
                            [contactDetailsDict setObject:[Utils checkForNull: [item objectForKey:MAILING_CITY_PARAMETER]] forKey:MAILING_CITY_PARAMETER];
                        }
                        
                        if ([[item allKeys] containsObject:MAILING_COUNTRY_PARAMETER]) {
                            
                            [contactDetailsDict setObject:[Utils checkForNull: [item objectForKey:MAILING_COUNTRY_PARAMETER]] forKey:MAILING_COUNTRY_PARAMETER];
                        }
                        
                        if ([[item allKeys] containsObject:MAILING_POSTAL_CODE]) {
                            
                            [contactDetailsDict setObject:[Utils checkForNull: [item objectForKey:MAILING_POSTAL_CODE]] forKey:MAILING_POSTAL_CODE];
                        }
                        
                        if ([[item allKeys] containsObject:MAILING_STATE_PARAMETER]) {
                            
                            [contactDetailsDict setObject:[Utils checkForNull: [item objectForKey:MAILING_STATE_PARAMETER]] forKey:MAILING_STATE_PARAMETER];
                        }
                        
                        if ([[item allKeys] containsObject:MAILING_STREET_PARAMETER]) {
                            
                            [contactDetailsDict setObject:[Utils checkForNull: [item objectForKey:MAILING_STREET_PARAMETER]] forKey:MAILING_STREET_PARAMETER];
                        }
                        
                        
                        [CoreDataHelper insertContactsToStore:contactDetailsDict];
                        
                    }
                }
            }
        }
        
        else
        {
            [self refreshoAuthToken];
        }
    }
    
}

- (BOOL)addContactWithDetails:(NSMutableDictionary *)contactInfo
{
    if(!SAppDelegateObject.postedTokenExpiredNotification)
    {
        NSString *urlString=[ADD_CONTACTS_CALL stringByAddingPercentEscapesUsingEncoding:NSStringEncodingConversionExternalRepresentation];
        
        NSLog(@"url: %@",urlString);
        
        NSURL *urlActivities =[NSURL URLWithString: urlString];
        
        NSMutableURLRequest *req=[[NSMutableURLRequest alloc]initWithURL:urlActivities];
        [req setHTTPMethod:@"POST"];
        [req setValue:[NSString stringWithFormat:@"OAuth %@", self.oAuthToken]  forHTTPHeaderField:@"Authorization"];
        
        NSError *err;
        
        NSMutableDictionary *contactPostDict=[[NSMutableDictionary alloc]init];
        
        //Translating input dictionary from VC to SalesForce Parameters.
        
        for (id key in [contactInfo allKeys]) {
            
            if([key isEqualToString:ZOHO_FIRST_NAME_PARAMETER])
            {
                [contactPostDict setObject:[contactInfo objectForKey:key] forKey:FIRST_NAME_PARAMETER];
            }
            
            else if([key isEqualToString:ZOHO_LAST_NAME_PARAMETER])
            {
                [contactPostDict setObject:[contactInfo objectForKey:key] forKey:LAST_NAME_PARAMTER];
            }
            
            else if([key isEqualToString:ZOHO_MAILING_CITY_PARAMETER])
            {
                [contactPostDict setObject:[contactInfo objectForKey:key] forKey:MAILING_CITY_PARAMETER];
            }
            else if([key isEqualToString:ZOHO_MAILING_CITY_PARAMETER])
            {
                [contactPostDict setObject:[contactInfo objectForKey:key] forKey:MAILING_CITY_PARAMETER];
            }
            else if([key isEqualToString:ZOHO_MAILING_COUNTRY_PARAMETER])
            {
                [contactPostDict setObject:[contactInfo objectForKey:key] forKey:MAILING_COUNTRY_PARAMETER];
            }
            else if([key isEqualToString:ZOHO_MAILING_STATE_PARAMETER])
            {
                [contactPostDict setObject:[contactInfo objectForKey:key] forKey:MAILING_STATE_PARAMETER];
            }
            else if([key isEqualToString:ZOHO_MAILING_STREET_PARAMETER])
            {
                [contactPostDict setObject:[contactInfo objectForKey:key] forKey:MAILING_STREET_PARAMETER];
            }
            else if([key isEqualToString:ZOHO_MAILING_ZIP_PARAMETER])
            {
                [contactPostDict setObject:[contactInfo objectForKey:key] forKey:MAILING_POSTAL_CODE];
            }
            else if([key isEqualToString:ZOHO_DEPARTMENT_PARAMETER])
            {
                [contactPostDict setObject:[contactInfo objectForKey:key] forKey:ZOHO_DEPARTMENT_PARAMETER];
            }
            else if([key isEqualToString:ZOHO_EMAIL_PARAMETER])
            {
                [contactPostDict setObject:[contactInfo objectForKey:key] forKey:ZOHO_EMAIL_PARAMETER];
            }
            else if([key isEqualToString:ZOHO_PHONE_PARAMETER])
            {
                [contactPostDict setObject:[contactInfo objectForKey:key] forKey:ZOHO_PHONE_PARAMETER];
            }
            
            
        }
        
        NSData *postData=[NSJSONSerialization dataWithJSONObject:contactPostDict options:NSJSONWritingPrettyPrinted error:&err];
        
        NSString* postString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSURLResponse *res = [[NSURLResponse alloc]init];
        
        [req setValue:JSON_CONTENT_TYPE_PARAMETER forHTTPHeaderField:CONTENT_TYPE_PARAMETER];
        [req setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES]];
        
        NSData *responseData=[NSURLConnection sendSynchronousRequest:req returningResponse:&res error:&err];
        
        if(!err)
        {
            NSError *jsonParsingError = nil;
            NSDictionary *contactResponseDict = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&jsonParsingError];
            NSLog(@"contactResponseDict : %@", contactResponseDict);
            if([contactResponseDict isKindOfClass:[NSDictionary class]])
            {
                if([[contactResponseDict allKeys] containsObject:SUCCESS_PARAMETER])
                {
                    if([[contactResponseDict objectForKey:SUCCESS_PARAMETER] boolValue])
                        [self fetchContactDetailsForID:[contactResponseDict objectForKey:@"id"]];
                    return YES;
                }
            }
        }
        
        else
        {
            [self refreshoAuthToken];
        }
    }
    
    return NO;
}

- (BOOL)editContactForContactID:(NSString *)contactID withDetails:(NSMutableDictionary *)details
{
    if(!SAppDelegateObject.postedTokenExpiredNotification)
    {
        
        NSString *urlString=[[NSString stringWithFormat:@"%@%@",EDIT_CONTACT_CALL,contactID]stringByAddingPercentEscapesUsingEncoding:NSStringEncodingConversionExternalRepresentation];
        
        NSLog(@"url: %@",urlString);
        
        NSURL *urlActivities =[NSURL URLWithString: urlString];
        
        NSMutableURLRequest *req=[[NSMutableURLRequest alloc]initWithURL:urlActivities];
        [req setHTTPMethod:@"PATCH"];
        [req setValue:[NSString stringWithFormat:@"OAuth %@", self.oAuthToken]  forHTTPHeaderField:@"Authorization"];
        
        NSError *err;
        
        NSMutableDictionary *contactPostDict=[[NSMutableDictionary alloc]init];
        
        //Translating input dictionary from VC to SalesForce Parameters.
        
        for (id key in [details allKeys]) {
            
            if([key isEqualToString:ZOHO_FIRST_NAME_PARAMETER])
            {
                [contactPostDict setObject:[details objectForKey:key] forKey:FIRST_NAME_PARAMETER];
            }
            
            else if([key isEqualToString:ZOHO_LAST_NAME_PARAMETER])
            {
                [contactPostDict setObject:[details objectForKey:key] forKey:LAST_NAME_PARAMTER];
            }
            
            else if([key isEqualToString:ZOHO_MAILING_CITY_PARAMETER])
            {
                [contactPostDict setObject:[details objectForKey:key] forKey:MAILING_CITY_PARAMETER];
            }
            else if([key isEqualToString:ZOHO_MAILING_CITY_PARAMETER])
            {
                [contactPostDict setObject:[details objectForKey:key] forKey:MAILING_CITY_PARAMETER];
            }
            else if([key isEqualToString:ZOHO_MAILING_COUNTRY_PARAMETER])
            {
                [contactPostDict setObject:[details objectForKey:key] forKey:MAILING_COUNTRY_PARAMETER];
            }
            else if([key isEqualToString:ZOHO_MAILING_STATE_PARAMETER])
            {
                [contactPostDict setObject:[details objectForKey:key] forKey:MAILING_STATE_PARAMETER];
            }
            else if([key isEqualToString:ZOHO_MAILING_STREET_PARAMETER])
            {
                [contactPostDict setObject:[details objectForKey:key] forKey:MAILING_STREET_PARAMETER];
            }
            else if([key isEqualToString:ZOHO_MAILING_ZIP_PARAMETER])
            {
                [contactPostDict setObject:[details objectForKey:key] forKey:MAILING_POSTAL_CODE];
            }
            else if([key isEqualToString:ZOHO_DEPARTMENT_PARAMETER])
            {
                [contactPostDict setObject:[details objectForKey:key] forKey:ZOHO_DEPARTMENT_PARAMETER];
            }
            else if([key isEqualToString:ZOHO_EMAIL_PARAMETER])
            {
                [contactPostDict setObject:[details objectForKey:key] forKey:ZOHO_EMAIL_PARAMETER];
            }
            else if([key isEqualToString:ZOHO_PHONE_PARAMETER])
            {
                [contactPostDict setObject:[details objectForKey:key] forKey:ZOHO_PHONE_PARAMETER];
            }
            
            
        }
        
        NSData *postData=[NSJSONSerialization dataWithJSONObject:contactPostDict options:NSJSONWritingPrettyPrinted error:&err];
        
        NSString* postString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSURLResponse *res = [[NSURLResponse alloc]init];
        
        [req setValue:JSON_CONTENT_TYPE_PARAMETER forHTTPHeaderField:CONTENT_TYPE_PARAMETER];
        [req setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES]];
        
        NSData *responseData=[NSURLConnection sendSynchronousRequest:req returningResponse:&res error:&err];
        NSString *string=[[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding];
        NSLog(@"response: %@",string);
        
        [self fetchContactDetailsForID:contactID];
        
        //remove return and handle response.
        
        return YES;
        
        if(!err)
        {
            NSError *jsonParsingError = nil;
            NSDictionary *contactResponseDict = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&jsonParsingError];
            NSLog(@"contactResponseDict : %@", contactResponseDict);
            
            if([contactResponseDict isKindOfClass:[NSDictionary class]])
                if([[contactResponseDict allKeys] containsObject:SUCCESS_PARAMETER])
                {
                    if([[contactResponseDict objectForKey:SUCCESS_PARAMETER] boolValue])
                        return YES;
                }
        }
        
        else
        {
            [self refreshoAuthToken];
        }
    }
    
    return NO;
}

#pragma mark Lead Methods

- (void)fetchLeads
{
    if(!SAppDelegateObject.postedTokenExpiredNotification)
    {
        NSString *urlString=[LEADS_CALL stringByAddingPercentEscapesUsingEncoding:NSStringEncodingConversionExternalRepresentation];
        
        NSLog(@"url: %@",urlString);
        
        NSURL *urlActivities =[NSURL URLWithString: urlString];
        
        NSMutableURLRequest *req=[[NSMutableURLRequest alloc]initWithURL:urlActivities];
        [req setHTTPMethod:@"GET"];
        [req setValue:[NSString stringWithFormat:@"OAuth %@", self.oAuthToken]  forHTTPHeaderField:@"Authorization"];
        
        NSURLResponse *res = [[NSURLResponse alloc]init];
        NSError *err;
        
        NSData *responseData=[NSURLConnection sendSynchronousRequest:req returningResponse:&res error:&err];
        if(!err)
        {
            NSError *jsonParsingError = nil;
            NSDictionary *leadResponseDict = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&jsonParsingError];
            NSLog(@"leadResponseDict : %@", leadResponseDict);
            
            NSMutableDictionary *leadDetailsDict=[[NSMutableDictionary alloc]init];
            
            if([[leadResponseDict allKeys] containsObject:RECORDS_PARAMETER])
            {
                NSArray *recordsArray=[leadResponseDict objectForKey:RECORDS_PARAMETER];
                for(id item in recordsArray)
                {
                    if([item isKindOfClass:[NSDictionary class]])
                    {
                        
                        if ([[item allKeys] containsObject:ANNUAL_REVENUE_PARAMETER]) {
                            
                            [leadDetailsDict setObject:[Utils checkForNull: [item objectForKey:ANNUAL_REVENUE_PARAMETER]] forKey:ANNUAL_REVENUE_PARAMETER];
                        }
                        
                        if ([[item allKeys] containsObject:FIRST_NAME_PARAMETER]) {
                            
                            [leadDetailsDict setObject:[Utils checkForNull: [item objectForKey:FIRST_NAME_PARAMETER]] forKey:FIRST_NAME_PARAMETER];
                        }
                        
                        if ([[item allKeys] containsObject:LAST_NAME_PARAMTER]) {
                            
                            [leadDetailsDict setObject:[Utils checkForNull: [item objectForKey:LAST_NAME_PARAMTER]] forKey:LAST_NAME_PARAMTER];
                        }
                        
                        if ([[item allKeys] containsObject:ZOHO_CITY_PARAMETER]) {
                            
                            [leadDetailsDict setObject:[Utils checkForNull: [item objectForKey:ZOHO_CITY_PARAMETER]] forKey:ZOHO_CITY_PARAMETER];
                        }
                        
                        if ([[item allKeys] containsObject:ZOHO_COMPANY_PARAMETER]) {
                            
                            [leadDetailsDict setObject:[Utils checkForNull: [item objectForKey:ZOHO_COMPANY_PARAMETER]] forKey:ZOHO_COMPANY_PARAMETER];
                        }
                        
                        if ([[item allKeys] containsObject:ZOHO_COUNTRY_PARAMETER]) {
                            
                            [leadDetailsDict setObject:[Utils checkForNull: [item objectForKey:ZOHO_COUNTRY_PARAMETER]] forKey:ZOHO_COUNTRY_PARAMETER];
                        }
                        
                        if ([[item allKeys] containsObject:ZOHO_DESCRIPTION_PARAMETER]) {
                            
                            [leadDetailsDict setObject:[Utils checkForNull: [item objectForKey:ZOHO_DESCRIPTION_PARAMETER]] forKey:ZOHO_DESCRIPTION_PARAMETER];
                        }
                        
                        if ([[item allKeys] containsObject:ZOHO_EMAIL_PARAMETER]) {
                            
                            [leadDetailsDict setObject:[Utils checkForNull: [item objectForKey:ZOHO_EMAIL_PARAMETER]] forKey:ZOHO_EMAIL_PARAMETER];
                        }
                        
                        
                        if ([[item allKeys] containsObject:ZOHO_FAX_PARAMETER]) {
                            
                            [leadDetailsDict setObject:[Utils checkForNull: [item objectForKey:ZOHO_FAX_PARAMETER] ]forKey:ZOHO_FAX_PARAMETER];
                        }
                        
                        
                        if ([[item allKeys] containsObject:ID_PARAMTER]) {
                            
                            [leadDetailsDict setObject:[Utils checkForNull: [item objectForKey:ID_PARAMTER]] forKey:ID_PARAMTER];
                        }
                        
                        if ([[item allKeys] containsObject:ZOHO_INDUSTRY_PARAMETER]) {
                            
                            [leadDetailsDict setObject:[Utils checkForNull: [item objectForKey:ZOHO_INDUSTRY_PARAMETER] ]forKey:ZOHO_INDUSTRY_PARAMETER];
                        }
                        
                        if ([[item allKeys] containsObject:LEAD_SOURCE_PARAMETER]) {
                            
                            [leadDetailsDict setObject:[Utils checkForNull: [item objectForKey:LEAD_SOURCE_PARAMETER]] forKey:LEAD_SOURCE_PARAMETER];
                        }
                        
                        if ([[item allKeys] containsObject:MOBILE_PHONE_PARAMETER]) {
                            
                            [leadDetailsDict setObject:[Utils checkForNull: [item objectForKey:MOBILE_PHONE_PARAMETER]] forKey:MOBILE_PHONE_PARAMETER];
                        }
                        
                        
                        if ([[item allKeys] containsObject:NUMBER_OF_EMPLOYEES]) {
                            
                            [leadDetailsDict setObject:[Utils checkForNull: [item objectForKey:NUMBER_OF_EMPLOYEES]] forKey:NUMBER_OF_EMPLOYEES];
                        }
                        
                        if ([[item allKeys] containsObject:ZOHO_PHONE_PARAMETER]) {
                            
                            [leadDetailsDict setObject:[Utils checkForNull: [item objectForKey:ZOHO_PHONE_PARAMETER]] forKey:ZOHO_PHONE_PARAMETER];
                        }
                        
                        if ([[item allKeys] containsObject:POSTAL_CODE_PARAMETER]) {
                            
                            [leadDetailsDict setObject:[Utils checkForNull: [item objectForKey:POSTAL_CODE_PARAMETER]] forKey:POSTAL_CODE_PARAMETER];
                        }
                        
                        if ([[item allKeys] containsObject:ZOHO_RATING_PARAMETER]) {
                            
                            [leadDetailsDict setObject:[Utils checkForNull: [item objectForKey:ZOHO_RATING_PARAMETER]] forKey:ZOHO_RATING_PARAMETER];
                        }
                        
                        if ([[item allKeys] containsObject:ZOHO_SALUTATION_PARAMETER]) {
                            
                            [leadDetailsDict setObject:[Utils checkForNull: [item objectForKey:ZOHO_SALUTATION_PARAMETER]] forKey:ZOHO_SALUTATION_PARAMETER];
                        }
                        
                        if ([[item allKeys] containsObject:ZOHO_STATE_PARAMETER]) {
                            
                            [leadDetailsDict setObject:[Utils checkForNull: [item objectForKey:ZOHO_STATE_PARAMETER]] forKey:ZOHO_STATE_PARAMETER];
                        }
                        
                        if ([[item allKeys] containsObject:STATUS_PARAMETER]) {
                            
                            [leadDetailsDict setObject:[Utils checkForNull: [item objectForKey:STATUS_PARAMETER]] forKey:STATUS_PARAMETER];
                        }
                        
                        if ([[item allKeys] containsObject:ZOHO_STREET_PARAMETER]) {
                            
                            [leadDetailsDict setObject:[Utils checkForNull: [item objectForKey:ZOHO_STREET_PARAMETER]] forKey:ZOHO_STREET_PARAMETER];
                        }
                        
                        if ([[item allKeys] containsObject:TITLE_PARAMETER]) {
                            
                            [leadDetailsDict setObject:[Utils checkForNull: [item objectForKey:TITLE_PARAMETER]] forKey:TITLE_PARAMETER];
                        }
                        
                        [CoreDataHelper insertLeadsToStore:leadDetailsDict];
                        
                    }
                }
            }
        }
        
        else
        {
            [self refreshoAuthToken];
        }
    }
}

- (void)fetchLeadDetailsForLeadID:(NSString *)leadID
{
    if(!SAppDelegateObject.postedTokenExpiredNotification)
    {
        NSString *urlString=[[NSString stringWithFormat:@"%@%@",LEAD_DETAILS_FOR_ID_CALL,leadID]stringByAddingPercentEscapesUsingEncoding:NSStringEncodingConversionExternalRepresentation];
        
        NSLog(@"url: %@",urlString);
        
        NSURL *urlActivities =[NSURL URLWithString: urlString];
        
        NSMutableURLRequest *req=[[NSMutableURLRequest alloc]initWithURL:urlActivities];
        [req setHTTPMethod:@"GET"];
        [req setValue:[NSString stringWithFormat:@"OAuth %@", self.oAuthToken]  forHTTPHeaderField:@"Authorization"];
        
        NSURLResponse *res = [[NSURLResponse alloc]init];
        NSError *err;
        
        NSData *responseData=[NSURLConnection sendSynchronousRequest:req returningResponse:&res error:&err];
        if(!err)
        {
            NSError *jsonParsingError = nil;
            NSDictionary *leadResponseDict = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&jsonParsingError];
            NSLog(@"leadResponseDict : %@", leadResponseDict);
            
            NSMutableDictionary *leadDetailsDict=[[NSMutableDictionary alloc]init];
            
            if([[leadResponseDict allKeys] containsObject:RECORDS_PARAMETER])
            {
                NSArray *recordsArray=[leadResponseDict objectForKey:RECORDS_PARAMETER];
                for(id item in recordsArray)
                {
                    if([item isKindOfClass:[NSDictionary class]])
                    {
                        
                        if ([[item allKeys] containsObject:ANNUAL_REVENUE_PARAMETER]) {
                            
                            [leadDetailsDict setObject:[Utils checkForNull: [item objectForKey:ANNUAL_REVENUE_PARAMETER]] forKey:ANNUAL_REVENUE_PARAMETER];
                        }
                        
                        if ([[item allKeys] containsObject:FIRST_NAME_PARAMETER]) {
                            
                            [leadDetailsDict setObject:[Utils checkForNull: [item objectForKey:FIRST_NAME_PARAMETER]] forKey:FIRST_NAME_PARAMETER];
                        }
                        
                        if ([[item allKeys] containsObject:LAST_NAME_PARAMTER]) {
                            
                            [leadDetailsDict setObject:[Utils checkForNull: [item objectForKey:LAST_NAME_PARAMTER]] forKey:LAST_NAME_PARAMTER];
                        }
                        
                        if ([[item allKeys] containsObject:ZOHO_CITY_PARAMETER]) {
                            
                            [leadDetailsDict setObject:[Utils checkForNull: [item objectForKey:ZOHO_CITY_PARAMETER]] forKey:ZOHO_CITY_PARAMETER];
                        }
                        
                        if ([[item allKeys] containsObject:ZOHO_COMPANY_PARAMETER]) {
                            
                            [leadDetailsDict setObject:[Utils checkForNull: [item objectForKey:ZOHO_COMPANY_PARAMETER]] forKey:ZOHO_COMPANY_PARAMETER];
                        }
                        
                        if ([[item allKeys] containsObject:ZOHO_COUNTRY_PARAMETER]) {
                            
                            [leadDetailsDict setObject:[Utils checkForNull: [item objectForKey:ZOHO_COUNTRY_PARAMETER]] forKey:ZOHO_COUNTRY_PARAMETER];
                        }
                        
                        if ([[item allKeys] containsObject:ZOHO_DESCRIPTION_PARAMETER]) {
                            
                            [leadDetailsDict setObject:[Utils checkForNull: [item objectForKey:ZOHO_DESCRIPTION_PARAMETER]] forKey:ZOHO_DESCRIPTION_PARAMETER];
                        }
                        
                        if ([[item allKeys] containsObject:ZOHO_EMAIL_PARAMETER]) {
                            
                            [leadDetailsDict setObject:[Utils checkForNull: [item objectForKey:ZOHO_EMAIL_PARAMETER]] forKey:ZOHO_EMAIL_PARAMETER];
                        }
                        
                        
                        if ([[item allKeys] containsObject:ZOHO_FAX_PARAMETER]) {
                            
                            [leadDetailsDict setObject:[Utils checkForNull: [item objectForKey:ZOHO_FAX_PARAMETER] ]forKey:ZOHO_FAX_PARAMETER];
                        }
                        
                        
                        if ([[item allKeys] containsObject:ID_PARAMTER]) {
                            
                            [leadDetailsDict setObject:[Utils checkForNull: [item objectForKey:ID_PARAMTER]] forKey:ID_PARAMTER];
                        }
                        
                        if ([[item allKeys] containsObject:ZOHO_INDUSTRY_PARAMETER]) {
                            
                            [leadDetailsDict setObject:[Utils checkForNull: [item objectForKey:ZOHO_INDUSTRY_PARAMETER] ]forKey:ZOHO_INDUSTRY_PARAMETER];
                        }
                        
                        if ([[item allKeys] containsObject:LEAD_SOURCE_PARAMETER]) {
                            
                            [leadDetailsDict setObject:[Utils checkForNull: [item objectForKey:LEAD_SOURCE_PARAMETER]] forKey:LEAD_SOURCE_PARAMETER];
                        }
                        
                        if ([[item allKeys] containsObject:MOBILE_PHONE_PARAMETER]) {
                            
                            [leadDetailsDict setObject:[Utils checkForNull: [item objectForKey:MOBILE_PHONE_PARAMETER]] forKey:MOBILE_PHONE_PARAMETER];
                        }
                        
                        
                        if ([[item allKeys] containsObject:NUMBER_OF_EMPLOYEES]) {
                            
                            [leadDetailsDict setObject:[Utils checkForNull: [item objectForKey:NUMBER_OF_EMPLOYEES]] forKey:NUMBER_OF_EMPLOYEES];
                        }
                        
                        if ([[item allKeys] containsObject:ZOHO_PHONE_PARAMETER]) {
                            
                            [leadDetailsDict setObject:[Utils checkForNull: [item objectForKey:ZOHO_PHONE_PARAMETER]] forKey:ZOHO_PHONE_PARAMETER];
                        }
                        
                        if ([[item allKeys] containsObject:POSTAL_CODE_PARAMETER]) {
                            
                            [leadDetailsDict setObject:[Utils checkForNull: [item objectForKey:POSTAL_CODE_PARAMETER]] forKey:POSTAL_CODE_PARAMETER];
                        }
                        
                        if ([[item allKeys] containsObject:ZOHO_RATING_PARAMETER]) {
                            
                            [leadDetailsDict setObject:[Utils checkForNull: [item objectForKey:ZOHO_RATING_PARAMETER]] forKey:ZOHO_RATING_PARAMETER];
                        }
                        
                        if ([[item allKeys] containsObject:ZOHO_SALUTATION_PARAMETER]) {
                            
                            [leadDetailsDict setObject:[Utils checkForNull: [item objectForKey:ZOHO_SALUTATION_PARAMETER]] forKey:ZOHO_SALUTATION_PARAMETER];
                        }
                        
                        if ([[item allKeys] containsObject:ZOHO_STATE_PARAMETER]) {
                            
                            [leadDetailsDict setObject:[Utils checkForNull: [item objectForKey:ZOHO_STATE_PARAMETER]] forKey:ZOHO_STATE_PARAMETER];
                        }
                        
                        if ([[item allKeys] containsObject:STATUS_PARAMETER]) {
                            
                            [leadDetailsDict setObject:[Utils checkForNull: [item objectForKey:STATUS_PARAMETER]] forKey:STATUS_PARAMETER];
                        }
                        
                        if ([[item allKeys] containsObject:ZOHO_STREET_PARAMETER]) {
                            
                            [leadDetailsDict setObject:[Utils checkForNull: [item objectForKey:ZOHO_STREET_PARAMETER]] forKey:ZOHO_STREET_PARAMETER];
                        }
                        
                        if ([[item allKeys] containsObject:TITLE_PARAMETER]) {
                            
                            [leadDetailsDict setObject:[Utils checkForNull: [item objectForKey:TITLE_PARAMETER]] forKey:TITLE_PARAMETER];
                        }
                        
                        [CoreDataHelper insertLeadsToStore:leadDetailsDict];
                        
                    }
                }
            }
        }
        
        else
        {
            [self refreshoAuthToken];
        }
    }
}

- (BOOL)editLeadWithLeadID:(NSString *)leadID andDetails:(NSMutableDictionary *)details
{
    if(!SAppDelegateObject.postedTokenExpiredNotification)
    {
        
        NSString *urlString=[[NSString stringWithFormat:@"%@%@",EDIT_LEAD_CALL,leadID]stringByAddingPercentEscapesUsingEncoding:NSStringEncodingConversionExternalRepresentation];
        
        NSLog(@"url: %@",urlString);
        
        NSURL *urlActivities =[NSURL URLWithString: urlString];
        
        NSMutableURLRequest *req=[[NSMutableURLRequest alloc]initWithURL:urlActivities];
        [req setHTTPMethod:@"PATCH"];
        [req setValue:[NSString stringWithFormat:@"OAuth %@", self.oAuthToken]  forHTTPHeaderField:@"Authorization"];
        
        NSError *err;
        
        NSMutableDictionary *leadPostDict=[[NSMutableDictionary alloc]init];
        
        //Translating input dictionary from VC to SalesForce Parameters.
        
        for (id key in [details allKeys]) {
            
            if([key isEqualToString:ZOHO_FIRST_NAME_PARAMETER])
            {
                [leadPostDict setObject:[details objectForKey:key] forKey:FIRST_NAME_PARAMETER];
            }
            
            else if([key isEqualToString:ZOHO_LAST_NAME_PARAMETER])
            {
                [leadPostDict setObject:[details objectForKey:key] forKey:LAST_NAME_PARAMTER];
            }
            
            else if([key isEqualToString:ZOHO_CITY_PARAMETER])
            {
                [leadPostDict setObject:[details objectForKey:key] forKey:ZOHO_CITY_PARAMETER];
            }
            else if([key isEqualToString:ZOHO_STATE_PARAMETER])
            {
                [leadPostDict setObject:[details objectForKey:key] forKey:ZOHO_STATE_PARAMETER];
            }
            else if([key isEqualToString:ZOHO_COUNTRY_PARAMETER])
            {
                [leadPostDict setObject:[details objectForKey:key] forKey:ZOHO_COUNTRY_PARAMETER];
            }
            else if([key isEqualToString:ZOHO_STREET_PARAMETER])
            {
                [leadPostDict setObject:[details objectForKey:key] forKey:ZOHO_STREET_PARAMETER];
            }
            else if([key isEqualToString:ZOHO_ZIP_CODE_PARAMETER])
            {
                [leadPostDict setObject:[details objectForKey:key] forKey:POSTAL_CODE_PARAMETER];
            }
            else if([key isEqualToString:ZOHO_DEPARTMENT_PARAMETER])
            {
                [leadPostDict setObject:[details objectForKey:key] forKey:ZOHO_DEPARTMENT_PARAMETER];
            }
            else if([key isEqualToString:ZOHO_EMAIL_PARAMETER])
            {
                [leadPostDict setObject:[details objectForKey:key] forKey:ZOHO_EMAIL_PARAMETER];
            }
            else if([key isEqualToString:ZOHO_PHONE_PARAMETER])
            {
                [leadPostDict setObject:[details objectForKey:key] forKey:ZOHO_PHONE_PARAMETER];
            }
            else if([key isEqualToString:ANNUAL_REVENUE_PARAMETER]) {
                
                [leadPostDict setObject:[details objectForKey:key] forKey:ANNUAL_REVENUE_PARAMETER];
            }
            else if([key isEqualToString:ZOHO_DESCRIPTION_PARAMETER]) {
                
                [leadPostDict setObject:[details objectForKey:key] forKey:ZOHO_DESCRIPTION_PARAMETER];
            }
            else if([key isEqualToString:ZOHO_COMPANY_PARAMETER]) {
                
                [leadPostDict setObject:[details objectForKey:key] forKey:ZOHO_COMPANY_PARAMETER];
            }
            
            else if([key isEqualToString:ZOHO_LEAD_SOURCE_PARAMETER]) {
                
                [leadPostDict setObject:[details objectForKey:key] forKey:LEAD_SOURCE_PARAMETER];
            }
            
            else if([key isEqualToString:NUMBER_OF_EMPLOYEES]) {
                
                [leadPostDict setObject:[details objectForKey:key] forKey:NUMBER_OF_EMPLOYEES];
            }
            else if([key isEqualToString:ZOHO_RATING_PARAMETER]) {
                
                [leadPostDict setObject:[details objectForKey:key] forKey:ZOHO_RATING_PARAMETER];
            }
            
            else if([key isEqualToString:ZOHO_LEAD_STATUS_PARAMETER]) {
                
                [leadPostDict setObject:[details objectForKey:key] forKey:STATUS_PARAMETER];
            }
            else if([key isEqualToString:TITLE_PARAMETER]) {
                
                [leadPostDict setObject:[details objectForKey:key] forKey:TITLE_PARAMETER];
            }
            else if([key isEqualToString:ZOHO_DESCRIPTION_PARAMETER]) {
                
                [leadPostDict setObject: [details objectForKey:ZOHO_DESCRIPTION_PARAMETER] forKey:ZOHO_DESCRIPTION_PARAMETER];
            }
            else if([key isEqualToString:ZOHO_DESIGNATION_PARAMETER]) {
                
                [leadPostDict setObject:[details objectForKey:ZOHO_DESIGNATION_PARAMETER] forKey:TITLE_PARAMETER];
            }
            
        }
        
        NSData *postData=[NSJSONSerialization dataWithJSONObject:leadPostDict options:NSJSONWritingPrettyPrinted error:&err];
        
        NSString* postString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSURLResponse *res = [[NSURLResponse alloc]init];
        
        [req setValue:JSON_CONTENT_TYPE_PARAMETER forHTTPHeaderField:CONTENT_TYPE_PARAMETER];
        [req setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES]];
        
        NSData *responseData=[NSURLConnection sendSynchronousRequest:req returningResponse:&res error:&err];
        [self fetchLeadDetailsForLeadID:leadID];
        //remove return and handle response.
        
        return YES;
        
        if(!err)
        {
            NSError *jsonParsingError = nil;
            NSDictionary *contactResponseDict = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&jsonParsingError];
            NSLog(@"contactResponseDict : %@", contactResponseDict);
            
            if([contactResponseDict isKindOfClass:[NSDictionary class]])
                if([[contactResponseDict allKeys] containsObject:SUCCESS_PARAMETER])
                {
                    if([[contactResponseDict objectForKey:SUCCESS_PARAMETER] boolValue])
                        return YES;
                }
        }
        
        else
        {
            [self refreshoAuthToken];
        }
    }
    
    return NO;
}

- (BOOL)addLeadWithDetails:(NSMutableDictionary *)leadInfo
{
    if(!SAppDelegateObject.postedTokenExpiredNotification)
    {
        NSString *urlString=[ADD_LEADS_CALL stringByAddingPercentEscapesUsingEncoding:NSStringEncodingConversionExternalRepresentation];
        
        NSLog(@"url: %@",urlString);
        
        NSURL *urlActivities =[NSURL URLWithString: urlString];
        
        NSMutableURLRequest *req=[[NSMutableURLRequest alloc]initWithURL:urlActivities];
        [req setHTTPMethod:@"POST"];
        [req setValue:[NSString stringWithFormat:@"OAuth %@", self.oAuthToken]  forHTTPHeaderField:@"Authorization"];
        
        NSError *err;
        
        NSMutableDictionary *leadPostDict=[[NSMutableDictionary alloc]init];
        
        //Translating input dictionary from VC to SalesForce Parameters.
        
        for (id key in [leadInfo allKeys]) {
            
            if([key isEqualToString:ZOHO_FIRST_NAME_PARAMETER])
            {
                [leadPostDict setObject:[leadInfo objectForKey:key] forKey:FIRST_NAME_PARAMETER];
            }
            
            else if([key isEqualToString:ZOHO_LAST_NAME_PARAMETER])
            {
                [leadPostDict setObject:[leadInfo objectForKey:key] forKey:LAST_NAME_PARAMTER];
            }
            
            else if([key isEqualToString:ZOHO_CITY_PARAMETER])
            {
                [leadPostDict setObject:[leadInfo objectForKey:key] forKey:ZOHO_CITY_PARAMETER];
            }
            else if([key isEqualToString:ZOHO_STATE_PARAMETER])
            {
                [leadPostDict setObject:[leadInfo objectForKey:key] forKey:ZOHO_STATE_PARAMETER];
            }
            else if([key isEqualToString:ZOHO_COUNTRY_PARAMETER])
            {
                [leadPostDict setObject:[leadInfo objectForKey:key] forKey:ZOHO_COUNTRY_PARAMETER];
            }
            else if([key isEqualToString:ZOHO_STREET_PARAMETER])
            {
                [leadPostDict setObject:[leadInfo objectForKey:key] forKey:ZOHO_STREET_PARAMETER];
            }
            else if([key isEqualToString:ZOHO_ZIP_CODE_PARAMETER])
            {
                [leadPostDict setObject:[leadInfo objectForKey:key] forKey:POSTAL_CODE_PARAMETER];
            }
            else if([key isEqualToString:ZOHO_DEPARTMENT_PARAMETER])
            {
                [leadPostDict setObject:[leadInfo objectForKey:key] forKey:ZOHO_DEPARTMENT_PARAMETER];
            }
            else if([key isEqualToString:ZOHO_EMAIL_PARAMETER])
            {
                [leadPostDict setObject:[leadInfo objectForKey:key] forKey:ZOHO_EMAIL_PARAMETER];
            }
            else if([key isEqualToString:ZOHO_PHONE_PARAMETER])
            {
                [leadPostDict setObject:[leadInfo objectForKey:key] forKey:ZOHO_PHONE_PARAMETER];
            }
            else if([key isEqualToString:ANNUAL_REVENUE_PARAMETER]) {
                
                [leadPostDict setObject:[leadInfo objectForKey:key] forKey:ANNUAL_REVENUE_PARAMETER];
            }
            else if([key isEqualToString:ZOHO_DESCRIPTION_PARAMETER]) {
                
                [leadPostDict setObject:[leadInfo objectForKey:key] forKey:ZOHO_DESCRIPTION_PARAMETER];
            }
            else if([key isEqualToString:ZOHO_COMPANY_PARAMETER]) {
                
                [leadPostDict setObject:[leadInfo objectForKey:key] forKey:ZOHO_COMPANY_PARAMETER];
            }
            
            else if([key isEqualToString:ZOHO_LEAD_SOURCE_PARAMETER]) {
                
                [leadPostDict setObject:[leadInfo objectForKey:key] forKey:LEAD_SOURCE_PARAMETER];
            }
            
            else if([key isEqualToString:NUMBER_OF_EMPLOYEES]) {
                
                [leadPostDict setObject:[leadInfo objectForKey:key] forKey:NUMBER_OF_EMPLOYEES];
            }
            else if([key isEqualToString:ZOHO_RATING_PARAMETER]) {
                
                [leadPostDict setObject:[leadInfo objectForKey:key] forKey:ZOHO_RATING_PARAMETER];
            }
            
            else if([key isEqualToString:ZOHO_LEAD_STATUS_PARAMETER]) {
                
                [leadPostDict setObject:[leadInfo objectForKey:key] forKey:STATUS_PARAMETER];
            }
            else if([key isEqualToString:TITLE_PARAMETER]) {
                
                [leadPostDict setObject:[leadInfo objectForKey:key] forKey:TITLE_PARAMETER];
            }
            else if([key isEqualToString:ZOHO_DESCRIPTION_PARAMETER]) {
                
                [leadPostDict setObject: [leadInfo objectForKey:ZOHO_DESCRIPTION_PARAMETER] forKey:ZOHO_DESCRIPTION_PARAMETER];
            }
            else if([key isEqualToString:ZOHO_DESIGNATION_PARAMETER]) {
                
                [leadPostDict setObject:[leadInfo objectForKey:ZOHO_DESIGNATION_PARAMETER] forKey:TITLE_PARAMETER];
            }
            
            
        }
        
        NSData *postData=[NSJSONSerialization dataWithJSONObject:leadPostDict options:NSJSONWritingPrettyPrinted error:&err];
        
        NSString* postString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSURLResponse *res = [[NSURLResponse alloc]init];
        
        [req setValue:JSON_CONTENT_TYPE_PARAMETER forHTTPHeaderField:CONTENT_TYPE_PARAMETER];
        [req setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES]];
        
        NSData *responseData=[NSURLConnection sendSynchronousRequest:req returningResponse:&res error:&err];
        
        if(!err)
        {
            NSError *jsonParsingError = nil;
            NSDictionary *contactResponseDict = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&jsonParsingError];
            NSLog(@"contactResponseDict : %@", contactResponseDict);
            
            if([[contactResponseDict allKeys] containsObject:SUCCESS_PARAMETER])
            {
                if([[contactResponseDict objectForKey:SUCCESS_PARAMETER] boolValue])
                    [self fetchLeadDetailsForLeadID:[contactResponseDict objectForKey:@"id"]];
                return YES;
            }
        }
        
        else
        {
            [self refreshoAuthToken];
        }
    }
    
    return NO;
}





- (void)fetchOpportunitiesForID:(NSString *)recordID
{
    if(!SAppDelegateObject.postedTokenExpiredNotification)
    {
        NSString *urlString=[[NSString stringWithFormat:@"%@ where AccountId='%@'",OPPORTUNITY_CALL,recordID]  stringByAddingPercentEscapesUsingEncoding:NSStringEncodingConversionExternalRepresentation];
        
        NSLog(@"url: %@",urlString);
        
        NSURL *urlActivities =[NSURL URLWithString: urlString];
        
        NSMutableURLRequest *req=[[NSMutableURLRequest alloc]initWithURL:urlActivities];
        [req setHTTPMethod:@"GET"];
        [req setValue:[NSString stringWithFormat:@"OAuth %@", self.oAuthToken]  forHTTPHeaderField:@"Authorization"];
        
        NSURLResponse *res = [[NSURLResponse alloc]init];
        NSError *err;
        
        NSData *responseData=[NSURLConnection sendSynchronousRequest:req returningResponse:&res error:&err];
        if(!err)
        {
            NSError *jsonParsingError = nil;
            NSDictionary *oppResponseDict = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&jsonParsingError];
            NSLog(@"leadResponseDict : %@", oppResponseDict);
            
            NSMutableDictionary *oppDetailsDict=[[NSMutableDictionary alloc]init];
            
            
            if([oppResponseDict isKindOfClass:[NSDictionary class]])
            {
                if([[oppResponseDict allKeys] containsObject:RECORDS_PARAMETER])
                {
                    NSArray *recordsArray=[oppResponseDict objectForKey:RECORDS_PARAMETER];
                    for(id item in recordsArray)
                    {
                        if([item isKindOfClass:[NSDictionary class]])
                        {
                            
                            if ([[item allKeys] containsObject:ACCOUNT_ID_PARAMTER]) {
                                
                                [oppDetailsDict setObject:[Utils checkForNull: [item objectForKey:ACCOUNT_ID_PARAMTER]] forKey:ACCOUNT_ID_PARAMTER];
                            }
                            
                            if ([[item allKeys] containsObject:ZOHO_AMOUNT_PARAMETER]) {
                                
                                [oppDetailsDict setObject:[Utils checkForNull: [item objectForKey:ZOHO_AMOUNT_PARAMETER]] forKey:ZOHO_AMOUNT_PARAMETER];
                            }
                            
                            if ([[item allKeys] containsObject:CLOSE_DATE_PARAMETER]) {
                                
                                [oppDetailsDict setObject:[Utils checkForNull: [item objectForKey:CLOSE_DATE_PARAMETER]] forKey:CLOSE_DATE_PARAMETER];
                            }
                            
                            if ([[item allKeys] containsObject:ZOHO_DESCRIPTION_PARAMETER]) {
                                
                                [oppDetailsDict setObject:[Utils checkForNull: [item objectForKey:ZOHO_DESCRIPTION_PARAMETER]] forKey:ZOHO_DESCRIPTION_PARAMETER];
                            }
                            
                            if ([[item allKeys] containsObject:EXPECTED_REVENUE_PARAMETER]) {
                                
                                [oppDetailsDict setObject:[Utils checkForNull: [item objectForKey:EXPECTED_REVENUE_PARAMETER]] forKey:EXPECTED_REVENUE_PARAMETER];
                            }
                            
                            if ([[item allKeys] containsObject:ID_PARAMTER]) {
                                
                                [oppDetailsDict setObject:[Utils checkForNull: [item objectForKey:ID_PARAMTER]] forKey:ID_PARAMTER];
                            }
                            
                            if ([[item allKeys] containsObject:IS_CLOSED_PARAMETER]) {
                                
                                [oppDetailsDict setObject:[Utils checkForNull: [item objectForKey:IS_CLOSED_PARAMETER]] forKey:IS_CLOSED_PARAMETER];
                            }
                            
                            if ([[item allKeys] containsObject:IS_DELETED_PARAMETER]) {
                                
                                [oppDetailsDict setObject:[Utils checkForNull: [item objectForKey:IS_DELETED_PARAMETER]] forKey:IS_DELETED_PARAMETER];
                            }
                            
                            if ([[item allKeys] containsObject:IS_PRIVATE_PARAEMETER]) {
                                
                                [oppDetailsDict setObject:[Utils checkForNull: [item objectForKey:IS_PRIVATE_PARAEMETER]] forKey:IS_PRIVATE_PARAEMETER];
                            }
                            
                            
                            if ([[item allKeys] containsObject:IS_WON_PARAMETER]) {
                                
                                [oppDetailsDict setObject:[Utils checkForNull: [item objectForKey:IS_WON_PARAMETER]] forKey:IS_WON_PARAMETER];
                            }
                            
                            
                            
                            if ([[item allKeys] containsObject:NAME_PARAMETER]) {
                                
                                [oppDetailsDict setObject:[Utils checkForNull: [item objectForKey:NAME_PARAMETER]] forKey:NAME_PARAMETER];
                            }
                            
                            
                            
                            if ([[item allKeys] containsObject:NEXT_STEP_PARAMETER]) {
                                
                                [oppDetailsDict setObject:[Utils checkForNull: [item objectForKey:NEXT_STEP_PARAMETER]] forKey:NEXT_STEP_PARAMETER];
                            }
                            
                            
                            
                            if ([[item allKeys] containsObject:ZOHO_TYPE_PARAMETER]) {
                                
                                [oppDetailsDict setObject:[Utils checkForNull: [item objectForKey:ZOHO_TYPE_PARAMETER]] forKey:ZOHO_TYPE_PARAMETER];
                            }
                            
                            
                            if ([[item allKeys] containsObject:ZOHO_PROBABILITY_PARAMETER]) {
                                
                                [oppDetailsDict setObject:[Utils checkForNull: [item objectForKey:ZOHO_PROBABILITY_PARAMETER]] forKey:ZOHO_PROBABILITY_PARAMETER];
                            }
                            
                            
                            if ([[item allKeys] containsObject:STAGE_NAME_PARAMETER]) {
                                
                                [oppDetailsDict setObject:[Utils checkForNull: [item objectForKey:STAGE_NAME_PARAMETER]] forKey:STAGE_NAME_PARAMETER];
                            }
                            
                            
                            [CoreDataHelper insertOpportunitiesToStore:oppDetailsDict];
                            SAppDelegateObject.opportunitiesForAccounts=oppDetailsDict;
                           // NSLog(@"%@",oppDetailsDict);
                        }
                    }
                }
            }
        }
        
        else
        {
            [self refreshoAuthToken];
        }
    }
}

- (BOOL)addOpportunitiesForModule:(ModuleType)type withDetails:(NSMutableDictionary *)details
{
    if(!SAppDelegateObject.postedTokenExpiredNotification)
    {
        
        if([[details allKeys] containsObject:ID_PARAMTER])
        {
            NSString *urlString=[ADD_OPPORTUNITY_CALL stringByAddingPercentEscapesUsingEncoding:NSStringEncodingConversionExternalRepresentation];
            
            NSLog(@"url: %@",urlString);
            
            NSURL *urlActivities =[NSURL URLWithString: urlString];
            
            NSMutableURLRequest *req=[[NSMutableURLRequest alloc]initWithURL:urlActivities];
            [req setHTTPMethod:@"POST"];
            [req setValue:[NSString stringWithFormat:@"OAuth %@", self.oAuthToken]  forHTTPHeaderField:@"Authorization"];
            
            NSURLResponse *res = [[NSURLResponse alloc]init];
            NSError *err;
            
            NSMutableDictionary *activityPostDict=[[NSMutableDictionary alloc]init];
            
            for (id key in [details allKeys]) {
                
                
                
                if([key isEqualToString:NAME_PARAMETER])
                {
                    [activityPostDict setObject:[details objectForKey:key] forKey:NAME_PARAMETER];
                }
                
                else if([key isEqualToString:ZOHO_AMOUNT_PARAMETER])
                {
                    [activityPostDict setObject:[details objectForKey:key] forKey:ZOHO_AMOUNT_PARAMETER];
                }
                
                else if([key isEqualToString:CLOSE_DATE_PARAMETER])
                {
                    [activityPostDict setObject:[details objectForKey:key] forKey:CLOSE_DATE_PARAMETER];
                }
                
                else if([key isEqualToString:ZOHO_DESCRIPTION_PARAMETER])
                {
                    [activityPostDict setObject:[details objectForKey:key] forKey:ZOHO_DESCRIPTION_PARAMETER];
                }
                
                else if([key isEqualToString:EXPECTED_REVENUE_PARAMETER])
                {
                    [activityPostDict setObject:[details objectForKey:key] forKey:EXPECTED_REVENUE_PARAMETER];
                }
                
                else if([key isEqualToString:NEXT_STEP_PARAMETER])
                {
                    [activityPostDict setObject:[details objectForKey:key] forKey:NEXT_STEP_PARAMETER];
                }
                
                else if([key isEqualToString:ZOHO_TYPE_PARAMETER])
                {
                    [activityPostDict setObject:[details objectForKey:key] forKey:ZOHO_TYPE_PARAMETER];
                }
                
                else if([key isEqualToString:ZOHO_PROBABILITY_PARAMETER])
                {
                    [activityPostDict setObject:[details objectForKey:key] forKey:ZOHO_PROBABILITY_PARAMETER];
                }
                
                else if([key isEqualToString:STAGE_NAME_PARAMETER])
                {
                    [activityPostDict setObject:[details objectForKey:key] forKey:STAGE_NAME_PARAMETER];
                }
                
                
            }
            
            switch (type) {
                    
                case CustomerModule:
                    [activityPostDict setObject:[details objectForKey:ID_PARAMTER] forKey:WHO_ID_PARAMETER];
                    break;
                    
                case AccountsModule:
                    [activityPostDict setObject:[details objectForKey:ID_PARAMTER] forKey:WHAT_ID_PARAMETER];
                    break;
                    
                case OpportunitiesModule:
                    [activityPostDict setObject:[details objectForKey:ID_PARAMTER] forKey:WHAT_ID_PARAMETER];
                    break;
                    
                case LeadModule:
                    [activityPostDict setObject:[details objectForKey:ID_PARAMTER] forKey:WHAT_ID_PARAMETER];
                    
                default:
                    break;
            }
            
            [activityPostDict setObject:[NSString stringWithFormat:@"%d",[SNSDateUtils getDiffernceInMinutesForDate:[details objectForKey:ZOHO_END_TIME_PARAMETER] andAnotherDate:[details objectForKey:ZOHO_START_TIME_PARAMETER] ]] forKey:DURATION_IN_MINUTES_PARAMETER];
            
            NSData *postData=[NSJSONSerialization dataWithJSONObject:activityPostDict options:NSJSONWritingPrettyPrinted error:&err];
            
            NSString* postString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
            
            [req setValue:JSON_CONTENT_TYPE_PARAMETER forHTTPHeaderField:CONTENT_TYPE_PARAMETER];
            [req setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES]];
            
            NSData *responseData=[NSURLConnection sendSynchronousRequest:req returningResponse:&res error:&err];
            
            if(!err)
            {
                NSError *jsonParsingError = nil;
                NSDictionary *addActivityResponseDict = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&jsonParsingError];
                NSLog(@"addActivityResponseDict : %@", addActivityResponseDict);
                
                if([addActivityResponseDict isKindOfClass:[NSDictionary class]])
                {
                    if([[addActivityResponseDict allKeys] containsObject:SUCCESS_PARAMETER])
                    {
                        if([[addActivityResponseDict objectForKey:SUCCESS_PARAMETER] boolValue])
                        {
                            [self fetchActivityDetailsForActivityID:[addActivityResponseDict objectForKey:@"id"]];
                            return YES;
                        }
                    }
                }
            }
            
            else
            {
                [self refreshoAuthToken];
            }
        }
    }
    
    return NO;
}


#pragma mark Note Methods

- (void)fetchNotesForParentID:(NSString *)parentID
{
    if(!SAppDelegateObject.postedTokenExpiredNotification)
    {
        NSString *urlString=[[NSString stringWithFormat:@"%@ where ParentId='%@'",NOTES_CALL,parentID]  stringByAddingPercentEscapesUsingEncoding:NSStringEncodingConversionExternalRepresentation];
        
        NSLog(@"url: %@",urlString);
        
        NSURL *urlActivities =[NSURL URLWithString: urlString];
        
        NSMutableURLRequest *req=[[NSMutableURLRequest alloc]initWithURL:urlActivities];
        [req setHTTPMethod:@"GET"];
        [req setValue:[NSString stringWithFormat:@"OAuth %@", self.oAuthToken]  forHTTPHeaderField:@"Authorization"];
        
        NSURLResponse *res = [[NSURLResponse alloc]init];
        NSError *err;
        
        NSData *responseData=[NSURLConnection sendSynchronousRequest:req returningResponse:&res error:&err];
        if(!err)
        {
            NSError *jsonParsingError = nil;
            NSDictionary *notesResponseDict = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&jsonParsingError];
            NSLog(@"notesResponseDict : %@", notesResponseDict);
            
            NSMutableDictionary *notesDetailsDict=[[NSMutableDictionary alloc]init];
            if([notesResponseDict isKindOfClass:[NSDictionary class]])
            {
                if([[notesResponseDict allKeys] containsObject:RECORDS_PARAMETER])
                {
                    NSArray *recordsArray=[notesResponseDict objectForKey:RECORDS_PARAMETER];
                    for(id item in recordsArray)
                    {
                        if([item isKindOfClass:[NSDictionary class]])
                        {
                            if ([[item allKeys] containsObject:ID_PARAMTER]) {
                                
                                [notesDetailsDict setObject:[Utils checkForNull: [item objectForKey:ID_PARAMTER]] forKey:ID_PARAMTER];
                            }
                            
                            
                            
                            if ([[item allKeys] containsObject:TITLE_PARAMETER]) {
                                
                                [notesDetailsDict setObject:[Utils checkForNull: [item objectForKey:TITLE_PARAMETER]] forKey:TITLE_PARAMETER];
                            }
                            
                            
                            if ([[item allKeys] containsObject:BODY_PARAMETER]) {
                                
                                [notesDetailsDict setObject:[Utils checkForNull: [item objectForKey:BODY_PARAMETER]] forKey:BODY_PARAMETER];
                            }
                            
                            
                            if ([[item allKeys] containsObject:PARENT_ID_PARAMETER]) {
                                
                                [notesDetailsDict setObject:[Utils checkForNull: [item objectForKey:PARENT_ID_PARAMETER]] forKey:PARENT_ID_PARAMETER];
                            }
                            
                            [CoreDataHelper insertNotesToStore:notesDetailsDict withStatus:YES];
                        }
                    }
                }
            }
            
        }
        
        else
        {
            [self refreshoAuthToken];
        }
    }
    
}
- (void)refreshoAuthToken
{
    //5Aep8617VFpoP.M.4s7ZNMWQagaxaAjbS62QN1DZ7WjVj1NBYtrvbhKYcT42zSRZmo4DigWCug7Iw==
    //00D90000000lUUl!AREAQAT0yIzyJq5lF4dyjrF9p.f5iM5u2dXfePyNaHZ9SAQU9_6kkyPN67n_1oQIwvJA3ST.5Gmkd2hldXYZBU3dDOdLfrgN
    NSError *authTokenErr;
    
    NSString *oAuthRefreshToken=[SFHFKeychainUtils getPasswordForUsername:OAUTH_REFRESH_TOKEN andServiceName:SERVICE_NAME error:&authTokenErr];
    
    if (oAuthRefreshToken)
        
    {
        NSString *urlString=[[REFRESH_TOKEN_CALl stringByAppendingString:oAuthRefreshToken ] stringByAddingPercentEscapesUsingEncoding:NSStringEncodingConversionExternalRepresentation];
        
        NSLog(@"url: %@",urlString);
        
        NSURL *urlActivities =[NSURL URLWithString: urlString];
        
        NSMutableURLRequest *req=[[NSMutableURLRequest alloc]initWithURL:urlActivities];
        NSURLResponse *res = [[NSURLResponse alloc]init];
        NSError *err;
        
        NSData *responseData=[NSURLConnection sendSynchronousRequest:req returningResponse:&res error:&err];
        if(!err)
        {
            NSError *jsonParsingError = nil;
            NSDictionary *eventsResponseDict = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&jsonParsingError];
            NSLog(@"responseActivities : %@", eventsResponseDict);
            if([[eventsResponseDict allKeys] containsObject:AUTH_TOKEN_PARAMETER])
            {
                if([SFHFKeychainUtils storeUsername:OAUTH_TOKEN andPassword:[eventsResponseDict objectForKey:AUTH_TOKEN_PARAMETER] forServiceName:SERVICE_NAME updateExisting:YES error:&authTokenErr])
                    NSLog(@"Stored auth token to keychain successfully");
                
                else
                    NSLog(@"error: %@",[authTokenErr localizedDescription]);
            }
            
            else if([[eventsResponseDict allKeys] containsObject:ERROR_DESCRIPTION_PARAMETER])
            {
                if([[eventsResponseDict allKeys] containsObject:ERROR_DESCRIPTION_PARAMETER])
                {
                    if(!SAppDelegateObject.postedTokenExpiredNotification)
                    {
                        [[NSNotificationCenter defaultCenter]postNotificationName:TOKEN_EXPIRED_NOTIFICATION object:nil];
                        SAppDelegateObject.postedTokenExpiredNotification=YES;
                    }
                }
            }
        }
        
        
    }
}

- (void)getInnerURLStuff:(NSDictionary *)item
{
    if ([[[item objectForKey:ATTRIBUTES_PARAMTER] allKeys] containsObject:URL_PARAMTER]) {
        
        
        NSString *urlString=[[NSString stringWithFormat:@"%@%@", SALESFORCE_BASE_URL,[[item objectForKey:ATTRIBUTES_PARAMTER] objectForKey:URL_PARAMTER]]  stringByAddingPercentEscapesUsingEncoding:NSStringEncodingConversionExternalRepresentation];
        
        NSLog(@"url: %@",urlString);
        
        NSURL *urlActivities =[NSURL URLWithString: urlString];
        
        NSMutableURLRequest *req=[[NSMutableURLRequest alloc]initWithURL:urlActivities];
        [req setHTTPMethod:@"GET"];
        [req setValue:[NSString stringWithFormat:@"OAuth %@", self.oAuthToken]  forHTTPHeaderField:@"Authorization"];
        
        NSURLResponse *res = [[NSURLResponse alloc]init];
        NSError *err;
        
        NSData *responseData=[NSURLConnection sendSynchronousRequest:req returningResponse:&res error:&err];
        if(!err)
        {
            NSError *jsonParsingError = nil;
            NSDictionary *eventsResponseDict = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&jsonParsingError];
            NSLog(@"responseActivities : %@", eventsResponseDict);
        }
        
    }
}


#pragma mark CHANGES BY SWARNAVA

//Used to ADD Note

-(NSError *)addNote:(NSMutableDictionary *)noteDic
{
    NSError *error = nil;
    if(!SAppDelegateObject.postedTokenExpiredNotification)
    {
        NSURL *urlActivities =[NSURL URLWithString: OPPORTUNITY_CALL];
        NSString *soapMsg=[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:oppty_note=\"http://blackberry.compass/crm srch\"><soapenv:Header/><soapenv:Body><Oppnotes><EmployeeId>%@</EmployeeId><OpportunityId>%@</OpportunityId><Subject>%@</Subject><NoteType></NoteType><Details>%@</Details></Oppnotes></soapenv:Body></soapenv:Envelope>",[[ModelTrackingClass sharedInstance]userID],[noteDic valueForKey:@"ID"],[noteDic valueForKey:NOTES_TITLE],[noteDic valueForKey:NOTES_CONTENT]];
        NSLog(@"%@",soapMsg);
        
        NSMutableURLRequest *requests = [[NSMutableURLRequest alloc] initWithURL:urlActivities];
        requests.timeoutInterval = 30;
        NSString *msgLength = [NSString stringWithFormat:@"%d",[soapMsg length]];
        
        [requests setValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        [requests setValue:msgLength forHTTPHeaderField:@"Content-Length"];
        [requests setValue:@"CT_BB_OPPNOTES_ADD.VERSION_1" forHTTPHeaderField:@"SOAPAction"];
        [requests setHTTPMethod:@"POST"];
        [requests setHTTPBody:[soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSURLResponse *response;
        
        
        [NSURLConnection sendSynchronousRequest:requests returningResponse:&response error:&error];
        
    }
    
    return error;
}

//Used for Fetching all the existing Accounts

#pragma mark Account Methods

- (NSError *)fetchAccounts:(NSString *)employeeID
{
    NSError *error = nil;
    
    if(!SAppDelegateObject.postedTokenExpiredNotification)
    {
        NSURL *urlActivities =[NSURL URLWithString: OPPORTUNITY_CALL];
        
        NSString *soapMsg=[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:oppty_update=\"http://blackberry.compass/crm srch\"><soapenv:Header/><soapenv:Body><MyAccounts><EmployeeId>%@</EmployeeId></MyAccounts></soapenv:Body></soapenv:Envelope>",employeeID];
        
        NSMutableURLRequest *requests = [[NSMutableURLRequest alloc] initWithURL:urlActivities];
        requests.timeoutInterval = 30;
        NSString *msgLength = [NSString stringWithFormat:@"%d",[soapMsg length]];
        
        [requests setValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        [requests setValue:msgLength forHTTPHeaderField:@"Content-Length"];
        [requests setValue:@"CT_BB_MYACCOUNTS.VERSION_1" forHTTPHeaderField:@"SOAPAction"];
        [requests setHTTPMethod:@"POST"];
        [requests setHTTPBody:[soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSURLResponse *response;
        
        
        NSData   *data = (NSMutableData *) [NSURLConnection sendSynchronousRequest:requests returningResponse:&response error:&error];
        NSString *s = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        NSLog(@"%@",s);
        
        if(!error)
        {
            NSXMLParser *parser = [[NSXMLParser alloc]initWithData:data];
            
            XMLParser *xmlParser = [[XMLParser alloc]initXMLParser];
            xmlParser.ParsingType = Account;
            [parser setDelegate:xmlParser];
            BOOL success = [parser parse];
            
            if(success)
            {
                NSLog(@"No Errors");
                
                acntArray=[[NSMutableArray alloc]initWithArray:xmlParser.resultsArray];
            }
            else
                NSLog(@"Account Error!!!");
        }
        
    }
    
    return error;
}


//Used for Fetching all the existing opportunities

#pragma mark Opportunity Methods

- (NSError *)fetchOpportunities:(NSString *)employeeID
{
    NSError *error = nil;
    
    if(!SAppDelegateObject.postedTokenExpiredNotification)
    {
        NSURL *urlActivities =[NSURL URLWithString: OPPORTUNITY_CALL];
        NSString *soapMsg=[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:myop=\"http://blackberry.compass/MyOppty\"><soapenv:Header/><soapenv:Body><MyOppty><EmployeeId>%@</EmployeeId></MyOppty></soapenv:Body></soapenv:Envelope>",employeeID];
        
        NSLog(@"%@",soapMsg);
        NSMutableURLRequest *requests = [[NSMutableURLRequest alloc] initWithURL:urlActivities];
        requests.timeoutInterval = 30;
        NSString *msgLength = [NSString stringWithFormat:@"%d",[soapMsg length]];
        
        [requests setValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        [requests setValue:msgLength forHTTPHeaderField:@"Content-Length"];
        [requests setValue:@"CT_BB_MYOPPTY.VERSION_1" forHTTPHeaderField:@"SOAPAction"];
        [requests setHTTPMethod:@"POST"];
        [requests setHTTPBody:[soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSURLResponse *response;
        
        NSData   *data = (NSMutableData *) [NSURLConnection sendSynchronousRequest:requests returningResponse:&response error:&error];
        NSString *s = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        NSLog(@"%@",s);
        
        if(!error)
        {
            NSXMLParser *parser = [[NSXMLParser alloc]initWithData:data];
            
            XMLParser *xmlParser = [[XMLParser alloc]initXMLParser];
            xmlParser.ParsingType = Opport;
            [parser setDelegate:xmlParser];
            BOOL success = [parser parse];
            
            if(success)
            {
                opportArray=[[NSMutableArray alloc]initWithArray:xmlParser.resultsArray];
            }
            else
                NSLog(@"Opportunity Error!!!");
        }
        
    }
    return error;
}


//Used for UPDATING an opportunity

-(NSError *)updateOpportunity:(NSMutableDictionary *)oppDic
{
    NSError *error = nil;
    
    if(!SAppDelegateObject.postedTokenExpiredNotification)
    {
        NSURL *urlActivities =[NSURL URLWithString: OPPORTUNITY_CALL];
        
        
        NSString *soapMsg=[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:oppty_update=\"http://blackberry.compass/oppty_update\"><soapenv:Header/><soapenv:Body><OppUpdates><OpportunityId>%@</OpportunityId><OpportunityName>%@</OpportunityName><TCV>%@</TCV><FY>%@</FY><DealDuration>%@</DealDuration><EstCloseDate>%@</EstCloseDate></OppUpdates></soapenv:Body></soapenv:Envelope>",[oppDic valueForKey:@"oppID"],[oppDic valueForKey:@"oppName"],[oppDic valueForKey:@"TVC"],[oppDic valueForKey:@"firstYear"],[oppDic valueForKey:@"Deal"],[oppDic valueForKey:@"closeDate"]];
        
        
        NSLog(@"%@",soapMsg);
        
        NSMutableURLRequest *requests = [[NSMutableURLRequest alloc] initWithURL:urlActivities];
        requests.timeoutInterval = 30;
        NSString *msgLength = [NSString stringWithFormat:@"%d",[soapMsg length]];
        
        [requests setValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        [requests setValue:msgLength forHTTPHeaderField:@"Content-Length"];
        [requests setValue:@"CT_BB_OPPTY_UPDATES.VERSION_1" forHTTPHeaderField:@"SOAPAction"];
        [requests setHTTPMethod:@"POST"];
        [requests setHTTPBody:[soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSURLResponse *response;
        
        
        [NSURLConnection sendSynchronousRequest:requests returningResponse:&response error:&error];
        
    }
    
    return error;
}

//Used for Opportunity Creation

- (NSError *)createOpportunity:(NSMutableDictionary *)oppDic
{
    NSError *error = nil;
    
    if(!SAppDelegateObject.postedTokenExpiredNotification)
    {
        NSURL *urlActivities =[NSURL URLWithString: OPPORTUNITY_CALL];
        
        NSString *soapMsg=[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:sch=\"http://xmlns.oracle.com/Enterprise/Tools/schemas\"><soapenv:Header/><soapenv:Body><OpportunityDetails xmlns=\"http://xmlns.oracle.com/Enterprise/Tools/schemas\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"><CustomerID>%@</CustomerID><OppOwner>%@</OppOwner><OpportunityName>%@</OpportunityName><TCV>%@</TCV><DealType>New</DealType><FirstYear>%@</FirstYear><CloseDate>%@</CloseDate><DealDuration>%@</DealDuration><ConfidencePct></ConfidencePct><SalesStage>Scope and Requirements</SalesStage><Strategic></Strategic><PartnerFlag></PartnerFlag><VerticalOwner></VerticalOwner><RevenueMoM></RevenueMoM><RampupMonths></RampupMonths><BuyingCenter></BuyingCenter><OpportunityType></OpportunityType><ContactDetails><ContactID></ContactID><PrimaryContactFlag></PrimaryContactFlag></ContactDetails><CompetitorDetails><Competitor></Competitor></CompetitorDetails>%@<PartnerDetails><PartnerCompanyID></PartnerCompanyID><PartnerRoleID></PartnerRoleID></PartnerDetails><AccountTeamDetails><TeamPersonID></TeamPersonID><TeamPersonRoleID></TeamPersonRoleID></AccountTeamDetails></OpportunityDetails></soapenv:Body></soapenv:Envelope>",[oppDic valueForKey:@"CustomerID"],[oppDic valueForKey:@"OppOwner"],[oppDic valueForKey:@"OpportunityName"],[oppDic valueForKey:@"TCV"],[oppDic valueForKey:@"firstYear"],[oppDic valueForKey:@"closeDate"],[oppDic valueForKey:@"Deal"],[oppDic valueForKey:@"productXML"]];
        
        NSLog(@"%@",soapMsg);
        
        NSMutableURLRequest *requests = [[NSMutableURLRequest alloc] initWithURL:urlActivities];
        requests.timeoutInterval = 30;
        NSString *msgLength = [NSString stringWithFormat:@"%d",[soapMsg length]];
        
        [requests setValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        [requests setValue:msgLength forHTTPHeaderField:@"Content-Length"];
        [requests setValue:@"CT_1C_OPPCREATION.VERSION1" forHTTPHeaderField:@"SOAPAction"];
        [requests setHTTPMethod:@"POST"];
        [requests setHTTPBody:[soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSURLResponse *response;
        
        
        NSData   *data = (NSMutableData *) [NSURLConnection sendSynchronousRequest:requests returningResponse:&response error:&error];
        
        NSString *s = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@",s);
        if(!error)
        {
            NSXMLParser *parser = [[NSXMLParser alloc]initWithData:data];
            
            XMLParser *xmlParser = [[XMLParser alloc]initXMLParser];
            xmlParser.ParsingType = CreateOpportunity;
            [parser setDelegate:xmlParser];
            
            [parser parse];
        }
        
    }
    
    return error;
}




@end
