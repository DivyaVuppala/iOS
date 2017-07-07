//
//  Lead.m
//  CRMNew
//
//  Created by Sandhya Sandala on 07/01/13.
//  Copyright (c) 2013 sandhya17@gmail.com. All rights reserved.
//

#import "Lead.h"

@implementation Lead

@synthesize  FirstName;
@synthesize  LastName;
@synthesize ContactID;

@synthesize Email, MailingCity, MailingCountry, MailingState, MailingStreet, MailingZIP, DateofBirth, Department, Description, ACCOUNTID, AccountName, skypeID, TwitterID,leadOpportunities,Phone;
@synthesize leadActivities,customerImageURL;

-(id)init
{
    if ((self = [super init]))
	{
    self.FirstName=@"";
    self.LastName=@"";
    self.ContactID=@"";
    self. Phone=@"";
    self.Email = @"";
    
    self.MailingZIP=@"";
    self.MailingStreet=@"";
    self.MailingState=@"";
    self.MailingCountry =@"";
    self.MailingCity = @"";
    
    self.AccountName=@"";
    self.ACCOUNTID=@"";
    self.skypeID=@"";
    self.TwitterID =@"";
    self.DateofBirth = @"";
    
    self.Description=@"";
    self.Department=@"";
    self.customerImageURL=@"";
 
    self.leadActivities = [[NSMutableArray alloc]init];
    self.leadOpportunities = [[NSMutableArray alloc]init];
    }
    return self;
}


@end
