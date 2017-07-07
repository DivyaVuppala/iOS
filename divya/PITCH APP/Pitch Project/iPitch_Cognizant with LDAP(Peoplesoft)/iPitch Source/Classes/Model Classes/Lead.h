//
//  Lead.h
//  CRMNew
//
//  Created by Sandhya Sandala on 07/01/13.
//  Copyright (c) 2013 sandhya17@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Lead : NSObject


@property (nonatomic, retain) NSString *  FirstName;
@property ( nonatomic, retain) NSString * LastName;
@property ( nonatomic, retain) NSString * Email;
@property ( nonatomic, retain) NSString * ContactID;
@property ( nonatomic, retain) NSString * ACCOUNTID;
@property ( nonatomic, retain) NSString * AccountName;
@property ( nonatomic, retain) NSString * Department;
@property ( nonatomic, retain) NSString * DateofBirth;
@property ( nonatomic, retain) NSString * MailingStreet;
@property ( nonatomic, retain) NSString * MailingState;
@property ( nonatomic, retain) NSString * MailingCity;
@property ( nonatomic, retain) NSString * MailingZIP;
@property ( nonatomic, retain) NSString * MailingCountry;
@property ( nonatomic, retain) NSString * Description;
@property ( nonatomic, retain) NSString * skypeID;
@property ( nonatomic, retain) NSString * TwitterID;
@property ( nonatomic, retain) NSString * Phone;
@property ( nonatomic, retain) NSString * customerImageURL;

@property ( nonatomic, retain)NSMutableArray * leadActivities;
@property ( nonatomic, retain)NSMutableArray * leadOpportunities;


@end
