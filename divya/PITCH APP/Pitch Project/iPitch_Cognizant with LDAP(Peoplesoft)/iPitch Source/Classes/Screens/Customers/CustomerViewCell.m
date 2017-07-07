//
//  CustomerViewCell.m
//  iPitch V2
//
//  Created by Krishna Chaitanya on 13/02/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//

#import "CustomerViewCell.h"
#import "iPitchConstants.h"
#import "Utils.h"

@implementation CustomerViewCell
@synthesize customerIcon, customerName, customerDesignation,customerCompany,opportunityId,opportunityIdValue,TVC,TVCValue,txtDesc,desc;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        customerName = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 280, 20)];
        [customerName setTextAlignment:UITextAlignmentLeft];
        [customerName setBackgroundColor:[UIColor clearColor]];
        [customerName setNumberOfLines:1];
        [customerName setFont:[UIFont fontWithName:FONT_BOLD size:17]];
        customerName.textColor = [UIColor orangeColor];
        
        
        opportunityId = [[UILabel alloc]initWithFrame:CGRectMake(10, 32, 90, 20)];
        [opportunityId setTextAlignment:UITextAlignmentLeft];
        [opportunityId setBackgroundColor:[UIColor clearColor]];
        [opportunityId setNumberOfLines:1];
        [opportunityId setText:@"Opportunity ID:"];
        [opportunityId setFont:[UIFont fontWithName:FONT_BOLD size:15]];
        opportunityId.textColor = [UIColor colorWithRed:122.0/255 green:122.0/255 blue:122.0/255 alpha:1];
        
        
        opportunityIdValue = [[UILabel alloc]initWithFrame:CGRectMake(105, 32, 70, 20)];
        [opportunityIdValue setTextAlignment:UITextAlignmentLeft];
        [opportunityIdValue setBackgroundColor:[UIColor clearColor]];
        [opportunityIdValue setNumberOfLines:1];
        [opportunityIdValue setFont:[UIFont fontWithName:FONT_REGULAR size:15]];
        opportunityIdValue.textColor = [UIColor colorWithRed:122.0/255 green:122.0/255 blue:122.0/255 alpha:1];
        
        
        TVC = [[UILabel alloc]initWithFrame:CGRectMake(175, 32, 50, 20)];
        [TVC setTextAlignment:UITextAlignmentLeft];
        [TVC setBackgroundColor:[UIColor clearColor]];
        [TVC setNumberOfLines:1];
        [TVC setText:@"TCV($)"];
        [TVC setFont:[UIFont fontWithName:FONT_BOLD size:15]];
        TVC.textColor = [UIColor colorWithRed:122.0/255 green:122.0/255 blue:122.0/255 alpha:1];
        
        
        TVCValue = [[UILabel alloc]initWithFrame:CGRectMake(219, 32, 78, 20)];
        [TVCValue setTextAlignment:UITextAlignmentLeft];
        [TVCValue setBackgroundColor:[UIColor clearColor]];
        [TVCValue setNumberOfLines:1];
        [TVCValue setFont:[UIFont fontWithName:FONT_REGULAR size:15]];
        TVCValue.textColor = [UIColor colorWithRed:122.0/255 green:122.0/255 blue:122.0/255 alpha:1];
        
        
        desc = [[UILabel alloc]initWithFrame:CGRectMake(10,55, 90, 20)];
        [desc setTextAlignment:UITextAlignmentLeft];
        [desc setBackgroundColor:[UIColor clearColor]];
        [desc setNumberOfLines:1];
        [desc setText:@"Company:"];
        [desc setFont:[UIFont fontWithName:FONT_BOLD size:15]];
        desc.textColor = [UIColor colorWithRed:122.0/255 green:122.0/255 blue:122.0/255 alpha:1];
        
        txtDesc = [[UILabel alloc]initWithFrame:CGRectMake(77,54,205,22)];
        [txtDesc setBackgroundColor:[UIColor clearColor]];
        [txtDesc setFont:[UIFont fontWithName:FONT_BOLD size:15]];
        [txtDesc setTextAlignment:UITextAlignmentLeft];
        txtDesc.textColor = [UIColor colorWithRed:122.0/255 green:122.0/255 blue:122.0/255 alpha:1];
        
        
        [self addSubview:customerName];
        [self addSubview:opportunityId];
        [self addSubview:opportunityIdValue];
        [self addSubview:TVC];
        [self addSubview:TVCValue];
        [self addSubview:txtDesc];
        [self addSubview:desc];
        
    }
    return self;
}



@end
