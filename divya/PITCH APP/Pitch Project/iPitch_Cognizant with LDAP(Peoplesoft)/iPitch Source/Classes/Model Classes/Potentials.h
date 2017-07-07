//
//  Potentials.h
//  iPitch V2
//
//  Created by Vineet on 28/02/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Potentials : NSObject

@property (nonatomic, retain) NSString * PotentialName;
@property ( nonatomic, retain) NSString *PotentialType;
@property ( nonatomic, retain) NSDate *ClosingDate;
@property ( nonatomic, retain) NSString *PotentialStage;
@property ( nonatomic, retain) NSString *PotentialProbability;
@property ( nonatomic, retain) NSString *PotentialRevenue;
@property ( nonatomic, retain) NSString *PotentialDescription;
@property ( nonatomic, retain) NSString *PotentialRelatedAccount;
@property ( nonatomic, retain) NSString *AccountID;
@property ( nonatomic, retain) NSString *AccountName;
@property ( nonatomic, retain) NSString *PotentialID;
@property ( nonatomic, retain) NSString *ContactID;
@property ( nonatomic, retain) NSString *ContactName;
@property ( nonatomic, retain) NSString *Amount;
@property ( nonatomic, retain)NSMutableArray * PotentialActivities;
@end
