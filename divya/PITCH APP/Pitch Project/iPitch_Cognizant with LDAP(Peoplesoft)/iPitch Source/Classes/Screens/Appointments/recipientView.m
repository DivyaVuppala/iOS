//
//  recipientView.m
//  iPitch V2
//
//  Created by Satheeshwaran on 2/20/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//

#import "recipientView.h"
#import "iPitchConstants.h"
#import "Utils.h"

@implementation recipientView

@synthesize recipientIcon;
@synthesize recipientDesignation;
@synthesize recipientCompany;
@synthesize recipientContactNumber;
@synthesize recipientLocation;
@synthesize recipientName;
@synthesize recipient360Button;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.recipientIcon = [[UIImageView alloc]initWithFrame:CGRectMake(30, 5, 75, 75)];
        
        self.recipientName = [[UILabel alloc]initWithFrame:CGRectMake(135, 5, 150, 20)];
        [self.recipientName setFont:[UIFont fontWithName:FONT_BOLD size:18]];
        [self.recipientName setTextAlignment:UITextAlignmentLeft];
        [self.recipientName setBackgroundColor:[UIColor clearColor]];
        self.recipientName.textColor = [Utils colorFromHexString:@"275d75"];
        
  
        self.recipientDesignation = [[UILabel alloc]initWithFrame:CGRectMake(135, 30, 150, 20)];
        [self.recipientDesignation setFont:[UIFont fontWithName:FONT_BOLD size:14]];
        [self.recipientDesignation setTextAlignment:UITextAlignmentLeft];
        [self.recipientDesignation setBackgroundColor:[UIColor clearColor]];
        self.recipientDesignation.textColor = [Utils colorFromHexString:@"6d6c6c"];
        
        self.recipientCompany = [[UILabel alloc]initWithFrame:CGRectMake(135, 55, 150, 20)];
        [self.recipientCompany setFont:[UIFont fontWithName:FONT_BOLD size:14]];
        [self.recipientCompany setTextAlignment:UITextAlignmentLeft];
        [self.recipientCompany setBackgroundColor:[UIColor clearColor]];
        self.recipientCompany.textColor = [Utils colorFromHexString:@"6d6c6c"];
        
        
        self.recipientLocation = [[UILabel alloc]initWithFrame:CGRectMake(135, 80, 150, 20)];
        [self.recipientLocation setFont:[UIFont fontWithName:FONT_BOLD size:14]];
        [self.recipientLocation setTextAlignment:UITextAlignmentLeft];
        [self.recipientLocation setBackgroundColor:[UIColor clearColor]];
        self.recipientLocation.textColor = [Utils colorFromHexString:@"6d6c6c"];
        
        self.recipientContactNumber = [[UILabel alloc]initWithFrame:CGRectMake(135, 105, 150, 20)];
        [self.recipientContactNumber setFont:[UIFont fontWithName:FONT_BOLD size:14]];
        [self.recipientContactNumber setTextAlignment:UITextAlignmentLeft];
        [self.recipientContactNumber setBackgroundColor:[UIColor clearColor]];
        self.recipientContactNumber.textColor = [Utils colorFromHexString:@"6d6c6c"];
        
        
        
        self.recipient360Button=[[UIButton alloc]initWithFrame:CGRectMake(300, 5, 30, 30)];
        [self.recipient360Button setBackgroundImage:[UIImage imageNamed:@"360_icon.png"] forState:UIControlStateNormal];
        
        [self addSubview:self.recipientIcon];
        [self addSubview:self.recipientDesignation];
        [self addSubview:self.recipientName];
        [self addSubview:self.recipientDesignation];
        [self addSubview:self.recipientCompany];
        [self addSubview:self.recipientLocation];
        [self addSubview:self.recipientContactNumber];
        [self addSubview:recipient360Button];

    }
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
