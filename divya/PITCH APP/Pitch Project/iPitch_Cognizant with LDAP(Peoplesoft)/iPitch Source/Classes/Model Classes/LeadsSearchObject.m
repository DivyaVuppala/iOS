//
//  LeadsSearchObject.m
//  iPitch V2
//
//  Created by Satheeshwaran on 5/13/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//

#import "LeadsSearchObject.h"

@implementation LeadsSearchObject

@synthesize leadFirstName;
@synthesize leadOwner;
@synthesize leadCompany;
@synthesize leadTitle;
@synthesize leadEmailID;
@synthesize leadPhone;
@synthesize leadMobileNo;
@synthesize leadLastName;
@synthesize leadFax;
@synthesize leadWebsite;
@synthesize leadTwitterID;
@synthesize leadSource;
@synthesize leadStatus;
@synthesize numberOfEmployees;
@synthesize leadRating;
@synthesize leadSkypeID;
@synthesize leadLinkedInID;
@synthesize mailingCity;
@synthesize mailingCountry;
@synthesize mailingState;
@synthesize mailingStreet;
@synthesize mailingZIP;
@synthesize leadDescription;
@synthesize favouriteStatus;
@synthesize leadID;
@synthesize leadSalutation;
@synthesize leadImageURL;
@synthesize leadIndustry;
@synthesize annualRevenue;

-(id)init
{
    if ((self = [super init]))
	{
        self.leadFirstName=@"";
        self.leadOwner=@"";
        self.leadCompany=@"";
        self.leadTitle=@"";
        self.leadEmailID=@"";
        self.leadPhone=@"";
        self.leadMobileNo=@"";
        self.leadLastName=@"";
        self.leadFax=@"";
        self.leadWebsite=@"";
        self.leadTwitterID=@"";
        self.leadSource=@"";
        self.leadStatus=@"";
        self.numberOfEmployees=@"";
        self.leadRating=@"";
        self.leadSkypeID=@"";
        self.leadLinkedInID=@"";
        self.mailingCity=@"";
        self.mailingCountry=@"";
        self.mailingState=@"";
        self.mailingStreet=@"";
        self.mailingZIP=@"";
        self.leadDescription=@"";
        self.leadID=@"";
        self.leadSalutation=@"";
        self.leadImageURL=@"";
        self.leadIndustry=@"";
        self.annualRevenue=@"";
    }
    return self;
}

@end
