//
//  Opportunity.h
//  iPitch V2
//
//  Created by Swarnava on 08/07/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Opportunity : NSObject


@property (nonatomic, retain) NSString * OpportunityId;
@property (nonatomic, retain) NSString * OpportunityName;
@property (nonatomic, retain) NSString * CustomerName;
@property (nonatomic, retain) NSString * PrimaryContact;
@property (nonatomic, retain) NSString * SalesStage;
@property (nonatomic, retain) NSString * EstimatedClosedate;
@property (nonatomic, retain) NSString * Firstyear;
@property (nonatomic, retain) NSString * TCV;
@property (nonatomic, retain) NSString * ConfidencePercentage;
@property (nonatomic, retain) NSString * DealDuration;
@property (nonatomic, retain) NSString * FirstProject;
@property (nonatomic, retain) NSString * Strategic;
@property (nonatomic, retain) NSMutableArray *productArray;



@end
