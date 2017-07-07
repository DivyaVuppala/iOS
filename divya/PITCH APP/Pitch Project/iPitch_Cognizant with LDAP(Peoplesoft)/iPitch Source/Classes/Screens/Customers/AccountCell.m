//
//  AccountCell.m
//  iPitch V2
//
//  Created by Swarnava on 12/07/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//

#import "AccountCell.h"
#import "iPitchConstants.h"
#import "Utils.h"

@implementation AccountCell

@synthesize companyName,companyId,customerIcon;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        companyName = [[UILabel alloc]initWithFrame:CGRectMake(10,5, 280, 33)];
        [companyName setTextAlignment:UITextAlignmentLeft];
        [companyName setBackgroundColor:[UIColor clearColor]];
        [companyName setNumberOfLines:1];
        [companyName setFont:[UIFont fontWithName:FONT_BOLD size:19]];
        companyName.textColor = [UIColor orangeColor];
        
        
        companyId = [[UILabel alloc]initWithFrame:CGRectMake(10, 35, 90, 30)];
        [companyId setTextAlignment:UITextAlignmentLeft];
        [companyId setBackgroundColor:[UIColor clearColor]];
        [companyId setNumberOfLines:1];
        [companyId setText:@"Opportunity ID:"];
        [companyId setFont:[UIFont fontWithName:FONT_BOLD size:15]];
        companyId.textColor = [UIColor colorWithRed:122.0/255 green:122.0/255 blue:122.0/255 alpha:1];
        
        [self addSubview:companyName];
        [self addSubview:companyId];
 
        
    }
    return self;
}

@end
