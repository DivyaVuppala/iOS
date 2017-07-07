//
//  AddProductTableViewCell.m
//  Pitch
//
//  Created by Divya Vuppala on 03/04/15.
//  Copyright (c) 2015 CTS. All rights reserved.
//

#import "AddProductTableViewCell_iPhone.h"

@implementation AddProductTableViewCell_iPhone

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)deleteButton:(UIButton *)sender
{
    NSLog(@"deleted");
}
@end
