//
//  CoreDataHelper.m
//  iPitch V2
//
//  Created by Satheeshwaran on 6/12/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//

#import "CoreDataHelper.h"
#import "AppDelegate.h"
#import "Events.h"
#import "iPitchConstants.h"
#import "ZohoConstants.h"
#import "Tasks.h"
#import "Events.h"
#import "Accounts.h"
#import "Customers.h"
#import "Leads.h"
#import "Opportunities.h"
#import "Notes.h"

@implementation CoreDataHelper

+(void)insertEventsToStore:(NSMutableDictionary *)eventDetails CRMSyncStatus:(BOOL)status
{
    NSString *eventID=[eventDetails objectForKey:ZOHO_ACTIVITY_ID_PARAMETER];
    
    if(eventID)
    {
        NSManagedObjectContext *context=SAppDelegateObject.managedObjectContext;
        
        if(![self checkAttributeWithAttributeName:@"eventID" InEntityWithEntityName:EVENTS_PARAMETER ForPreviousItems:eventID inContext:context])
        {
            
            Events *ActivityObject=[NSEntityDescription
                                    insertNewObjectForEntityForName:@"Events"
                                    inManagedObjectContext:context];
            
            if(status)
            {
                ActivityObject.eventSyncStatus= [NSNumber numberWithBool:YES];
            }
            
            ActivityObject.eventTitle = [eventDetails objectForKey:ZOHO_SUBJECT_PARAMETER];
            ActivityObject.eventVenue = [eventDetails objectForKey:ZOHO_VENUE_PARAMETER];
            ActivityObject.eventID = [eventDetails objectForKey:ZOHO_ACTIVITY_ID_PARAMETER];
            ActivityObject.eventDescType = [eventDetails objectForKey:ZOHO_PURPOSE_PARAMETER];
            ActivityObject.eventStartDate = [eventDetails objectForKey:ZOHO_START_TIME_PARAMETER];
            ActivityObject.eventEndDate = [eventDetails objectForKey:ZOHO_END_TIME_PARAMETER];
            ActivityObject.eventPurpose=[eventDetails objectForKey:ZOHO_PURPOSE_PARAMETER];
            
            
            if ([[eventDetails objectForKey:ZOHO_EVENT_TYPE_PARAMETER] isEqualToString:ZOHO_PURPOSE_TYPE_CALL]) {
                [ActivityObject setEventTypeRaw:EventTypeCall];
                
            }
            
            else if ([[eventDetails objectForKey:ZOHO_CONTENT_PARAMETER] isEqualToString:ZOHO_PURPOSE_TYPE_EMAIL]) {
                [ActivityObject setEventTypeRaw:EventTypeEmail];
                
                
            }
            else if ([[eventDetails objectForKey:ZOHO_CONTENT_PARAMETER] isEqualToString:ZOHO_PURPOSE_TYPE_MEETING]) {
                [ActivityObject setEventTypeRaw:EventTypeMeeting];
                
                
            }
            else if ([[eventDetails objectForKey:ZOHO_CONTENT_PARAMETER] isEqualToString:ZOHO_PURPOSE_TYPE_DEMO]) {
                [ActivityObject setEventTypeRaw:EventTypeProduct_Demo];
                
                
            }
            
            ActivityObject.relatedToID = [eventDetails objectForKey:ZOHO_RELATED_TO_MODULE_ID];
            //ActivityObject.relatedToContactID = [eventDetails objectForKey:@"content"];
            //ActivityObject.relatedToContactName = [eventDetails objectForKey:@"content"];
            
            
            NSError *error;
            if (![context save:&error])
            {
                NSLog(@"Sorry, couldn't save Events %@", [error localizedDescription]);
            }
        }
        
        else
        {
            
            NSFetchRequest *request = [[NSFetchRequest alloc] init];
            [request setEntity:[NSEntityDescription entityForName:@"Events" inManagedObjectContext:context]];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"eventID == %@", eventID];
            [request setPredicate:predicate];
            
            NSError *error = nil;
            NSArray *results = [context executeFetchRequest:request error:&error];
            
            if ([results count]>0)
            {
                
                Events *ActivityObject=(Events *)[results objectAtIndex:0];
                
                if(status)
                {
                    ActivityObject.eventSyncStatus= [NSNumber numberWithBool:YES];
                }
                
                ActivityObject.eventTitle = [eventDetails objectForKey:ZOHO_SUBJECT_PARAMETER];
                ActivityObject.eventVenue = [eventDetails objectForKey:ZOHO_VENUE_PARAMETER];
                ActivityObject.eventID = [eventDetails objectForKey:ZOHO_ACTIVITY_ID_PARAMETER];
                ActivityObject.eventDescType = [eventDetails objectForKey:ZOHO_PURPOSE_PARAMETER];
                ActivityObject.eventStartDate = [eventDetails objectForKey:ZOHO_START_TIME_PARAMETER];
                ActivityObject.eventEndDate = [eventDetails objectForKey:ZOHO_END_TIME_PARAMETER];
                ActivityObject.eventPurpose=[eventDetails objectForKey:ZOHO_PURPOSE_PARAMETER];
                
                
                if ([[eventDetails objectForKey:ZOHO_EVENT_TYPE_PARAMETER] isEqualToString:ZOHO_PURPOSE_TYPE_CALL]) {
                    [ActivityObject setEventTypeRaw:EventTypeCall];
                    
                }
                
                else if ([[eventDetails objectForKey:ZOHO_CONTENT_PARAMETER] isEqualToString:ZOHO_PURPOSE_TYPE_EMAIL]) {
                    [ActivityObject setEventTypeRaw:EventTypeEmail];
                    
                    
                }
                else if ([[eventDetails objectForKey:ZOHO_CONTENT_PARAMETER] isEqualToString:ZOHO_PURPOSE_TYPE_MEETING]) {
                    [ActivityObject setEventTypeRaw:EventTypeMeeting];
                    
                    
                }
                else if ([[eventDetails objectForKey:ZOHO_CONTENT_PARAMETER] isEqualToString:ZOHO_PURPOSE_TYPE_DEMO]) {
                    [ActivityObject setEventTypeRaw:EventTypeProduct_Demo];
                    
                    
                }
                
                ActivityObject.relatedToID = [eventDetails objectForKey:ZOHO_RELATED_TO_MODULE_ID];
                
                //ActivityObject.relatedToContactID = [eventDetails objectForKey:@"content"];
                //ActivityObject.relatedToContactName = [eventDetails objectForKey:@"content"];
                
                if (![context save:&error])
                {
                    NSLog(@"Sorry, couldn't save Events %@", [error localizedDescription]);
                }
            }
        }
    }
}


+(void)insertTasksToStore:(NSMutableDictionary *)taskDetails CRMSyncStatus:(BOOL)status
{
    NSString *taskID=[taskDetails objectForKey:TASK_ID_PARMETER];
    
    if(taskID)
    {
        NSManagedObjectContext *context=SAppDelegateObject.managedObjectContext;
        
        if(![self checkAttributeWithAttributeName:TASK_ID_PARMETER InEntityWithEntityName:TASKS_MODULE ForPreviousItems:taskID inContext:context])
        {
            
            Tasks *taskObject = [NSEntityDescription
                                 insertNewObjectForEntityForName:@"Tasks"
                                 inManagedObjectContext:context];
            
            if(status)
            {
                taskObject.taskSyncType= [NSNumber numberWithBool:YES];
            }
            
            taskObject.taskSyncType=[NSNumber numberWithBool:YES];
            taskObject.taskSubject = [taskDetails objectForKey:ZOHO_SUBJECT_PARAMETER];
            
            /*if ([[dictionaryTaskActivity objectForKey:@"content"] isEqualToString:@"Call"]) {
             [taskObject setTaskTypeRaw:TaskTypeCall];
             
             }
             
             else if ([[dictionaryTaskActivity objectForKey:@"content"] isEqualToString:@"Email"]) {
             [taskObject setTaskTypeRaw:TaskTypeEmail];
             
             }
             else if ([[dictionaryTaskActivity objectForKey:@"content"] isEqualToString:@"Meeting"]) {
             [taskObject setTaskTypeRaw:TaskTypeMeeting];
             
             }
             else if ([[dictionaryTaskActivity objectForKey:@"content"] isEqualToString:@"Product Demo"]) {
             [taskObject setTaskTypeRaw:TaskTypeProduct_Demo];
             
             }*/
            
            taskObject.taskDueDate = [taskDetails objectForKey:START_DATE_PARAMTER];
            taskObject.taskDescription=[taskDetails objectForKey:ZOHO_DESCRIPTION_PARAMETER];
            
            taskObject.taskID=taskID;
            
            
            
            NSError *error;
            if (![context save:&error])
            {
                NSLog(@"Sorry, couldn't save Tasks %@", [error localizedDescription]);
            }
        }
        
        else
        {
            
            NSFetchRequest *request = [[NSFetchRequest alloc] init];
            [request setEntity:[NSEntityDescription entityForName:TASKS_MODULE inManagedObjectContext:context]];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"taskID == %@", taskID];
            [request setPredicate:predicate];
            
            NSError *error = nil;
            NSArray *results = [context executeFetchRequest:request error:&error];
            
            if ([results count]>0)
            {
                Tasks *taskObject=[results objectAtIndex:0];
                
                if(status)
                {
                    taskObject.taskSyncType= [NSNumber numberWithBool:YES];
                }
                
                taskObject.taskSyncType=[NSNumber numberWithBool:YES];
                taskObject.taskSubject = [taskDetails objectForKey:ZOHO_SUBJECT_PARAMETER];
                
                /*if ([[dictionaryTaskActivity objectForKey:@"content"] isEqualToString:@"Call"]) {
                 [taskObject setTaskTypeRaw:TaskTypeCall];
                 
                 }
                 
                 else if ([[dictionaryTaskActivity objectForKey:@"content"] isEqualToString:@"Email"]) {
                 [taskObject setTaskTypeRaw:TaskTypeEmail];
                 
                 }
                 else if ([[dictionaryTaskActivity objectForKey:@"content"] isEqualToString:@"Meeting"]) {
                 [taskObject setTaskTypeRaw:TaskTypeMeeting];
                 
                 }
                 else if ([[dictionaryTaskActivity objectForKey:@"content"] isEqualToString:@"Product Demo"]) {
                 [taskObject setTaskTypeRaw:TaskTypeProduct_Demo];
                 
                 }*/
                
                taskObject.taskDueDate = [taskDetails objectForKey:START_DATE_PARAMTER];
                taskObject.taskDescription=[taskDetails objectForKey:ZOHO_DESCRIPTION_PARAMETER];
                
                taskObject.taskID=taskID;
                
                NSError *error;
                
                
                if (![context save:&error])
                {
                    NSLog(@"Sorry, couldn't save Tasks %@", [error localizedDescription]);
                }
            }
        }
    }
    
}


+(void)insertAccountsToStore:(NSMutableDictionary *)accountDetails
{
    NSString *accountID=[accountDetails objectForKey:ZOHO_ACCOUNT_ID_PARAMETER];
    
    if(accountID)
    {
        NSManagedObjectContext *context=SAppDelegateObject.managedObjectContext;
        
        if(![self checkAttributeWithAttributeName:@"accountID" InEntityWithEntityName:ACCOUNTS_ENTITY ForPreviousItems:accountID inContext:context])
        {
        Accounts * accountObject = [NSEntityDescription
                                    insertNewObjectForEntityForName:ACCOUNTS_ENTITY
                                    inManagedObjectContext:context];


        accountObject.acconuntPhoneNo = [accountDetails objectForKey:ZOHO_PHONE_PARAMETER];
        accountObject.accountName = [accountDetails objectForKey:NAME_PARAMETER];
        accountObject.accountNo = [accountDetails objectForKey:ZOHO_ACCOUNT_NUMBER_PARAMETER];
        accountObject.accountType=[accountDetails objectForKey:ZOHO_ACCOUNT_TYPE_PARAMETER];
        accountObject.annualRevenue = [NSString stringWithFormat:@"%@", [accountDetails objectForKey:ANNUAL_REVENUE_PARAMETER]];
        accountObject.accountOwnerShip = [accountDetails objectForKey:ZOHO_ACCOUNT_OWNERSHIP_PARAMETER];
        accountObject.accountID = [accountDetails objectForKey:ZOHO_ACCOUNT_ID_PARAMETER];
        accountObject.numberOfEmployees= [NSString stringWithFormat:@"%@",[accountDetails objectForKey:NUMBER_OF_EMPLOYEES]];
        accountObject.mailingStreet=[accountDetails objectForKey:BILLING_STREET_PARARMETER];
        accountObject.mailingCity = [accountDetails objectForKey:BILLING_CITY_PARARMETER];
        accountObject.mailingState = [accountDetails objectForKey:BILLING_STATE_PARARMETER];
        accountObject.mailingZIP = [accountDetails objectForKey:BILLING_ZIP_PARARMETER];
        accountObject.mailingCountry = [accountDetails objectForKey:BILLING_COUNTRY_PARARMETER];
        accountObject.accountWebSite = [accountDetails objectForKey:ZOHO_WEBSITE_PARAMETER];
            accountObject.accountIndustry=[accountDetails objectForKey:ZOHO_INDUSTRY_PARAMETER];
        accountObject.parentAccountId= [NSString stringWithFormat:@"%@",[accountDetails objectForKey:PARENT_ID_PARAMETER]];
            
        NSError *error;
    
        if (![context save:&error])
        {
                NSLog(@"Sorry, couldn't save Accounts %@", [error localizedDescription]);
        }

        }
        
        else
        {
            NSFetchRequest *request = [[NSFetchRequest alloc] init];
            [request setEntity:[NSEntityDescription entityForName:ACCOUNTS_ENTITY inManagedObjectContext:context]];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"accountID == %@", accountID];
            [request setPredicate:predicate];
            
            NSError *error = nil;
            NSArray *results = [context executeFetchRequest:request error:&error];
            
            if ([results count]>0)
            {
                Accounts *accountObject=[results objectAtIndex:0];
                
                accountObject.acconuntPhoneNo = [accountDetails objectForKey:ZOHO_PHONE_PARAMETER];
                accountObject.accountName = [accountDetails objectForKey:NAME_PARAMETER];
                accountObject.accountNo = [accountDetails objectForKey:ZOHO_ACCOUNT_NUMBER_PARAMETER];
                accountObject.accountType=[accountDetails objectForKey:ZOHO_ACCOUNT_TYPE_PARAMETER];
                accountObject.annualRevenue = [NSString stringWithFormat:@"%@", [accountDetails objectForKey:ANNUAL_REVENUE_PARAMETER]];
                accountObject.accountOwnerShip = [accountDetails objectForKey:ZOHO_ACCOUNT_OWNERSHIP_PARAMETER];
                accountObject.accountID = [accountDetails objectForKey:ZOHO_ACCOUNT_ID_PARAMETER];
                accountObject.numberOfEmployees=[NSString stringWithFormat:@"%@",[accountDetails objectForKey:NUMBER_OF_EMPLOYEES]];
                accountObject.mailingStreet=[accountDetails objectForKey:BILLING_STREET_PARARMETER];
                accountObject.mailingCity = [accountDetails objectForKey:BILLING_CITY_PARARMETER];
                accountObject.mailingState = [accountDetails objectForKey:BILLING_STATE_PARARMETER];
                accountObject.mailingZIP = [accountDetails objectForKey:BILLING_ZIP_PARARMETER];
                accountObject.mailingCountry = [accountDetails objectForKey:BILLING_COUNTRY_PARARMETER];
                accountObject.accountWebSite = [accountDetails objectForKey:ZOHO_WEBSITE_PARAMETER];
                accountObject.accountIndustry=[accountDetails objectForKey:ZOHO_INDUSTRY_PARAMETER];
                accountObject.parentAccountId=[NSString stringWithFormat:@"%@",[accountDetails objectForKey:PARENT_ID_PARAMETER]];
                
                NSError *error;
                
                if (![context save:&error])
                {
                    NSLog(@"Sorry, couldn't save Accounts %@", [error localizedDescription]);
                }

            }
        }
    }
    
}


+(void)insertContactsToStore:(NSMutableDictionary *)contactDetails
{
    NSString *contactID=[contactDetails objectForKey:CONTACT_ID_PARAMETER];
    
    if(contactID)
    {
        NSManagedObjectContext *context=SAppDelegateObject.managedObjectContext;
        
        if(![self checkAttributeWithAttributeName:@"customerID" InEntityWithEntityName:CUSTOMERS_ENTITY ForPreviousItems:contactID inContext:context])
        {
            Customers * customerObject = [NSEntityDescription
                                          insertNewObjectForEntityForName:CUSTOMERS_ENTITY
                                          inManagedObjectContext:context];
            
            customerObject.phoneNumber = [contactDetails objectForKey:ZOHO_PHONE_PARAMETER];
            customerObject.firstName = [contactDetails objectForKey:FIRST_NAME_PARAMETER];
            customerObject.lastName = [contactDetails objectForKey:LAST_NAME_PARAMTER];
            customerObject.customerID = [contactDetails objectForKey:CONTACT_ID_PARAMETER];
            customerObject.emailID=[contactDetails objectForKey:ZOHO_EMAIL_PARAMETER];
            customerObject.dateOfBirth = [contactDetails objectForKey:BIRTH_DATE_PARAMETER];
            customerObject.department = [contactDetails objectForKey:ZOHO_DEPARTMENT_PARAMETER];
            customerObject.accountID = [contactDetails objectForKey:ACCOUNT_ID_PARAMTER];
           
            customerObject.descriptionAboutCustomer = [contactDetails objectForKey:ZOHO_DESCRIPTION_PARAMETER];
            customerObject.mailingCity = [contactDetails objectForKey:MAILING_CITY_PARAMETER];
            customerObject.mailingCountry = [contactDetails objectForKey:MAILING_COUNTRY_PARAMETER];
            customerObject.mailingState = [contactDetails objectForKey:MAILING_STATE_PARAMETER];
            customerObject.mailingStreet = [contactDetails objectForKey:MAILING_STREET_PARAMETER];
            customerObject.mailingZIP = [contactDetails objectForKey:MAILING_POSTAL_CODE];

            //customerObject.accountName = [contactDetails objectForKey:@"content"];
            /* customerObject.skypeID = [contactDetails objectForKey:@"content"];
             customerObject.twitterID = [contactDetails objectForKey:@"content"];
             customerObject.linkedinID = [contactDetails objectForKey:@"content"];
            customerObject.customerImageURL=[NSString stringWithFormat:@"https://crm.zoho.com/crm/private/json/Contacts/downloadPhoto?authtoken=%@&scope=crmapi&id=%@",self.token,customerObject.customerID];*/
            
            NSError *error;
            
            if (![context save:&error])
            {
                NSLog(@"Sorry, couldn't save Customers %@", [error localizedDescription]);
            }
            
        }
        
        else
        {
            NSFetchRequest *request = [[NSFetchRequest alloc] init];
            [request setEntity:[NSEntityDescription entityForName:CUSTOMERS_ENTITY inManagedObjectContext:context]];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"customerID == %@", contactID];
            [request setPredicate:predicate];
            
            NSError *error = nil;
            NSArray *results = [context executeFetchRequest:request error:&error];
            
            if ([results count]>0)
            {
                
                Customers * customerObject = [results objectAtIndex:0];
                
                customerObject.phoneNumber = [contactDetails objectForKey:ZOHO_PHONE_PARAMETER];
                customerObject.firstName = [contactDetails objectForKey:FIRST_NAME_PARAMETER];
                customerObject.lastName = [contactDetails objectForKey:LAST_NAME_PARAMTER];
                customerObject.customerID = [contactDetails objectForKey:CONTACT_ID_PARAMETER];
                customerObject.emailID=[contactDetails objectForKey:ZOHO_EMAIL_PARAMETER];
                customerObject.dateOfBirth = [contactDetails objectForKey:BIRTH_DATE_PARAMETER];
                customerObject.department = [contactDetails objectForKey:ZOHO_DEPARTMENT_PARAMETER];
                customerObject.accountID = [contactDetails objectForKey:ACCOUNT_ID_PARAMTER];
                
                customerObject.descriptionAboutCustomer = [contactDetails objectForKey:ZOHO_DESCRIPTION_PARAMETER];
                customerObject.mailingCity = [contactDetails objectForKey:MAILING_CITY_PARAMETER];
                customerObject.mailingCountry = [contactDetails objectForKey:MAILING_COUNTRY_PARAMETER];
                customerObject.mailingState = [contactDetails objectForKey:MAILING_STATE_PARAMETER];
                customerObject.mailingStreet = [contactDetails objectForKey:MAILING_STREET_PARAMETER];
                customerObject.mailingZIP = [contactDetails objectForKey:MAILING_POSTAL_CODE];
                

                NSError *error;
                
                if (![context save:&error])
                {
                    NSLog(@"Sorry, couldn't save Customers %@", [error localizedDescription]);
                }
                
            }
        }
    }

}


+(void)insertLeadsToStore:(NSMutableDictionary *)leadDetails
{
    NSString *leadID=[leadDetails objectForKey:ID_PARAMTER];
    
    if(leadID)
    {
        NSManagedObjectContext *context=SAppDelegateObject.managedObjectContext;
        
        if(![self checkAttributeWithAttributeName:@"leadID" InEntityWithEntityName:LEADS_MODULE ForPreviousItems:leadID inContext:context])
        {
            Leads * leadObject = [NSEntityDescription
                                          insertNewObjectForEntityForName:LEADS_MODULE
                                          inManagedObjectContext:context];
            
            leadObject.leadPhone = [leadDetails objectForKey:ZOHO_PHONE_PARAMETER];
            leadObject.leadFirstName = [leadDetails objectForKey:FIRST_NAME_PARAMETER];
            leadObject.leadLastName = [leadDetails objectForKey:LAST_NAME_PARAMTER];
            leadObject.leadEmailID=[leadDetails objectForKey:ZOHO_EMAIL_PARAMETER];
            leadObject.leadID = [leadDetails objectForKey:ID_PARAMTER];
            leadObject.leadDescription = [leadDetails objectForKey:ZOHO_DESCRIPTION_PARAMETER];
            leadObject.annualRevenue = [NSString stringWithFormat:@"%@", [leadDetails objectForKey:ANNUAL_REVENUE_PARAMETER]];

            leadObject.leadCompany = [leadDetails objectForKey:ZOHO_COMPANY_PARAMETER];

            leadObject.leadFax = [leadDetails objectForKey:ZOHO_FAX_PARAMETER];

            leadObject.leadMobileNo = [leadDetails objectForKey:MOBILE_PHONE_PARAMETER];
            leadObject.leadSource = [leadDetails objectForKey:LEAD_SOURCE_PARAMETER];
            leadObject.numberOfEmployees = [NSString stringWithFormat:@"%@",[leadDetails objectForKey:NUMBER_OF_EMPLOYEES]];
            leadObject.leadRating = [leadDetails objectForKey:ZOHO_RATING_PARAMETER];
            leadObject.leadSalutation = [leadDetails objectForKey:ZOHO_SALUTATION_PARAMETER];
            leadObject.leadStatus = [leadDetails objectForKey:STATUS_PARAMETER];
            leadObject.leadIndustry = [leadDetails objectForKey:ZOHO_INDUSTRY_PARAMETER];
            leadObject.leadTitle = [leadDetails objectForKey:TITLE_PARAMETER];

            leadObject.mailingCity = [leadDetails objectForKey:ZOHO_CITY_PARAMETER];
            leadObject.mailingCountry = [leadDetails objectForKey:ZOHO_COUNTRY_PARAMETER];
            leadObject.mailingState = [leadDetails objectForKey:ZOHO_STATE_PARAMETER];
            leadObject.mailingStreet = [leadDetails objectForKey:ZOHO_STREET_PARAMETER];
            leadObject.mailingZIP = [leadDetails objectForKey:POSTAL_CODE_PARAMETER];
            
            //customerObject.accountName s= [contactDetails objectForKey:@"content"];
            /* customerObject.skypeID = [contactDetails objectForKey:@"content"];
             customerObject.twitterID = [contactDetails objectForKey:@"content"];
             customerObject.linkedinID = [contactDetails objectForKey:@"content"];
             customerObject.customerImageURL=[NSString stringWithFormat:@"https://crm.zoho.com/crm/private/json/Contacts/downloadPhoto?authtoken=%@&scope=crmapi&id=%@",self.token,customerObject.customerID];*/
            
            NSError *error;
            
            if (![context save:&error])
            {
                NSLog(@"Sorry, couldn't save Leads %@", [error localizedDescription]);
            }
            
        }
        
        else
        {
            NSFetchRequest *request = [[NSFetchRequest alloc] init];
            [request setEntity:[NSEntityDescription entityForName:LEADS_MODULE inManagedObjectContext:context]];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"leadID == %@", leadID];
            [request setPredicate:predicate];
            
            NSError *error = nil;
            NSArray *results = [context executeFetchRequest:request error:&error];
            
            if ([results count]>0)
            {
                
                Leads * leadObject = [results objectAtIndex:0];
                
                leadObject.leadPhone = [leadDetails objectForKey:ZOHO_PHONE_PARAMETER];
                leadObject.leadFirstName = [leadDetails objectForKey:FIRST_NAME_PARAMETER];
                leadObject.leadLastName = [leadDetails objectForKey:LAST_NAME_PARAMTER];
                leadObject.leadEmailID=[leadDetails objectForKey:ZOHO_EMAIL_PARAMETER];
                leadObject.leadID = [leadDetails objectForKey:ID_PARAMTER];
                leadObject.leadDescription = [leadDetails objectForKey:ZOHO_DESCRIPTION_PARAMETER];
                leadObject.annualRevenue = [NSString stringWithFormat:@"%@",[leadDetails objectForKey:ANNUAL_REVENUE_PARAMETER]];
                
                leadObject.leadCompany = [leadDetails objectForKey:ZOHO_COMPANY_PARAMETER];
                
                leadObject.leadFax = [leadDetails objectForKey:ZOHO_FAX_PARAMETER];
                
                leadObject.leadMobileNo = [leadDetails objectForKey:MOBILE_PHONE_PARAMETER];
                leadObject.leadSource = [leadDetails objectForKey:LEAD_SOURCE_PARAMETER];
                leadObject.numberOfEmployees = [NSString stringWithFormat:@"%@",[leadDetails objectForKey:NUMBER_OF_EMPLOYEES]];
                leadObject.leadRating = [leadDetails objectForKey:ZOHO_RATING_PARAMETER];
                leadObject.leadSalutation = [leadDetails objectForKey:ZOHO_SALUTATION_PARAMETER];
                leadObject.leadStatus = [leadDetails objectForKey:STATUS_PARAMETER];
                leadObject.leadIndustry = [leadDetails objectForKey:ZOHO_INDUSTRY_PARAMETER];
                leadObject.leadTitle = [leadDetails objectForKey:TITLE_PARAMETER];
                
                leadObject.mailingCity = [leadDetails objectForKey:ZOHO_CITY_PARAMETER];
                leadObject.mailingCountry = [leadDetails objectForKey:ZOHO_COUNTRY_PARAMETER];
                leadObject.mailingState = [leadDetails objectForKey:ZOHO_STATE_PARAMETER];
                leadObject.mailingStreet = [leadDetails objectForKey:ZOHO_STREET_PARAMETER];
                leadObject.mailingZIP = [leadDetails objectForKey:POSTAL_CODE_PARAMETER];
                
                
                NSError *error;
                
                if (![context save:&error])
                {
                    NSLog(@"Sorry, couldn't save Leads %@", [error localizedDescription]);
                }
                
            }
        }
    }

}

+(void)insertOpportunitiesToStore:(NSMutableDictionary *)opportunityDetails
{
    NSString *opportunityID=[opportunityDetails objectForKey:ID_PARAMTER];
    
    if(opportunityID)
    {
        NSManagedObjectContext *context=SAppDelegateObject.managedObjectContext;
        
        if(![self checkAttributeWithAttributeName:@"opportunityID" InEntityWithEntityName:OPPORTUNITY_ENTITY ForPreviousItems:opportunityID inContext:context])
        {
            Opportunities * opportunityObject = [NSEntityDescription
                                                 insertNewObjectForEntityForName:OPPORTUNITY_ENTITY
                                                 inManagedObjectContext:context];
            
            opportunityObject.opportunityName = [opportunityDetails objectForKey:NAME_PARAMETER];
            opportunityObject.opportunityDescription = [opportunityDetails objectForKey:ZOHO_DESCRIPTION_PARAMETER];
            opportunityObject.opportunityProbability = [NSString stringWithFormat:@"%@",[opportunityDetails objectForKey:ZOHO_PROBABILITY_PARAMETER]];
            opportunityObject.opportunityRevenue=[NSString stringWithFormat:@"%@",[opportunityDetails objectForKey:EXPECTED_REVENUE_PARAMETER]];
            
            if([[opportunityDetails objectForKey:IS_CLOSED_PARAMETER] boolValue])
            opportunityObject.opportunityStage = CLOSED_STATUS;
            else if([[opportunityDetails objectForKey:IS_DELETED_PARAMETER] boolValue])
                opportunityObject.opportunityStage = DELETED_STATUS;
            else if([[opportunityDetails objectForKey:IS_PRIVATE_PARAEMETER] boolValue])
                opportunityObject.opportunityStage = PRIVATE_STATUS;
            else if([[opportunityDetails objectForKey:IS_WON_PARAMETER] boolValue])
                opportunityObject.opportunityStage = WON_STATUS;
            
            opportunityObject.opportunityType = [opportunityDetails objectForKey:ZOHO_TYPE_PARAMETER];
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"]; 
            opportunityObject.opportunityClosingDate = [dateFormatter dateFromString:[opportunityDetails objectForKey:CLOSE_DATE_PARAMETER]];
            
            opportunityObject.opportunityRelatedToAccountID = [opportunityDetails objectForKey:ACCOUNT_ID_PARAMTER];
            opportunityObject.opportunityID = [NSString stringWithFormat:@"%@",[opportunityDetails objectForKey:ID_PARAMTER]];
            opportunityObject.opportunityAmount = [NSString stringWithFormat:@"%@",[opportunityDetails objectForKey:ZOHO_AMOUNT_PARAMETER]];
            //opportunityObject.opportunityRelatedToAccountName = [opportunityDetails objectForKey:@"content"];
            //opportunityObject.opportunityRelatedToContactID = [opportunityDetails objectForKey:@"content"];
            //opportunityObject.opportunityRelatedToContactName = [opportunityDetails objectForKey:@"content"];
            NSError *error;
            
            if (![context save:&error])
            {
                NSLog(@"Sorry, couldn't save Opportunities %@", [error localizedDescription]);
            }
            
        }
        
        else
        {
            NSFetchRequest *request = [[NSFetchRequest alloc] init];
            [request setEntity:[NSEntityDescription entityForName:OPPORTUNITY_ENTITY inManagedObjectContext:context]];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"opportunityID == %@", opportunityID];
            [request setPredicate:predicate];
            
            NSError *error = nil;
            NSArray *results = [context executeFetchRequest:request error:&error];
            
            if ([results count]>0)
            {
                
                Opportunities * opportunityObject = [results objectAtIndex:0];
                
                opportunityObject.opportunityName = [opportunityDetails objectForKey:NAME_PARAMETER];
                opportunityObject.opportunityDescription = [opportunityDetails objectForKey:ZOHO_DESCRIPTION_PARAMETER];
                opportunityObject.opportunityProbability = [NSString stringWithFormat:@"%@",[opportunityDetails objectForKey:ZOHO_PROBABILITY_PARAMETER]];
                opportunityObject.opportunityRevenue=[NSString stringWithFormat:@"%@",[opportunityDetails objectForKey:EXPECTED_REVENUE_PARAMETER]];
                
                if([[opportunityDetails objectForKey:IS_CLOSED_PARAMETER] boolValue])
                    opportunityObject.opportunityStage = CLOSED_STATUS;
                else if([[opportunityDetails objectForKey:IS_DELETED_PARAMETER] boolValue])
                    opportunityObject.opportunityStage = DELETED_STATUS;
                else if([[opportunityDetails objectForKey:IS_PRIVATE_PARAEMETER] boolValue])
                    opportunityObject.opportunityStage = PRIVATE_STATUS;
                else if([[opportunityDetails objectForKey:IS_WON_PARAMETER] boolValue])
                    opportunityObject.opportunityStage = WON_STATUS;
                
                opportunityObject.opportunityType = [opportunityDetails objectForKey:ZOHO_TYPE_PARAMETER];
                
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                opportunityObject.opportunityClosingDate = [dateFormatter dateFromString:[opportunityDetails objectForKey:CLOSE_DATE_PARAMETER]];
                
                opportunityObject.opportunityRelatedToAccountID = [opportunityDetails objectForKey:ACCOUNT_ID_PARAMTER];
                opportunityObject.opportunityID = [NSString stringWithFormat:@"%@",[opportunityDetails objectForKey:ID_PARAMTER]];
                opportunityObject.opportunityAmount = [NSString stringWithFormat:@"%@",[opportunityDetails objectForKey:ZOHO_AMOUNT_PARAMETER]];

                NSError *error;
                
                if (![context save:&error])
                {
                    NSLog(@"Sorry, couldn't save Opportunities %@", [error localizedDescription]);
                }
                
            }
        }
    }
    
}


+(void)insertNotesToStore:(NSMutableDictionary *)noteDetails withStatus:(BOOL)status
{
    NSString *noteID=[noteDetails objectForKey:ID_PARAMTER];
    
    if(noteID)
    {
        NSManagedObjectContext *context=SAppDelegateObject.managedObjectContext;
        
        if(![self checkAttributeWithAttributeName:@"noteID" InEntityWithEntityName:NOTES_ENTITY ForPreviousItems:noteID inContext:context])
        {
            Notes * noteObject = [NSEntityDescription
                                                 insertNewObjectForEntityForName:NOTES_ENTITY
                                                 inManagedObjectContext:context];
            
            noteObject.notesCRMSyncStatus=[NSNumber numberWithBool:status];
            noteObject.noteID=[noteDetails objectForKey:ID_PARAMTER];
            noteObject.noteTitle=[noteDetails objectForKey:TITLE_PARAMETER];
            noteObject.noteContent=[noteDetails objectForKey:BODY_PARAMETER];
            noteObject.noteRelatedToID=[noteDetails objectForKey:PARENT_ID_PARAMETER];


            NSError *error;
            
            if (![context save:&error])
            {
                NSLog(@"Sorry, couldn't save Notes %@", [error localizedDescription]);
            }
            
        }
        
        else
        {
            NSFetchRequest *request = [[NSFetchRequest alloc] init];
            [request setEntity:[NSEntityDescription entityForName:NOTES_ENTITY inManagedObjectContext:context]];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"noteID == %@", noteID];
            [request setPredicate:predicate];
            
            NSError *error = nil;
            NSArray *results = [context executeFetchRequest:request error:&error];
            
            if ([results count]>0)
            {
                
                Notes * noteObject = [results objectAtIndex:0];
                
                noteObject.notesCRMSyncStatus=[NSNumber numberWithBool:status];
                noteObject.noteID=[noteDetails objectForKey:ID_PARAMTER];
                noteObject.noteTitle=[noteDetails objectForKey:TITLE_PARAMETER];
                noteObject.noteContent=[noteDetails objectForKey:BODY_PARAMETER];
                noteObject.noteRelatedToID=[noteDetails objectForKey:PARENT_ID_PARAMETER];


                NSError *error;
                
                if (![context save:&error])
                {
                    NSLog(@"Sorry, couldn't save Notes %@", [error localizedDescription]);
                }
                
            }
        }
    }
    
}

/****************************************************************************************/
// This method checks for a previoulsy existing item in Core data DB for any entity.
/****************************************************************************************/

+ (BOOL)checkAttributeWithAttributeName:(NSString *)attributeName InEntityWithEntityName:(NSString *)entityName ForPreviousItems:(NSString *)itemValue inContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.predicate=[NSPredicate predicateWithFormat:@"%K == %@",attributeName,itemValue];
    NSSortDescriptor *sortDescriptor=[NSSortDescriptor sortDescriptorWithKey:attributeName ascending:YES];
    fetchRequest.sortDescriptors=[NSArray arrayWithObject:sortDescriptor];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSArray *fetchedObjects = [context
                               executeFetchRequest:fetchRequest error:nil
                               ];
    if ([fetchedObjects count]>0) {
        return YES;
    }
    
    return NO;
}


/****************************************************************************************/
// This method checks for a previoulsy existing item in Core data DB for any entity.
/****************************************************************************************/

+ (BOOL)checkAttributeWithAttributeName:(NSString *)attributeName InEntityWithEntityName:(NSString *)entityName ForPreviousItems:(NSString *)itemValue
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.predicate=[NSPredicate predicateWithFormat:@"%K == %@",attributeName,itemValue];
    NSSortDescriptor *sortDescriptor=[NSSortDescriptor sortDescriptorWithKey:attributeName ascending:YES];
    fetchRequest.sortDescriptors=[NSArray arrayWithObject:sortDescriptor];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName
                                              inManagedObjectContext:SAppDelegateObject.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSArray *fetchedObjects = [SAppDelegateObject.managedObjectContext
                               executeFetchRequest:fetchRequest error:nil
                               ];
    if ([fetchedObjects count]>0) {
        return YES;
    }
    
    return NO;
}

/****************************************************************************************/
//	This method deletes CRM Tasks in Core Data DB.
/****************************************************************************************/

+ (void)deleteCRMTasksInTasksEntityInContext :(NSManagedObjectContext*)context
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.predicate=[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"taskSyncType==1"]];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Tasks"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSArray *fetchedObjects = [context
                               executeFetchRequest:fetchRequest error:nil
                               ];
    
    for (Tasks *managedObject in fetchedObjects) {
    	[context deleteObject:managedObject];
        
    }
    NSError *error=nil;
    
    if (![context save:&error]) {
    	NSLog(@"Error in deleting : %@",[error localizedDescription]);
    }
}


/****************************************************************************************/
//	This method deletes CRM Activites in Core Data DB.
/****************************************************************************************/

+ (void)deleteCRMActivitiesInEventsEntityInContext :(NSManagedObjectContext*)context
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.predicate=[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"eventSyncStatus==1"]];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Events"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSArray *fetchedObjects = [context
                               executeFetchRequest:fetchRequest error:nil
                               ];
    
    
    for (Events *managedObject in fetchedObjects) {
    	[context deleteObject:managedObject];
    }
    NSError *error=nil;
    
    if (![context save:&error]) {
    	NSLog(@"Error in deleting : %@",[error localizedDescription]);
    }
}

@end
