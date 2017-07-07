//
//  CRMHelper.m
//  iPitch V2
//
//  Created by Satheeshwaran on 6/15/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//

#import "CRMHelper.h"

#import "iPitchConstants.h"

#import "AppDelegate.h"

#import "Accounts.h"

#import "Lead.h"

#import "Leads.h"

#import "Tasks.h"

#import "Events.h"

#import <CoreData/CoreData.h>

#import "Potentials.h"

#import "Opportunities.h"

#import "Customers.h"

@implementation CRMHelper


- (CRMHelper *) init
{
    self=[super init];
    return self;
}

#pragma mark Core Data Helper Methods

/****************************************************************************************/
//	This method tags activities to accounts in Zoho CRM.
/****************************************************************************************/

-(void) TagActivitiesToAccounts
{
    NSMutableArray * accountsArray = [[ NSMutableArray alloc] init];
    NSMutableArray * ActivityDummyArray = [[ NSMutableArray alloc] init];
    [accountsArray removeAllObjects];
    [ActivityDummyArray removeAllObjects];
    NSManagedObjectContext *context = SAppDelegateObject.managedObjectContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Accounts"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSError *error=nil;
    
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    [accountsArray addObjectsFromArray:fetchedObjects];
    
    fetchRequest = [[NSFetchRequest alloc] init];
    entity = [NSEntityDescription entityForName:@"Events"
                         inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    error=nil;
    
    fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    [ActivityDummyArray addObjectsFromArray:fetchedObjects];
    
    
    for ( int i =0; i< [accountsArray count]; i++)
    {
        Accounts *accountObject =[accountsArray objectAtIndex:i];
        
        NSMutableArray *activitiesArrayForAccounts = [[NSMutableArray alloc] init];
        [activitiesArrayForAccounts removeAllObjects];
        for ( int j=0; j<[ActivityDummyArray count]; j++)
        {
            Events *ActivityObject = [ActivityDummyArray objectAtIndex:j];
            
            if ( [accountObject.accountID isEqualToString:ActivityObject.relatedToAccountID] || [accountObject.accountID isEqualToString:ActivityObject.relatedToID] )
            {
                [activitiesArrayForAccounts addObject: ActivityObject];
                
            }
            
        }
        
        
        accountObject.eventsTaggedToAccount =[NSSet setWithArray:activitiesArrayForAccounts];
        [context updatedObjects];
        
    }
    
}

/****************************************************************************************/
//	This method tags activities to opportunities in Zoho CRM.
/****************************************************************************************/

- (void) TagActivitiesToOpportunities
{
    
    NSMutableArray * OpportunitySeperatorArray = [[ NSMutableArray alloc] init];
    NSMutableArray * ActivitySeperatorArray = [[ NSMutableArray alloc] init];
    [OpportunitySeperatorArray removeAllObjects];
    [ActivitySeperatorArray removeAllObjects];
    
    NSManagedObjectContext *context = SAppDelegateObject.managedObjectContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Opportunities"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSError *error=nil;
    
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    
    [OpportunitySeperatorArray addObjectsFromArray:fetchedObjects];
    
    
    fetchRequest = [[NSFetchRequest alloc] init];
    entity = [NSEntityDescription entityForName:@"Events"
                         inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    error=nil;
    
    fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    [ActivitySeperatorArray addObjectsFromArray:fetchedObjects];
    
    
    for ( int i =0; i< [OpportunitySeperatorArray count]; i++)
    {
        Opportunities *opportunityObject =[OpportunitySeperatorArray objectAtIndex:i];
        
        NSMutableArray *ActivityPotentialArray = [[NSMutableArray alloc] init];
        [ActivityPotentialArray removeAllObjects];
        for ( int j=0; j<[ActivitySeperatorArray count]; j++)
        {
            Events * ActivityObject = [ActivitySeperatorArray objectAtIndex:j];
            
            if ( [ActivityObject.relatedToPotentialID isEqualToString: opportunityObject.opportunityID] ||[ActivityObject.relatedToID isEqualToString:opportunityObject.opportunityID])
            {
                [ActivityPotentialArray addObject: ActivityObject];
            }
        }
        
        opportunityObject.eventsTaggedToOpportunity =[NSSet setWithArray:ActivityPotentialArray];
        [context updatedObjects];
        
    }
    
}

/****************************************************************************************/
//	This method tags activities to contacts in Zoho CRM.
/****************************************************************************************/

- (void) TagActivitiesToContact
{
    
    NSMutableArray * customersArray = [[ NSMutableArray alloc] init];
    NSMutableArray * ActivityDummyArray = [[ NSMutableArray alloc] init];
    [customersArray removeAllObjects];
    [ActivityDummyArray removeAllObjects];
    NSManagedObjectContext *context = SAppDelegateObject.managedObjectContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Customers"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSError *error=nil;
    
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];\
    NSLog(@"fetched:%@", fetchedObjects);
    
    [customersArray addObjectsFromArray:fetchedObjects];
    
    fetchRequest = [[NSFetchRequest alloc] init];
    entity = [NSEntityDescription entityForName:@"Events"
                         inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    error=nil;
    
    fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    [ActivityDummyArray addObjectsFromArray:fetchedObjects];
    
    for ( int i =0; i< [customersArray count]; i++)
    {
        Customers *customerObject =[customersArray objectAtIndex:i];
        
        NSMutableArray *activitiesArrayForCustomers = [[NSMutableArray alloc] init];
        [activitiesArrayForCustomers removeAllObjects];
        for ( int j=0; j<[ActivityDummyArray count]; j++)
        {
            Events *ActivityObject = [ActivityDummyArray objectAtIndex:j];
            
            if ( [customerObject.customerID isEqualToString:ActivityObject.relatedToID] || [customerObject.customerID isEqualToString:ActivityObject.relatedToContactID])
            {
                
                
                [activitiesArrayForCustomers addObject: ActivityObject];
                
            }
            
        }
        
        
        
        customerObject.eventsTaggedToCustomers =[NSSet setWithArray:activitiesArrayForCustomers];
        [context updatedObjects];
        
    }
    
    
}

/****************************************************************************************/
//	This method tags activities to Leads in Zoho CRM.
/****************************************************************************************/

- (void) TagEventsToLead
{
    
    NSMutableArray * customersArray = [[ NSMutableArray alloc] init];
    NSMutableArray * ActivityDummyArray = [[ NSMutableArray alloc] init];
    [customersArray removeAllObjects];
    [ActivityDummyArray removeAllObjects];
    NSManagedObjectContext *context = SAppDelegateObject.managedObjectContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:LEADS_MODULE
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSError *error=nil;
    
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    NSLog(@"fetched:%@", fetchedObjects);
    
    [customersArray addObjectsFromArray:fetchedObjects];
    
    fetchRequest = [[NSFetchRequest alloc] init];
    entity = [NSEntityDescription entityForName:@"Events"
                         inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    error=nil;
    
    fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    [ActivityDummyArray addObjectsFromArray:fetchedObjects];
    
    for ( int i =0; i< [customersArray count]; i++)
    {
        Leads *leadObject =[customersArray objectAtIndex:i];
        
        NSMutableArray *activitiesArrayForCustomers = [[NSMutableArray alloc] init];
        [activitiesArrayForCustomers removeAllObjects];
        for ( int j=0; j<[ActivityDummyArray count]; j++)
        {
            Events *ActivityObject = [ActivityDummyArray objectAtIndex:j];
            
            if ( [leadObject.leadID isEqualToString:ActivityObject.relatedToID])
            {
                
                [activitiesArrayForCustomers addObject: ActivityObject];
                
            }
            
        }
        
        
        
        leadObject.eventsTaggedToLead =[NSSet setWithArray:activitiesArrayForCustomers];
        
        NSError *error;
        if(! [context save:&error])
        {
            NSLog(@"Sorry Could not tag events to leads");
        }
    }
    
    
}


/****************************************************************************************/
// This method tags opportutnites to contacts in Zoho CRM.
/****************************************************************************************/

- (void) TagOpportunitiesToContact
{
    
    NSMutableArray * customersArray = [[ NSMutableArray alloc] init];
    NSMutableArray * opportunitiesArray = [[ NSMutableArray alloc] init];
    [customersArray removeAllObjects];
    [opportunitiesArray removeAllObjects];
    NSManagedObjectContext *context = SAppDelegateObject.managedObjectContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Customers"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSError *error=nil;
    
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    [customersArray addObjectsFromArray:fetchedObjects];
    
    fetchRequest = [[NSFetchRequest alloc] init];
    entity = [NSEntityDescription entityForName:@"Opportunities"
                         inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    error=nil;
    
    fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    [opportunitiesArray addObjectsFromArray:fetchedObjects];
    
    
    for ( int i =0; i< [customersArray count]; i++)
    {
        Customers *customerObject =[customersArray objectAtIndex:i];
        
        NSMutableArray *opportunitiesArrayForCustomers = [[NSMutableArray alloc] init];
        [opportunitiesArrayForCustomers removeAllObjects];
        for ( int j=0; j<[opportunitiesArray count]; j++)
        {
            Opportunities *opportunityObject = [opportunitiesArray objectAtIndex:j];
            
            if ( [customerObject.customerID isEqualToString:opportunityObject.opportunityRelatedToContactID])
            {
                [opportunitiesArrayForCustomers addObject: opportunityObject];
                
            }
            
        }
        
        customerObject.opportunitiesTaggedToCustomers =[NSSet setWithArray:opportunitiesArrayForCustomers];
        [context updatedObjects];
        
    }
    
}

/****************************************************************************************/
// This method tags opportunities to accounts in Zoho CRM.
/****************************************************************************************/

- (void) TagOpportunitiesToAccounts
{
    
    NSMutableArray * accountsArray = [[ NSMutableArray alloc] init];
    NSMutableArray * opportunitiesArray = [[ NSMutableArray alloc] init];
    [accountsArray removeAllObjects];
    [opportunitiesArray removeAllObjects];
    
    NSManagedObjectContext *context = SAppDelegateObject.managedObjectContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Accounts"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSError *error=nil;
    
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    [accountsArray addObjectsFromArray:fetchedObjects];
    
    fetchRequest = [[NSFetchRequest alloc] init];
    entity = [NSEntityDescription entityForName:@"Opportunities"
                         inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    error=nil;
    
    fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    [opportunitiesArray addObjectsFromArray:fetchedObjects];
    
    
    for ( int i =0; i< [accountsArray count]; i++)
    {
        Accounts *accountObject =[accountsArray objectAtIndex:i];
        
        NSMutableArray *opportunitiesArrayForAccounts = [[NSMutableArray alloc] init];
        [opportunitiesArrayForAccounts removeAllObjects];
        for ( int j=0; j<[opportunitiesArray count]; j++)
        {
            Opportunities *opportunityObject = [opportunitiesArray objectAtIndex:j];
            
            if ( [accountObject.accountID isEqualToString:opportunityObject.opportunityRelatedToAccountID])
            {
                [opportunitiesArrayForAccounts addObject: opportunityObject];
                
            }
            
        }
        
        
        accountObject.opportunitiesTaggedToAccount =[NSSet setWithArray:opportunitiesArrayForAccounts];
        [context updatedObjects];
        
    }
    
}

/****************************************************************************************/
// This method tags Notes to various modules in store.
/****************************************************************************************/

- (NSMutableSet *) fetchNotesforPrimaryID:(NSString *)ID
{
        
    NSManagedObjectContext *context = SAppDelegateObject.managedObjectContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Notes"
                                              inManagedObjectContext:context];

    [fetchRequest setEntity:entity];
    fetchRequest.predicate=[NSPredicate predicateWithFormat:@"noteRelatedToID == %@",ID];

    NSError *error=nil;
    
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    return [NSMutableSet setWithArray:fetchedObjects];
       
}


/****************************************************************************************/
// This method checks for a previoulsy existing item in Core data DB for any entity.
/****************************************************************************************/

- (BOOL)checkAttributeWithAttributeName:(NSString *)attributeName InEntityWithEntityName:(NSString *)entityName ForPreviousItems:(NSString *)itemValue inContext:(NSManagedObjectContext *)context
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

- (BOOL)checkAttributeWithAttributeName:(NSString *)attributeName InEntityWithEntityName:(NSString *)entityName ForPreviousItems:(NSString *)itemValue
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

- (void)deleteCRMTasksInTasksEntityInContext :(NSManagedObjectContext*)context
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

- (void)deleteCRMActivitiesInEventsEntityInContext :(NSManagedObjectContext*)context
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
