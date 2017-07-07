//
//  DocumentTileView.m
//  iPitch V2
//
//  Created by Sandhya Sandala on 12/02/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//

#import "DocumentTileView.h"
#import "iPitchConstants.h"
#import "Utils.h"

@implementation DocumentTileView
@synthesize docIcon, docModifiedDateLabel,docNameLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        docIcon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height-40)];
        [docIcon setBackgroundColor:[UIColor clearColor]];
        
        docNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, frame.size.height-40, frame.size.width, 20)];
        [docNameLabel setTextAlignment:UITextAlignmentLeft];
        [docNameLabel setBackgroundColor:[UIColor clearColor]];
        [docNameLabel setNumberOfLines:0];
        [docNameLabel setFont:[UIFont fontWithName:FONT_BOLD size:18]];
        //@"6d6c6c"
        docNameLabel.textColor= [Utils colorFromHexString:ORANGE_COLOR_CODE];
        
        
        docModifiedDateLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, frame.size.height-20, frame.size.width, 20)];
        [docModifiedDateLabel setTextAlignment:UITextAlignmentLeft];
        [docModifiedDateLabel setBackgroundColor:[UIColor clearColor]];
        [docModifiedDateLabel setNumberOfLines:0];
        [docModifiedDateLabel setFont:[UIFont fontWithName:FONT_REGULAR size:14]];
        //@"6d6c6c"
        docModifiedDateLabel.textColor= [Utils colorFromHexString:@"6d6c6c"];

        [self addSubview:docIcon];
        [self addSubview:docNameLabel];
        [self addSubview:docModifiedDateLabel];

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
